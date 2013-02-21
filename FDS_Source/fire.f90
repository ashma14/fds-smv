MODULE FIRE
 
! Compute combustion
 
USE PRECISION_PARAMETERS
USE GLOBAL_CONSTANTS
USE MESH_POINTERS
USE COMP_FUNCTIONS, ONLY: SECOND
 
IMPLICIT NONE
PRIVATE

ABSTRACT INTERFACE
   FUNCTION EXTINCT_TYPE(ZZ_IN,TMP_0,NR)
      USE GLOBAL_CONSTANTS, ONLY : EB, N_TRACKED_SPECIES
      LOGICAL EXTINCT_TYPE
      REAL(EB),INTENT(IN)::ZZ_IN(0:N_TRACKED_SPECIES),TMP_0
      INTEGER, INTENT(IN) :: NR
   END FUNCTION EXTINCT_TYPE
END INTERFACE

PROCEDURE (EXTINCT_TYPE), POINTER :: EXTINCT_N   
   
CHARACTER(255), PARAMETER :: fireid='$Id$'
CHARACTER(255), PARAMETER :: firerev='$Revision$'
CHARACTER(255), PARAMETER :: firedate='$Date$'

TYPE(REACTION_TYPE), POINTER :: RN=>NULL()
REAL(EB) :: Q_UPPER

PUBLIC COMBUSTION, GET_REV_fire

CONTAINS
 
SUBROUTINE COMBUSTION(NM)

INTEGER, INTENT(IN) :: NM
REAL(EB) :: TNOW

IF (EVACUATION_ONLY(NM)) RETURN

TNOW=SECOND()

IF (INIT_HRRPUV) RETURN

CALL POINT_TO_MESH(NM)

! Upper bounds on local HRR per unit volume

Q_UPPER = HRRPUA_SHEET/CELL_SIZE + HRRPUV_AVERAGE

! Call combustion ODE solver

CALL COMBUSTION_GENERAL

TUSED(10,NM)=TUSED(10,NM)+SECOND()-TNOW

END SUBROUTINE COMBUSTION


SUBROUTINE COMBUSTION_GENERAL

! Generic combustion routine for multi step reactions with kinetics either mixing controlled, finite rate, 
! or a temperature threshhold mixed approach

USE PHYSICAL_FUNCTIONS, ONLY: GET_SPECIFIC_GAS_CONSTANT,GET_MASS_FRACTION_ALL,GET_SPECIFIC_HEAT,GET_MOLECULAR_WEIGHT, &
                              GET_SENSIBLE_ENTHALPY_DIFF,GET_SENSIBLE_ENTHALPY
INTEGER :: I,J,K,NS,NR,II,JJ,KK,IIG,JJG,KKG,IW,N
REAL(EB):: ZZ_GET(0:N_TRACKED_SPECIES),ZZ_MIN=1.E-10_EB,DZZ(0:N_TRACKED_SPECIES),CP,HDIFF
LOGICAL :: DO_REACTION,REACTANTS_PRESENT,Q_EXISTS
TYPE (REACTION_TYPE),POINTER :: RN
TYPE (SPECIES_MIXTURE_TYPE), POINTER :: SM,SM0

Q          = 0._EB
D_REACTION = 0._EB
Q_EXISTS = .FALSE.
SM0 => SPECIES_MIXTURE(0)

SELECT CASE (EXTINCT_MOD)
   CASE(EXTINCTION_1)
      EXTINCT_N => EXTINCT_1
   CASE(EXTINCTION_2)
      EXTINCT_N => EXTINCT_2
END SELECT

!$OMP PARALLEL DEFAULT(NONE) &
!$OMP SHARED(KBAR,JBAR,IBAR,SOLID,CELL_INDEX,N_TRACKED_SPECIES,N_REACTIONS,REACTION,COMBUSTION_ODE,Q,RSUM,TMP,PBAR, &
!$OMP        PRESSURE_ZONE,RHO,ZZ,D_REACTION,SPECIES_MIXTURE,SM0,DT,CONSTANT_SPECIFIC_HEAT)

!$OMP DO SCHEDULE(STATIC) COLLAPSE(3)&
!$OMP PRIVATE(K,J,I,ZZ_GET,DO_REACTION,NR,RN,REACTANTS_PRESENT,ZZ_MIN,Q_EXISTS,SM,CP,HDIFF,DZZ)

DO K=1,KBAR
   DO J=1,JBAR
      ILOOP: DO I=1,IBAR
         !Check to see if a reaction is possible
         IF (SOLID(CELL_INDEX(I,J,K))) CYCLE ILOOP
         ZZ_GET(1:N_TRACKED_SPECIES) = ZZ(I,J,K,1:N_TRACKED_SPECIES)
         ZZ_GET(0) = 1._EB - MIN(1._EB,SUM(ZZ_GET(1:N_TRACKED_SPECIES)))
         DO_REACTION = .FALSE.
         REACTION_LOOP: DO NR=1,N_REACTIONS
            RN=>REACTION(NR)
            REACTANTS_PRESENT = .TRUE.
!            IF (RN%HEAT_OF_COMBUSTION > 0._EB) THEN
               DO NS=0,N_TRACKED_SPECIES
                  IF (RN%NU(NS)<0._EB .AND. ZZ_GET(NS) < ZZ_MIN) THEN
                     REACTANTS_PRESENT = .FALSE.
                     EXIT
                  ENDIF
               END DO
!               IF (.NOT. DO_REACTION) DO_REACTION = REACTANTS_PRESENT
!            ELSE
!               IF (RN%NU(RN%FUEL_SMIX_INDEX)<0._EB .AND. ZZ_GET(RN%FUEL_SMIX_INDEX) < ZZ_MIN) THEN
!                  REACTANTS_PRESENT = .FALSE.
!                  EXIT
!               ENDIF
!               IF (.NOT. DO_REACTION) DO_REACTION = REACTANTS_PRESENT            
!            ENDIF
             DO_REACTION = REACTANTS_PRESENT
             IF (DO_REACTION) EXIT REACTION_LOOP             
         END DO REACTION_LOOP
         IF (.NOT. DO_REACTION) CYCLE ILOOP
         DZZ(1:N_TRACKED_SPECIES) = ZZ_GET(1:N_TRACKED_SPECIES) ! store old ZZ for divergence term
         ! Call combustion integration routine
         CALL COMBUSTION_MODEL(I,J,K,ZZ_GET,Q(I,J,K))
         ! Update RSUM and ZZ
         Q_IF: IF (ABS(Q(I,J,K)) > TWO_EPSILON_EB) THEN
            Q_EXISTS = .TRUE.
            CALL GET_SPECIFIC_GAS_CONSTANT(ZZ_GET,RSUM(I,J,K)) 
            TMP(I,J,K) = PBAR(K,PRESSURE_ZONE(I,J,K))/(RSUM(I,J,K)*RHO(I,J,K))
            ZZ(I,J,K,1:N_TRACKED_SPECIES) = ZZ_GET(1:N_TRACKED_SPECIES)
            CP_IF: IF (.NOT.CONSTANT_SPECIFIC_HEAT) THEN
               ! Divergence term
               DZZ(1:N_TRACKED_SPECIES) = ZZ_GET(1:N_TRACKED_SPECIES) - DZZ(1:N_TRACKED_SPECIES)
               CALL GET_SPECIFIC_HEAT(ZZ_GET,CP,TMP(I,J,K))
               DO N=1,N_TRACKED_SPECIES
                  SM => SPECIES_MIXTURE(N)
                  CALL GET_SENSIBLE_ENTHALPY_DIFF(N,TMP(I,J,K),HDIFF)
                  D_REACTION(I,J,K) = D_REACTION(I,J,K) + ( (SM%RCON-SM0%RCON)/RSUM(I,J,K) - HDIFF/(CP*TMP(I,J,K)) )*DZZ(N)/DT
               ENDDO
            ENDIF CP_IF
         ENDIF Q_IF
      ENDDO ILOOP
   ENDDO
ENDDO
!$OMP END DO
!$OMP END PARALLEL

IF (.NOT. Q_EXISTS) RETURN

! Set Q in the ghost cell, just for better visualization.
DO IW=1,N_EXTERNAL_WALL_CELLS
   IF (WALL(IW)%BOUNDARY_TYPE/=INTERPOLATED_BOUNDARY .AND. WALL(IW)%BOUNDARY_TYPE/=OPEN_BOUNDARY) CYCLE
   II  = WALL(IW)%ONE_D%II
   JJ  = WALL(IW)%ONE_D%JJ
   KK  = WALL(IW)%ONE_D%KK
   IIG = WALL(IW)%ONE_D%IIG
   JJG = WALL(IW)%ONE_D%JJG
   KKG = WALL(IW)%ONE_D%KKG
   Q(II,JJ,KK) = Q(IIG,JJG,KKG)
ENDDO

END SUBROUTINE COMBUSTION_GENERAL
   
SUBROUTINE COMBUSTION_MODEL(I,J,K,ZZ_GET,Q_OUT)
USE COMP_FUNCTIONS, ONLY: SHUTDOWN
USE PHYSICAL_FUNCTIONS, ONLY: LES_FILTER_WIDTH_FUNCTION, GET_AVERAGE_SPECIFIC_HEAT
INTEGER,INTENT(IN):: I,J,K
REAL(EB),INTENT(OUT):: Q_OUT
REAL(EB),INTENT(INOUT) :: ZZ_GET(0:N_TRACKED_SPECIES)
REAL(EB) :: ZZ_0(0:N_TRACKED_SPECIES),DZZDT1_1(0:N_TRACKED_SPECIES),DZZDT1_2(0:N_TRACKED_SPECIES),DZZDT2_1(0:N_TRACKED_SPECIES), &
            DZZDT2_2(0:N_TRACKED_SPECIES),DZZDT4_1(0:N_TRACKED_SPECIES),DZZDT4_2(0:N_TRACKED_SPECIES),RATE_CONSTANT(1:N_REACTIONS),&
            RATE_CONSTANT2(1:N_REACTIONS),ERR_EST,ERR_TOL,ZZ_TEMP(0:N_TRACKED_SPECIES),&
            A1(0:N_TRACKED_SPECIES),A2(0:N_TRACKED_SPECIES),A4(0:N_TRACKED_SPECIES),Q_SUM,Q_CALC,&
            DT_SUB,DT_SUB_NEW,DT_ITER,ZZ_STORE(0:N_TRACKED_SPECIES,0:3),TV(0:2),ZZ_DIFF(0:2),&
            ZZ_MIXED(0:N_TRACKED_SPECIES),ZZ_GET_0(0:N_TRACKED_SPECIES),ZETA0,ZETA,ZETA1,CELL_VOLUME,CELL_MASS,&
            DZZDT(0:N_TRACKED_SPECIES),SMIX_MIX_MASS(0:N_TRACKED_SPECIES,0:1),TOTAL_MIX_MASS(0:1),TAU_D,TAU_G,TAU_U,DELTA,&
            TMP_GUESS_1,TMP_GUESS_2,CP_BAR_GUESS,CP_BAR_0,TMP_0,ZZ_CHECK(0:N_TRACKED_SPECIES)
REAL(EB), PARAMETER :: DT_SUB_MIN=1.E-10_EB,ZZ_MIN=1.E-10_EB,RADIATIVE_FRACTION = 0.35_EB
INTEGER :: NR,NS,NSS,ITER,TVI,RICH_ITER,TMP_ITER,TIME_ITER,TIME_ITER_MAX
INTEGER, PARAMETER :: SUB_DT1=1,SUB_DT2=2,SUB_DT4=4,TV_ITER_MIN=5,RICH_ITER_MAX=50
TYPE(REACTION_TYPE),POINTER :: RN=>NULL()

TIME_ITER_MAX= HUGE(0)

IF (FIXED_MIX_TIME>0._EB) THEN
   MIX_TIME(I,J,K)=FIXED_MIX_TIME
ELSE
   DELTA = LES_FILTER_WIDTH_FUNCTION(DX(I),DY(J),DZ(K))
   TAU_D=0._EB
   DO NR =1,N_REACTIONS
      RN => REACTION(NR)
      TAU_D = MAX(TAU_D,D_Z(MIN(4999,NINT(TMP(I,J,K))),RN%FUEL_SMIX_INDEX))
   ENDDO
   TAU_D = DELTA**2/TAU_D
   IF (LES) THEN
      TAU_U = C_DEARDORFF*SC*RHO(I,J,K)*DELTA**2/MU(I,J,K) ! turbulent mixing time scale, tau_u=delta/sqrt(ksgs)
      TAU_G = SQRT(2._EB*DELTA/(GRAV+1.E-10_EB)) ! acceleration time scale
      MIX_TIME(I,J,K)=MAX(TAU_CHEM,MIN(TAU_D,TAU_U,TAU_G,TAU_FLAME)) ! Eq. 7, McDermott, McGrattan, Floyd
   ELSE
      MIX_TIME(I,J,K)= TAU_D
   ENDIF
ENDIF 

TMP_0 = TMP(I,J,K)
ZZ_STORE(:,:) = 0._EB
Q_OUT = 0._EB
Q_CALC = 0._EB
Q_SUM = 0._EB
ITER= 0
DT_ITER = 0._EB
DT_SUB = DT 
DT_SUB_NEW = DT
ERR_TOL = RICHARDSON_ERROR_TOLERANCE

ZZ_GET_0 = ZZ_GET
ZZ_TEMP = ZZ_GET_0
ZZ_MIXED = ZZ_GET_0
ZETA0 = INITIAL_UNMIXED_FRACTION
ZETA  = ZETA0
ZETA1 = ZETA0
CELL_VOLUME = DX(I)*DY(J)*DZ(K)
CELL_MASS = RHO(I,J,K)*CELL_VOLUME
DO NS=0,1
   TOTAL_MIX_MASS(NS) = (1._EB-ZETA0)*CELL_MASS
   SMIX_MIX_MASS(:,NS) = ZZ_GET*TOTAL_MIX_MASS(NS)
ENDDO

INTEGRATION_LOOP: DO TIME_ITER = 1,TIME_ITER_MAX
   ZETA1 = ZETA0*EXP(-(DT_ITER+DT_SUB)/MIX_TIME(I,J,K))
   SMIX_MIX_MASS(:,1) = MAX(0._EB,SMIX_MIX_MASS(:,0) + (ZETA-ZETA1)*CELL_MASS*ZZ_GET_0)
   TOTAL_MIX_MASS(1) = SUM(SMIX_MIX_MASS(:,1))
   ZZ_MIXED = SMIX_MIX_MASS(:,1)/(TOTAL_MIX_MASS(1))

   RK2_IF: IF (COMBUSTION_ODE /= RK2_RICHARDSON) THEN ! Explicit Euler
      ZZ_0 = MAX(0._EB,ZZ_MIXED)
      DZZDT1_1 = 0._EB
      RATE_CONSTANT = 0._EB
      REACTION_LOOP1: DO NR = 1, N_REACTIONS
         RN => REACTION(NR)
         CALL COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT(NR),ZZ_0,I,J,K,DT_SUB,ITER,TMP_0)
         DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
         ZZ_CHECK = ZZ_0 + (DZZDT1_1+DZZDT)*DT_SUB
         IF (ANY(ZZ_CHECK < 0._EB)) THEN
            DO NSS=0,N_TRACKED_SPECIES
               IF (ZZ_CHECK(NSS) < 0._EB .AND. ABS(DZZDT(NSS))>TWO_EPSILON_EB) THEN
                  RATE_CONSTANT(NR) = MIN(RATE_CONSTANT(NR),ZZ_0(NSS)/(ABS(RN%NU_MW_O_MW_F(NSS))*DT_SUB))
               ENDIF
            ENDDO
            DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
         ENDIF
         DZZDT1_1 = DZZDT1_1+DZZDT
      ENDDO REACTION_LOOP1 
      A1 = ZZ_0 + DZZDT1_1*DT_SUB
      ZZ_MIXED = A1
      IF (TIME_ITER > 1) CALL SHUTDOWN('ERROR: Error in Simple Chemistry')
      IF (ALL(DZZDT1_1 < 0._EB)) EXIT INTEGRATION_LOOP
   ELSE RK2_IF ! RK2 w/ Richardson
      ERR_EST = 10._EB*ERR_TOL
      RICH_EX_LOOP: DO RICH_ITER =1,RICH_ITER_MAX
         DT_SUB = DT_SUB_NEW

         !--------------------
         ! Calculate A1 term
         ! Time step = DT_SUB
         !--------------------
         ZZ_0 = MAX(0._EB,ZZ_MIXED)
         ODE_LOOP1: DO NS = 1, SUB_DT1
            DZZDT1_1 = 0._EB
            DZZDT1_2 = 0._EB
            RATE_CONSTANT = 0._EB
            RATE_CONSTANT2 = 0._EB
            REACTION_LOOP1_1: DO NR = 1, N_REACTIONS
               RN => REACTION(NR)
               CALL COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT(NR),ZZ_0,I,J,K,DT_SUB,ITER,TMP_0)
               DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
               ZZ_CHECK = ZZ_0 + (DZZDT1_1+DZZDT)*DT_SUB
               IF (ANY(ZZ_CHECK < 0._EB)) THEN
                  DO NSS=0,N_TRACKED_SPECIES
                     IF (ZZ_CHECK(NSS) < 0._EB .AND. ABS(DZZDT(NSS))>TWO_EPSILON_EB) THEN
                        RATE_CONSTANT(NR) = MIN(RATE_CONSTANT(NR),ZZ_0(NSS)/(ABS(RN%NU_MW_O_MW_F(NSS))*DT_SUB))
                     ENDIF
                  ENDDO
                  DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
               ENDIF
               DZZDT1_1 = DZZDT1_1+DZZDT
            ENDDO REACTION_LOOP1_1
            A1 = ZZ_0 + DZZDT1_1*DT_SUB

            REACTION_LOOP1_2: DO NR = 1, N_REACTIONS
               RN => REACTION(NR)
               CALL COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT2(NR),A1,I,J,K,DT_SUB,ITER,TMP_0)
               DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT2(NR)
               ZZ_CHECK = A1 + (DZZDT1_2+DZZDT)*DT_SUB
               IF (ANY(ZZ_CHECK < 0._EB)) THEN
                  DO NSS=0,N_TRACKED_SPECIES
                     IF (ZZ_CHECK(NSS) < 0._EB .AND. ABS(DZZDT(NSS))>TWO_EPSILON_EB) THEN
                        RATE_CONSTANT2(NR) = MIN(RATE_CONSTANT2(NR),A1(NSS)/(ABS(RN%NU_MW_O_MW_F(NSS))*DT_SUB))
                     ENDIF
                  ENDDO
                  DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT2(NR)
               ENDIF
               DZZDT1_2 = DZZDT1_2+DZZDT
            ENDDO REACTION_LOOP1_2
            A1 = A1 + DZZDT1_2*DT_SUB
            A1 = 0.5_EB*(ZZ_0 + A1)
         ENDDO ODE_LOOP1
         !--------------------
         ! Calculate A2 term
         ! Time step = DT_SUB/2
         !--------------------
         ZZ_0 = MAX(0._EB,ZZ_MIXED)
         ODE_LOOP2: DO NS = 1, SUB_DT2
            DZZDT2_1 = 0._EB
            DZZDT2_2 = 0._EB
            RATE_CONSTANT = 0._EB
            RATE_CONSTANT2 = 0._EB
            REACTION_LOOP2_1: DO NR = 1, N_REACTIONS
               RN => REACTION(NR)
               CALL COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT(NR),ZZ_0,I,J,K,DT_SUB,ITER,TMP_0)
               DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
               ZZ_CHECK = ZZ_0 + (DZZDT2_1+DZZDT)*(DT_SUB*0.5_EB)
               IF (ANY(ZZ_CHECK < 0._EB)) THEN
                  DO NSS=0,N_TRACKED_SPECIES
                     IF (ZZ_CHECK(NSS) < 0._EB .AND. ABS(DZZDT(NSS))>TWO_EPSILON_EB) THEN
                        RATE_CONSTANT(NR) = MIN(RATE_CONSTANT(NR),ZZ_0(NSS)/(ABS(RN%NU_MW_O_MW_F(NSS))*DT_SUB*0.5_EB))
                     ENDIF
                  ENDDO
                  DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
               ENDIF
               DZZDT2_1 = DZZDT2_1+DZZDT
            ENDDO REACTION_LOOP2_1
            A2 = ZZ_0 + DZZDT2_1*(DT_SUB*0.5_EB)
                  
            REACTION_LOOP2_2: DO NR = 1, N_REACTIONS
               RN => REACTION(NR)
               CALL COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT2(NR),A2,I,J,K,DT_SUB,ITER,TMP_0)
               DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT2(NR)
               ZZ_CHECK = A2 + (DZZDT2_2+DZZDT)*(DT_SUB*0.5_EB)
               IF (ANY(ZZ_CHECK < 0._EB)) THEN
                  DO NSS=0,N_TRACKED_SPECIES
                     IF (ZZ_CHECK(NSS) < 0._EB .AND. ABS(DZZDT(NSS))>TWO_EPSILON_EB) THEN
                        RATE_CONSTANT2(NR) = MIN(RATE_CONSTANT2(NR),A2(NSS)/(ABS(RN%NU_MW_O_MW_F(NSS))*DT_SUB*0.5_EB))
                     ENDIF
                  ENDDO
                  DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT2(NR)
               ENDIF
               DZZDT2_2 = DZZDT2_2+DZZDT
            ENDDO REACTION_LOOP2_2
            A2 = A2 + DZZDT2_2*(DT_SUB*0.5_EB)
            A2 = 0.5_EB*(ZZ_0 + A2)
            ZZ_0 = A2
         ENDDO ODE_LOOP2
         !--------------------
         ! Calculate A4 term  
         ! Time step = DT_SUB/4
         !-------------------- 
         ZZ_0 = MAX(0._EB,ZZ_MIXED)
         ODE_LOOP4: DO NS = 1, SUB_DT4
            DZZDT4_1 = 0._EB
            DZZDT4_2 = 0._EB
            RATE_CONSTANT = 0._EB
            RATE_CONSTANT2 = 0._EB
            REACTION_LOOP4_1: DO NR = 1, N_REACTIONS
               RN => REACTION(NR)
               CALL COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT(NR),ZZ_0,I,J,K,DT_SUB,ITER,TMP_0)
               DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
               ZZ_CHECK = ZZ_0 + (DZZDT4_1+DZZDT)*(DT_SUB*0.25_EB)
               IF (ANY(ZZ_CHECK < 0._EB)) THEN
                  DO NSS=0,N_TRACKED_SPECIES
                     IF (ZZ_CHECK(NSS) < 0._EB .AND. ABS(DZZDT(NSS))>TWO_EPSILON_EB) THEN
                        RATE_CONSTANT(NR) = MIN(RATE_CONSTANT(NR),ZZ_0(NSS)/(ABS(RN%NU_MW_O_MW_F(NSS))*DT_SUB*0.25_EB))
                     ENDIF
                  ENDDO
                  DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT(NR)
               ENDIF
               DZZDT4_1 = DZZDT4_1+DZZDT
            END DO REACTION_LOOP4_1
            A4 = ZZ_0 + DZZDT4_1*(DT_SUB*0.25_EB)

            REACTION_LOOP4_2: DO NR = 1, N_REACTIONS
               RN => REACTION(NR)
               CALL COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT2(NR),A4,I,J,K,DT_SUB,ITER,TMP_0)
               DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT2(NR)
               ZZ_CHECK = A4 + (DZZDT4_2+DZZDT)*(DT_SUB*0.25_EB)
               IF (ANY(ZZ_CHECK < 0._EB)) THEN
                  DO NSS=0,N_TRACKED_SPECIES
                     IF (ZZ_CHECK(NSS) < 0._EB .AND. ABS(DZZDT(NSS))>TWO_EPSILON_EB) THEN
                        RATE_CONSTANT2(NR) = MIN(RATE_CONSTANT2(NR),A4(NSS)/(ABS(RN%NU_MW_O_MW_F(NSS))*DT_SUB*0.25_EB))
                     ENDIF
                  ENDDO
                  DZZDT = RN%NU_MW_O_MW_F*RATE_CONSTANT2(NR)
               ENDIF
               DZZDT4_2 = DZZDT4_2+DZZDT
            ENDDO REACTION_LOOP4_2
            A4 = A4 + DZZDT4_2*(DT_SUB*0.25_EB)
            A4 = 0.5_EB*(ZZ_0 + A4)
            ZZ_0 = A4
         ENDDO ODE_LOOP4
         ZZ_MIXED = (4._EB*A4-A2)*ONTH
         ! Species Error Analysis
         ERR_EST = MAXVAL(ABS((4._EB*A4-5._EB*A2+A1)))/45._EB  ! Estimate Error
         IF (ERR_EST <= TWO_EPSILON_EB) THEN
            DT_SUB_NEW = DT
         ELSE
            DT_SUB_NEW = MAX(DT_SUB*(ERR_TOL/(ERR_EST))**(0.25_EB),DT_SUB_MIN) ! Determine New Time Step
         ENDIF
         IF (ERR_EST > ERR_TOL) THEN   
            ZETA1 = ZETA0*EXP(-(DT_ITER+DT_SUB_NEW)/MIX_TIME(I,J,K))
            SMIX_MIX_MASS(:,1) =  MAX(0._EB,SMIX_MIX_MASS(:,0) + (ZETA-ZETA1)*CELL_MASS*ZZ_GET_0)
            TOTAL_MIX_MASS(1) = SUM(SMIX_MIX_MASS(:,1))
            ZZ_MIXED = SMIX_MIX_MASS(:,1)/(TOTAL_MIX_MASS(1))
         ENDIF
         IF (DT_SUB <= DT_SUB_MIN) EXIT RICH_EX_LOOP
         IF (ERR_EST < ERR_TOL) EXIT RICH_EX_LOOP
      ENDDO RICH_EX_LOOP
   ENDIF RK2_IF
  
   DT_ITER = DT_ITER + DT_SUB
   ITER = ITER + 1
   MAX_CHEM_SUBIT = MAX(MAX_CHEM_SUBIT,ITER)
   ZZ_GET =  ZETA1*ZZ_GET_0 + (1._EB-ZETA1)*ZZ_MIXED !Combine mixed and unmixed 
!   IF (ABS(SUM(ZZ_GET-ZZ_TEMP)) > TWO_EPSILON_EB) CALL SHUTDOWN('ERROR: Error in Species')

   ! Heat Release
   Q_SUM = 0._EB
   IF (MAXVAL(ABS(ZZ_GET-ZZ_TEMP)) > ZZ_MIN) THEN
      Q_SUM = Q_SUM - RHO(I,J,K)*SUM(SPECIES_MIXTURE%H_F*(ZZ_GET-ZZ_TEMP))
!      DO NSS = 0,N_TRACKED_SPECIES
!         Q_SUM = Q_SUM - SPECIES_MIXTURE(NSS)%H_F*RHO(I,J,K)*(ZZ_GET(NSS)-ZZ_TEMP(NSS))
!      ENDDO
   ENDIF
   IF (Q_CALC + Q_SUM > Q_UPPER*DT_ITER) THEN
      Q_OUT = Q_UPPER
      ZZ_GET = ZZ_TEMP + (Q_UPPER*DT_ITER/(Q_CALC + Q_SUM))*(ZZ_GET-ZZ_TEMP)
      EXIT INTEGRATION_LOOP
   ELSE 
      Q_CALC = Q_CALC+Q_SUM
      Q_OUT = Q_CALC/DT 
   ENDIF 
   
   IF (TEMPERATURE_DEPENDENT_REACTION) THEN
      IF (DT_ITER + DT_SUB < DT) THEN !Local update to T if sub iterations are taken
         TMP_GUESS_1 = TMP_0
         TMP_ITER = 0
         CALL GET_AVERAGE_SPECIFIC_HEAT(ZZ_GET_0,CP_BAR_0,TMP(I,J,K))
         DO TMP_ITER = 1,4
            CALL GET_AVERAGE_SPECIFIC_HEAT(ZZ_GET_0,CP_BAR_GUESS,TMP_GUESS_1)
            TMP_GUESS_2 = (CP_BAR_0*TMP(I,J,K) + (1-RADIATIVE_FRACTION)*Q_CALC/RHO(I,J,K))/CP_BAR_GUESS
            TMP_GUESS_1 = 0.5_EB*(TMP_GUESS_2 + TMP_GUESS_1)
         ENDDO  
         TMP_0 = TMP_GUESS_2
      ENDIF
   ENDIF
   
   !Total Variation Scheme
   IF (N_REACTIONS > 1) THEN
      DO NS = 0,N_TRACKED_SPECIES
         DO TVI = 0,2
            ZZ_STORE(NS,TVI)=ZZ_STORE(NS,TVI+1)
         ENDDO
         ZZ_STORE(NS,3) = ZZ_GET(NS)
      ENDDO
      IF (ITER > 3) THEN
         REACTION_LOOP_TV: DO NR = 1, N_REACTIONS
            RN => REACTION(NR)
            DO TVI = 0,2
               TV(TVI) = ABS(ZZ_STORE(RN%FUEL_SMIX_INDEX,TVI+1)-ZZ_STORE(RN%FUEL_SMIX_INDEX,TVI))
               ZZ_DIFF(TVI) = ZZ_STORE(RN%FUEL_SMIX_INDEX,TVI+1)-ZZ_STORE(RN%FUEL_SMIX_INDEX,TVI)
            ENDDO
            IF (SUM(TV) > 0.0_EB .AND. SUM(TV) >= ABS(2.5_EB*SUM(ZZ_DIFF)) .AND. ITER >= TV_ITER_MIN) EXIT INTEGRATION_LOOP
         ENDDO REACTION_LOOP_TV
      ENDIF
   ENDIF
   ZZ_TEMP = ZZ_GET
   SMIX_MIX_MASS(:,0) = ZZ_MIXED*TOTAL_MIX_MASS(1)
   ZETA = ZETA1
   IF (DT_ITER >= DT) EXIT INTEGRATION_LOOP
ENDDO INTEGRATION_LOOP

CONTAINS

REAL(EB) FUNCTION KSGS(I,J,K)
INTEGER, INTENT(IN) :: I,J,K
REAL(EB) :: EPSK
! ke dissipation rate, assumes production=dissipation
EPSK = MU(I,J,K)*STRAIN_RATE(I,J,K)**2/RHO(I,J,K)
KSGS = 2.25_EB*(EPSK*DELTA/PI)**TWTH  ! estimate of subgrid ke, from Kolmogorov spectrum
END FUNCTION KSGS

END SUBROUTINE COMBUSTION_MODEL

RECURSIVE SUBROUTINE COMPUTE_RATE_CONSTANT(NR,RATE_CONSTANT,ZZ_MIXED_IN,I,J,K,DT_SUB,ITER,TMP_0)
USE PHYSICAL_FUNCTIONS, ONLY : GET_MASS_FRACTION_ALL
USE MATH_FUNCTIONS, ONLY: EVALUATE_RAMP
REAL(EB), INTENT(IN) :: ZZ_MIXED_IN(0:N_TRACKED_SPECIES),DT_SUB,TMP_0
INTEGER, INTENT(IN) :: NR,I,J,K,ITER
REAL(EB), INTENT(INOUT) :: RATE_CONSTANT
REAL(EB) :: YY_PRIMITIVE(1:N_SPECIES),DZ_F(1:N_REACTIONS),DZ_FR(1:N_REACTIONS),DZ_FRAC_F(1:N_REACTIONS),DZ_FRAC_FR(1:N_REACTIONS),&
            MASS_OX,MASS_OX_STOICH,AA(1:N_REACTIONS),EE(1:N_REACTIONS),EQ_RATIO,ZZ_MIXED_FR(0:N_TRACKED_SPECIES)
REAL(EB), PARAMETER :: ZZ_MIN=1.E-10_EB
LOGICAL :: EXTINCT(1:N_REACTIONS)
INTEGER :: NS,NRR
TYPE(REACTION_TYPE),POINTER :: RN=>NULL(),RNN=>NULL()
RN => REACTION(NR)

ZZ_MIXED_FR = ZZ_MIXED_IN
MASS_OX = 0._EB
MASS_OX_STOICH = 0._EB
EQ_RATIO = 0._EB

IF(RN%HEAT_OF_COMBUSTION > 0._EB) THEN
   DO NS = 0,N_TRACKED_SPECIES
      IF (RN%NU(NS) < 0._EB .AND. NS /= RN%FUEL_SMIX_INDEX) MASS_OX = ZZ_MIXED_IN(NS) ! Mass O2 in cell
   ENDDO
   DO NRR = 1,N_REACTIONS
      RNN => REACTION(NRR)
      AA(NRR) = RNN%A
      EE(NRR) = RNN%E
      DO NS = 0,N_TRACKED_SPECIES
         IF (RNN%NU(NS) < 0._EB .AND. NS /= RNN%FUEL_SMIX_INDEX) &
            MASS_OX_STOICH = MASS_OX_STOICH + ABS(ZZ_MIXED_IN(RNN%FUEL_SMIX_INDEX)*RNN%NU_MW_O_MW_F(NS)) !Stoich mass O2
      ENDDO
   ENDDO
ENDIF
EQ_RATIO = MASS_OX_STOICH/(MASS_OX + TWO_EPSILON_EB)
DO NRR = 1,N_REACTIONS
   RNN => REACTION(NRR)
   IF (RNN%A_RAMP_INDEX > 0 .OR. RNN%E_RAMP_INDEX > 0) THEN
      IF (RNN%A_RAMP_INDEX > 0) AA(NRR) = AA(NRR)*EVALUATE_RAMP(EQ_RATIO,0._EB,RNN%A_RAMP_INDEX)
      IF (RNN%E_RAMP_INDEX > 0) EE(NRR) = EE(NRR)*EVALUATE_RAMP(EQ_RATIO,0._EB,RNN%E_RAMP_INDEX)
      IF (AA(NRR) >= 1.E16_EB .AND. ABS(EE(NRR)) < TWO_EPSILON_EB) THEN ! determine if reaction is fast or finite
         RNN%FAST_CHEMISTRY = .TRUE.
      ELSE
         RNN%FAST_CHEMISTRY = .FALSE.
      ENDIF
   ENDIF   
ENDDO

EXTINCT(:) = .FALSE.
IF (RN%FAST_CHEMISTRY) THEN
   DO NRR = 1,N_REACTIONS
      RNN => REACTION(NRR)
      IF (.NOT. RNN%FAST_CHEMISTRY) THEN
         EXTINCT(NRR) = .TRUE.
      ELSE
         IF_SUPPRESSION: IF (SUPPRESSION .AND. RN%HEAT_OF_COMBUSTION > 0._EB .AND. ITER==0) THEN
            IF (EXTINCT_N(ZZ_MIXED_IN,TMP_0,NR)) THEN
               EXTINCT(NRR) = .TRUE.
            ELSE
               EXTINCT(NRR) = .FALSE.
            ENDIF
         ENDIF IF_SUPPRESSION
      ENDIF
   ENDDO
   IF (ALL(EXTINCT)) THEN
      RATE_CONSTANT = 0._EB
      RETURN
   ENDIF 
ENDIF

IF (MASS_OX_STOICH > MASS_OX .AND. RN%HEAT_OF_COMBUSTION > 0._EB ) THEN ! Potentially oxygen limited by all reactions
   DZ_F(:) = 0._EB
   DZ_FR(:) = 0._EB
   DZ_FRAC_F(:) = 0._EB
   DZ_FRAC_FR(:) = 0._EB
   DO NRR = 1,N_REACTIONS
      RNN => REACTION(NRR)
      IF (RNN%FAST_CHEMISTRY) THEN
         DO NS = 0,N_TRACKED_SPECIES
            IF (RNN%NU(NS) < 0._EB) &
               ZZ_MIXED_FR(NS) = ZZ_MIXED_FR(NS) - ABS(ZZ_MIXED_IN(NS)/RNN%NU_MW_O_MW_F(NS))
               ZZ_MIXED_FR(NS) = MAX(0._EB,ZZ_MIXED_FR(NS)) 
         ENDDO
      ENDIF   
   ENDDO
   DO NRR = 1,N_REACTIONS
      RNN => REACTION(NRR)      
      IF (.NOT. RNN%FAST_CHEMISTRY .AND. RNN%HEAT_OF_COMBUSTION > 0._EB) THEN
         CALL GET_MASS_FRACTION_ALL(ZZ_MIXED_FR,YY_PRIMITIVE)
         DZ_FR(NRR) = AA(NRR)*RHO(I,J,K)**RNN%RHO_EXPONENT*EXP(-EE(NRR)/(R0*TMP_0))*TMP_0**RNN%N_T
         IF (ALL(RNN%N_S<-998._EB)) THEN
            DO NS=0,N_TRACKED_SPECIES
               IF(RNN%NU(NS) < 0._EB .AND. ZZ_MIXED_FR(NS) < ZZ_MIN) THEN
                  DZ_FR(NRR) = 0._EB
               ENDIF
            ENDDO
         ELSE
            DO NS=1,N_SPECIES
               IF(ABS(RNN%N_S(NS)) <= TWO_EPSILON_EB) CYCLE
               IF(RNN%N_S(NS)>= -998._EB) THEN
                  IF (YY_PRIMITIVE(NS) < ZZ_MIN) THEN
                     DZ_FR(NRR) = 0._EB
                  ELSE
                     DZ_FR(NRR) = YY_PRIMITIVE(NS)**RNN%N_S(NS)*DZ_FR(NRR)
                  ENDIF
               ENDIF
            ENDDO
         ENDIF
      ENDIF              
      IF (RNN%HEAT_OF_COMBUSTION > 0._EB) THEN
         DZ_F(NRR) = 1.E10_EB
         IF (.NOT. RNN%FAST_CHEMISTRY) THEN
            DO NS = 0,N_TRACKED_SPECIES
               IF (RNN%NU(NS) < 0._EB) THEN            
                  DZ_F(NRR) = MIN(DZ_F(NRR),-ZZ_MIXED_FR(NS)/RNN%NU_MW_O_MW_F(NS))
               ENDIF      
            ENDDO
         ELSE
            DO NS = 0,N_TRACKED_SPECIES
               IF (RNN%NU(NS) < 0._EB) THEN            
                  DZ_F(NRR) = MIN(DZ_F(NRR),-ZZ_MIXED_IN(NS)/RNN%NU_MW_O_MW_F(NS))
               ENDIF      
            ENDDO
         ENDIF    
      ELSE
         DZ_F(NRR) = 0._EB
         DZ_FR(NRR) = 0._EB
      ENDIF
   ENDDO
   DZ_FRAC_F(NR) = DZ_F(NR)/MAX(SUM(DZ_F),TWO_EPSILON_EB)
   DZ_FRAC_FR(NR) = DZ_FR(NR)/MAX(SUM(DZ_FR),TWO_EPSILON_EB)
   IF (.NOT. RN%FAST_CHEMISTRY) THEN
      RATE_CONSTANT = DZ_FR(NR)*DZ_FRAC_FR(NR)
   ELSE
      RATE_CONSTANT = DZ_F(NR)*DZ_FRAC_F(NR)/DT_SUB
   ENDIF
   RETURN
ENDIF

IF (RN%FAST_CHEMISTRY) THEN ! Fuel limited fast chemistry reaction
   RATE_CONSTANT = ZZ_MIXED_IN(RN%FUEL_SMIX_INDEX)/DT_SUB
   RETURN
ENDIF

RATE_CONSTANT = 0._EB
CALL GET_MASS_FRACTION_ALL(ZZ_MIXED_IN,YY_PRIMITIVE)

RATE_CONSTANT = RN%A*EXP(-RN%E/(R0*TMP_0))*RHO(I,J,K)**RN%RHO_EXPONENT
IF (ABS(RN%N_T)>TWO_EPSILON_EB) RATE_CONSTANT=RATE_CONSTANT*TMP_0**RN%N_T

IF (ALL(RN%N_S<-998._EB)) THEN
   DO NS=0,N_TRACKED_SPECIES
      IF(RN%NU(NS)<0._EB .AND. ZZ_MIXED_IN(NS) < ZZ_MIN) THEN
         RATE_CONSTANT = 0._EB
         RETURN
      ENDIF
   ENDDO
ELSE
   DO NS=1,N_SPECIES
      IF(ABS(RN%N_S(NS)) <= TWO_EPSILON_EB) CYCLE
      IF(RN%N_S(NS)>= -998._EB) THEN
         IF (YY_PRIMITIVE(NS) < ZZ_MIN) THEN
            RATE_CONSTANT = 0._EB
         ELSE
            RATE_CONSTANT = YY_PRIMITIVE(NS)**RN%N_S(NS)*RATE_CONSTANT
         ENDIF
      ENDIF
   ENDDO
ENDIF
RETURN

END SUBROUTINE COMPUTE_RATE_CONSTANT

            
LOGICAL FUNCTION EXTINCT_1(ZZ_IN,TMP_0,NR)
USE PHYSICAL_FUNCTIONS,ONLY:GET_AVERAGE_SPECIFIC_HEAT
REAL(EB),INTENT(IN)::ZZ_IN(0:N_TRACKED_SPECIES),TMP_0
REAL(EB):: Y_O2,Y_O2_CRIT,CPBAR
INTEGER, INTENT(IN) :: NR
INTEGER :: NS
TYPE(REACTION_TYPE),POINTER :: RN=>NULL()
RN => REACTION(NR)

EXTINCT_1 = .FALSE.
IF (TMP_0 < RN%AUTO_IGNITION_TEMPERATURE) THEN
   EXTINCT_1 = .TRUE.
ELSE
   CALL GET_AVERAGE_SPECIFIC_HEAT(ZZ_IN,CPBAR,TMP_0)

   DO NS = 0,N_TRACKED_SPECIES
      IF (RN%NU(NS)<-TWO_EPSILON_EB .AND. NS/=RN%FUEL_SMIX_INDEX) THEN
         Y_O2 = ZZ_IN(NS)
      ENDIF
   ENDDO
   Y_O2_CRIT = CPBAR*(RN%CRIT_FLAME_TMP-TMP_0)/RN%EPUMO2
   IF (Y_O2 < Y_O2_CRIT) EXTINCT_1 = .TRUE.
 
ENDIF

END FUNCTION EXTINCT_1


LOGICAL FUNCTION EXTINCT_2(ZZ_MIXED_IN,TMP_0,NR)
USE PHYSICAL_FUNCTIONS,ONLY:GET_AVERAGE_SPECIFIC_HEAT
REAL(EB),INTENT(IN)::ZZ_MIXED_IN(0:N_TRACKED_SPECIES),TMP_0
REAL(EB):: DZ_AIR,DZ_FUEL,CPBAR_F_0,CPBAR_F_N,CPBAR_G_0,CPBAR_G_N,ZZ_GET(0:N_TRACKED_SPECIES)
INTEGER, INTENT(IN) :: NR
INTEGER :: NS
TYPE(REACTION_TYPE),POINTER :: RN=>NULL()
RN => REACTION(NR)

EXTINCT_2 = .FALSE.
IF (TMP_0 < RN%AUTO_IGNITION_TEMPERATURE) THEN
   EXTINCT_2 = .TRUE.
ELSE
   DZ_FUEL = 1._EB
   DZ_AIR = 0._EB
   
   !Search reactants to find limiting reactant and express it as fuel mass. This is the amount of fuel that can burn.
   DO NS = 0,N_TRACKED_SPECIES
      IF (RN%NU(NS)<-TWO_EPSILON_EB) &
         DZ_FUEL = MIN(DZ_FUEL,-ZZ_MIXED_IN(NS)/RN%NU_MW_O_MW_F(NS))
   ENDDO

   !Get the specific heat for the fuel at the current and critical flame temperatures   
   CPBAR_F_0 = CPBAR_Z(MIN(5000,NINT(TMP_0)),RN%FUEL_SMIX_INDEX)
   CPBAR_F_N = CPBAR_Z(MIN(5000,NINT(RN%CRIT_FLAME_TMP)),RN%FUEL_SMIX_INDEX)

   !Remove the burnable fuel from the local mixture and renormalize.  The remainder is "air"
   ZZ_GET = ZZ_MIXED_IN
   ZZ_GET(RN%FUEL_SMIX_INDEX) = ZZ_GET(RN%FUEL_SMIX_INDEX) - DZ_FUEL
   
   ZZ_GET = ZZ_GET/SUM(ZZ_GET)      
  
   !Get the specific heat for the "air"
   CALL GET_AVERAGE_SPECIFIC_HEAT(ZZ_GET,CPBAR_G_0,TMP_0) 
   CALL GET_AVERAGE_SPECIFIC_HEAT(ZZ_GET,CPBAR_G_N,RN%CRIT_FLAME_TMP)
   
   !Loop over non-fuel reactants and find the mininum.  Determine how much "air" is needed to provide the limting reactant.
   DO NS = 0,N_TRACKED_SPECIES
      IF (RN%NU(NS)<-TWO_EPSILON_EB .AND. NS/=RN%FUEL_SMIX_INDEX) &
         DZ_AIR = MAX(DZ_AIR, -DZ_FUEL*RN%NU_MW_O_MW_F(NS)/ZZ_GET(NS))
   ENDDO
   
   !See if enough energy is released to raise the fuel and required "air" temperatures above the critical flame temp.   
   IF ( (DZ_FUEL*CPBAR_F_0 + DZ_AIR*CPBAR_G_0)*TMP_0 + DZ_FUEL*RN%HEAT_OF_COMBUSTION < &
        (DZ_FUEL*CPBAR_F_N + DZ_AIR*CPBAR_G_N)*RN%CRIT_FLAME_TMP) EXTINCT_2 = .TRUE.

ENDIF

END FUNCTION EXTINCT_2


SUBROUTINE GET_REV_fire(MODULE_REV,MODULE_DATE)
INTEGER,INTENT(INOUT) :: MODULE_REV
CHARACTER(255),INTENT(INOUT) :: MODULE_DATE

WRITE(MODULE_DATE,'(A)') firerev(INDEX(firerev,':')+2:LEN_TRIM(firerev)-2)
READ (MODULE_DATE,'(I5)') MODULE_REV
WRITE(MODULE_DATE,'(A)') firedate

END SUBROUTINE GET_REV_fire
 
END MODULE FIRE

