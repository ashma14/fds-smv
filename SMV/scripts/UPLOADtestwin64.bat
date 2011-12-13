@echo off

Rem Windows batch file to upload Smokeview test files to
Rem the google download site.  This script assume that the Windows
Rem batch file, MAKEtest.bat, has already been run.

set envfile="%userprofile%"\fds_smv_env.bat
IF EXIST %envfile% GOTO endif_envexist
echo ***Fatal error.  The environment setup file %envfile% does not exist. 
echo Create a file named %envfile% and use SMV/scripts/fds_smv_env_template.bat
echo as an example.
echo.
echo Aborting now...
pause>NUL
goto:eof

:endif_envexist

  set level=Release-4_Test
  set upload_win64=1
  set upload_win32=0
  set upload_linux32=0
  set upload_osx32=0

call %envfile%

echo Uploading Smokeview %level% version=test revision=%smv_revision%

%svn_drive%
cd %svn_root%\smv\for_bundle\to_google

Rem --------------- 64 bit Windows ----------------
if not %upload_win64% == 1 goto endif_win64
  set glabels=Type-Installer,Opsys-Windows_64,%level%
  set dplatform=64 bit Windows
  set platform=win64
  set summary=Smokeview test for %dplatform% (SVN r%smv_revision%)
  set exe=smv_test_%smv_revision%_%platform%.exe
  echo.
  echo Uploading %summary% - %exe%
  echo googlecode_upload.py --passwd-file-dir %google_password_dir% --config-dir none -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
       %upload% --passwd-file-dir %google_password_dir% --config-dir none -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
:endif_win64

Rem --------------- 32 bit Windows ----------------
if not %upload_win32% == 1 goto endif_win32
  set glabels=Type-Installer,Opsys-Windows,%level%
  set dplatform=32 bit Windows
  set platform=win32
  set summary=Smokeview test for %dplatform% (SVN r%smv_revision%)
  set exe=smv_test_%smv_revision%_%platform%.exe
  echo.
  echo Uploading %summary% - %exe%
  echo googlecode_upload.py --passwd-file-dir %google_password_dir% --config-dir none -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
       %upload% --passwd-file-dir %google_password_dir% --config-dir none -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
:endif_win32

Rem --------------- 32 bit Linux ----------------

if not %upload_linux32% == 1 goto endif_linux32
  set glabels=Type-Archive,Opsys-Linux,%level%
  set dplatform=32 bit Linux
  set platform=linux
  set summary=Smokeview test for %dplatform% (SVN r%smv_revision%)
  set exe=smv_test_%smv_revision%_%platform%.tar.gz
  echo.
  echo Uploading %summary% - %exe%
  echo googlecode_upload.py --passwd-file-dir %google_password_dir% --config-dir none  -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
       %upload% --passwd-file-dir %google_password_dir% --config-dir none  -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
:endif_linux32

Rem --------------- 32 bit OSX ----------------

if not %upload_osx32% == 1 goto endif_osx32
  set glabels=Type-Archive,Opsys-OSX,%level%
  set dplatform=32 bit OSX
  set platform=osx
  set summary=Smokeview test for %dplatform% (SVN r%smv_revision%)
  set exe=smv_test_%smv_smv_revision%_%platform%.tar.gz
  echo.
  echo Uploading %summary% - %exe%
  echo googlecode_upload.py --passwd-file-dir %google_password_dir% --config-dir none  -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
       %upload% --passwd-file-dir %google_password_dir% --config-dir none  -s "%summary%" -p fds-smv -u %google_username% -l %glabels% %exe%
:endif_osx32

echo.
echo Uploads complete
pause
