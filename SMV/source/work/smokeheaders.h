// $Date$ 
// $Revision$
// $Author$

#ifndef SMOKEHEADERS_H_DEFINED
#define SMOKEHEADERS_H_DEFINED

EXTERNCPP void Update_Smokecolormap(void);
#ifdef pp_SUPERMESH
EXTERNCPP void define_volsmoke_textures(void);
#endif
EXTERNCPP void set_colorbar_list_index(int val);
EXTERNCPP int get_colorbar_list_index(void);
EXTERNCPP int get_colorbar_index(int flag, int x, int y);
EXTERNCPP void Get_VP_info(void);

EXTERNCPP void scale_2dfont(void);
EXTERNCPP void scale_3dfont(void);
EXTERNCPP int LABEL_Get_Nuserlabels(void);
EXTERNCPP labeldata *LABEL_Next(labeldata *gl);
EXTERNCPP labeldata *LABEL_Previous(labeldata *gl);
EXTERNCPP int LABEL_Init(labeldata *gl);
EXTERNCPP void LABEL_resort(labeldata *label);
EXTERNCPP void LABEL_copy(labeldata *label_to, labeldata *label_from);
EXTERNCPP labeldata *LABEL_get(char *name);
EXTERNCPP void LABEL_delete(labeldata *label);
EXTERNCPP void LABEL_print(void);
EXTERNCPP labeldata *LABEL_insert(labeldata *labeltemp);

EXTERNCPP void update_nrender_rows(void);
EXTERNCPP void glui_update_fontindex(void);
EXTERNCPP void rotateu2v(float *u, float *v, float *axis, float *angle);
EXTERNCPP void rotation_type_CB(int var);
EXTERNCPP  void update_rotation_type(int val);
EXTERNCPP void sort_smoke3dinfo(void);

EXTERNCPP void camera2quat(camera *ca, float *quat, float *rotation);
EXTERNCPP void angleaxis2quat(float angle, float *axis, float *quat);
EXTERNCPP void quat2rot(float quat[4],float rot[16]);
EXTERNCPP void mult_quat(float x[4], float y[4], float z[4]);
EXTERNCPP void normalize_quat(float x[4]);

EXTERNCPP void setScreenSize(int *width, int *height);
EXTERNCPP void keyboard_CB(unsigned char key, int x, int y);
EXTERNCPP void keyboard_up_CB(unsigned char key, int x, int y);
EXTERNCPP void Reshape_CB(int width, int height);
EXTERNCPP void Display_CB(void);
EXTERNCPP void specialkeyboard_CB(int key, int x, int y);
EXTERNCPP void specialkeyboard_up_CB(int key, int x, int y);
EXTERNCPP void mouse_CB(int button, int state, int x, int y);
EXTERNCPP void motion_CB(int xm, int ym);
EXTERNCPP void MenuStatus_CB(int status, int x, int y);
EXTERNCPP void Idle_CB(void);

SVEXTERN void update_vector_widgets(void);
EXTERNCPP void update_gslice_parms(void);
EXTERNCPP void readiso_orig(const char *file, int ifile, int flag, int *errorcode);
EXTERNCPP void update_plotxyz_all(void);
EXTERNCPP void update_isocolors(void);
EXTERNCPP void get_faceinfo(void);
EXTERNCPP void GetGeomInfoPtrs(geomdata ***geominfoptrs_local,int *ngeominfoptrs_local);
EXTERNCPP devicedata *getdevice(char *label, int index);
EXTERNCPP void setup_glut(int argc, char **argv);
EXTERNCPP int get_ndevices(char *file);
EXTERNCPP void readhrr(int flag, int *errorcode);
EXTERNCPP void read_device_data(char *file, int filetype, int flag);
EXTERNCPP void setup_zone_devs(void);
EXTERNCPP void setup_device_data(void);
EXTERNCPP void read_device_header(char *file, devicedata *devices, int ndevices);
EXTERNCPP void parse_device_keyword(FILE *stream, devicedata *devicei);
EXTERNCPP void draw_geom(int flag,int frameflag);
EXTERNCPP void getzonesizecsv(int *nzone_times, int *nroom2, int *nfires, int *nzhvents, int *nzvvents, int *error);
EXTERNCPP void getzoneventbounds(void);
EXTERNCPP void remove_dup_blockages(void);
EXTERNCPP void Sort_Iso_Triangles(float *mm);
EXTERNCPP void Update_Isotris(int flag);
EXTERNCPP void update_evac_parms(void);
EXTERNCPP void update_slice_menu_show(void);
EXTERNCPP void update_slicedir_count(void);
EXTERNCPP void update_patch_bounds(patchdata *patchi);
EXTERNCPP void Update_All_Patch_Bounds(void);
EXTERNCPP void Update_All_Patch_Bounds_st(void);
EXTERNCPP int update_patch_hist(patchdata *patchi);
EXTERNCPP void update_hidepatchsurface(void);
EXTERNCPP int last_slice_loadstack(void);
EXTERNCPP void push_slice_loadstack(int sliceindex);
EXTERNCPP void remove_slice_loadstack(int sliceindex);
EXTERNCPP int last_vslice_loadstack(void);
EXTERNCPP void push_vslice_loadstack(int sliceindex);
EXTERNCPP void remove_vslice_loadstack(int sliceindex);
EXTERNCPP void update_axislabels_smooth(void);
EXTERNCPP void update_transparency(void);
EXTERNCPP void update_script_start(void);
EXTERNCPP void update_research_mode(void);
EXTERNCPP void update_script_stop(void);
EXTERNCPP void update_defer(void);
EXTERNCPP void update_tbounds(void);
EXTERNCPP void updateGluiTimeBounds(float time_min, float time_max);
EXTERNCPP void settimeval(float timeval);
EXTERNCPP void get_indep_var_indices(sv_object *smv_object,char **var_indep_strings, int nvars_indep,int *index);
EXTERNCPP void get_evac_indices(sv_object *smv_object, int *evac_index,int *nevac_index);
EXTERNCPP void update_glui_set_view_xyz(float *xyz);
EXTERNCPP void update_glui_filelabel(int var);
EXTERNCPP void update_colorbar_list(void);
EXTERNCPP void update_colorbar_list2(void);
EXTERNCPP void update_colorbarflip(void);

EXTERNCPP void script_loadvolsmokeframe2(void);
EXTERNCPP void update_glui_plot3dtype(void);
EXTERNCPP void update_glui_isotype(void);
EXTERNCPP void init_device(devicedata *devicei, float *xyz, float *xyzn, int state0,int nparams, float *params, char *labelptr);
EXTERNCPP void init_device_plane(devicedata *devicei);
EXTERNCPP void draw_devices_val(void);
EXTERNCPP void getsmokesensors(void);
EXTERNCPP float get_vecfactor(int *iveclengths);
EXTERNCPP void normalize_xyz(float *xyz_out, float *xyz_in);
EXTERNCPP void denormalize_xyz(float *xyz_out, float *xyz_in);
EXTERNCPP void add_new_tour(void);
EXTERNCPP void cleanbuffer(char *buffer, char *buffer2);
EXTERNCPP void start_script(void);
EXTERNCPP int run_script(void);
EXTERNCPP int compile_script(char *scriptfile);
EXTERNCPP scriptfiledata *insert_scriptfile(char *file);
EXTERNCPP char *get_inifilename(int id);
EXTERNCPP char *get_scriptfilename(int id);
EXTERNCPP inifiledata *insert_inifile(char *file);
EXTERNCPP void keyboard(unsigned char key, int flag);
EXTERNCPP void get_newscriptfilename(char *newscriptfilename);
EXTERNCPP void init_avatar(void);
EXTERNCPP void drawselect_avatars(void);
EXTERNCPP void readterrain(char *file, int ifile, int flag, int *errorcode);
EXTERNCPP void initterrain_znode(mesh *meshi, terraindata *terri, float xmin, float xmax, int nx, float ymin, float ymax, int ny, 
                                 int allocate_memory);
EXTERNCPP void output_mfed_csv(multislicedata *mslicei);
EXTERNCPP void ParticlePropShowMenu(int value);
EXTERNCPP int get_index(float x, int dir, float *plotxyz, int nplotxyz);
EXTERNCPP void glui_script_disable(void);
EXTERNCPP void update_slice_contours(int slice_type_index, float line_min, float line_max, int nline_values);
EXTERNCPP void ScriptMenu(int var);
EXTERNCPP void SmokeColorBarMenu(int var);
EXTERNCPP void  OBJECT_CB(int flag);
EXTERNCPP void update_glui_viewlist(void);
EXTERNCPP void glui_script_enable(void);
EXTERNCPP void WUI_CB(int var);
EXTERNCPP void compress_onoff(int flag);
EXTERNCPP void compress_svzip2(void);
EXTERNCPP void initterrain_all(void);
EXTERNCPP void update_terrain_colors(void);
EXTERNCPP void drawterrain(terraindata *terri, int only_geom);
EXTERNCPP void drawterrain_texture(terraindata *terri, int only_geom);
EXTERNCPP void drawtrees(void);
EXTERNCPP int createnulllabel(flowlabels *flowlabel);
EXTERNCPP void initcullgeom(int cullflag);
EXTERNCPP void get_cullskips(mesh *meshi, int cullflag, int cull_portsize, int *iiskip, int *jjskip, int *kkskip);
#ifdef pp_CULL
EXTERNCPP void initcull(int cullflag);
EXTERNCPP void initcullplane(int cullflag);
EXTERNCPP void setPixelCount(void);
EXTERNCPP void setPixelCountOrthog(mesh *meshi);
EXTERNCPP void getPixelCount(void);
EXTERNCPP int init_cull_exts(void);
#endif
#ifdef pp_GPU
#ifdef pp_GPUDEPTH
EXTERNCPP void getDepthTexture( void );
EXTERNCPP void createDepthTexture( void );
#endif
EXTERNCPP int init_shaders(void);
EXTERNCPP void LoadSmokeShaders(void);
EXTERNCPP void Load3DSliceShaders(void);
EXTERNCPP void LoadZoneSmokeShaders(void);
EXTERNCPP void LoadVolSmokeShaders(void);
EXTERNCPP void UnLoadShaders(void);
#endif
EXTERNCPP void next_xindex(int inc,int flag);
EXTERNCPP void next_yindex(int inc,int flag);
EXTERNCPP void next_zindex(int inc,int flag);
EXTERNCPP void initspheresegs(int nlat, int nlong);
EXTERNCPP void Update_Glui_Wui(void);
EXTERNCPP int have_terrain_slice(void);
EXTERNCPP float get_zcell_val_offset(mesh *meshi,float xval, float yval, int *loc);
EXTERNCPP void update_camera_ypos(camera *camera_data);
EXTERNCPP camera *get_camera(char *name);
EXTERNCPP char *get_camera_label(int index);
EXTERNCPP void clip2cam(camera *cam);
EXTERNCPP void cam2clip(camera *cam);
EXTERNCPP void init_object_defs(void);
EXTERNCPP void update_device_textures(void);
EXTERNCPP char *get_device_label(char *buffer);
EXTERNCPP void get_elevaz(float *xyznorm,float *dtheta, float *rotate_axis, float *dpsi);
EXTERNCPP void drawTargetNorm(void);
EXTERNCPP void draw_devices(void);
EXTERNCPP void free_SVOBJECT(sv_object *object);
EXTERNCPP sv_object *parse_SVOBJECT(FILE *stream);
EXTERNCPP sv_object *init_SVOBJECT1(char *label, char *commands,int visible);
EXTERNCPP sv_object *init_SVOBJECT2(char *label, char *commandson, char *commandsoff,int visible);
EXTERNCPP sv_object *get_SVOBJECT_type(char *label, sv_object *default_object);
EXTERNCPP sv_object *get_SVOBJECT_type2(char *label, sv_object *default_object);
EXTERNCPP int read_object_defs(char *file);
EXTERNCPP void freeall_objects(void);
EXTERNCPP void parse_object_string(char *string, char **tokens, int *ntokens);
EXTERNCPP void update_partclass_depend(part5class *partclassi);

EXTERNCPP int get_plot3d_index(mesh *meshi, int dir, float val);
EXTERNCPP int plot3dlistcompare( const void *arg1, const void *arg2 );
EXTERNCPP int plot3dcompare( const void *arg1, const void *arg2 );
EXTERNCPP void update_plot_xyz(mesh *current_mesh);
EXTERNCPP void updateplotslice_mesh(mesh *mesh_in, int slicedir);

EXTERNCPP char *get_chid(char *file, char *buffer);
EXTERNCPP void setColorbarClipPlanes(int flag);
EXTERNCPP void addcolorbar(int icolorbar);
EXTERNCPP void ReloadMenu(int value);
EXTERNCPP void ColorBarMenu(int val);
EXTERNCPP void initdefaultcolorbars(void);
EXTERNCPP void drawcolorbarpath(void);
EXTERNCPP void update_colorbar_splits(colorbardata *cbi);
EXTERNCPP void remapcolorbar(colorbardata *cbi);
EXTERNCPP void adjust_colorbar_splits(colorbardata *cbi);
EXTERNCPP colorbardata *getcolorbar(char *label);
EXTERNCPP void remap_colorbartype(int cb_oldtype, char *cb_newname);
EXTERNCPP void freecolorbars(void);
EXTERNCPP void Update_Glui_Stereo(void);
EXTERNCPP void escape_blanks(char *dirfrom, int maxlen);
EXTERNCPP void InitOpenGL(void);
EXTERNCPP void TextureShowMenu(int value);
EXTERNCPP void copy_args(int *argc, char **aargv, char ***argv_sv);
EXTERNCPP void init_user_ticks(void);
EXTERNCPP void draw_user_ticks(void);
EXTERNCPP int get_tick_dir(float *mm);
EXTERNCPP void init_multi_threading(void);
#ifdef WIN32
EXTERNCPP void OpenSMVFile(char *filename,int filenamelength,int *openfile);
#endif
EXTERNCPP int AnySmoke(char *type);
EXTERNCPP int AnySlices(char *type);
EXTERNCPP void TrainerViewMenu(int var);

EXTERNCPP void delete_camera(camera *cam1);
EXTERNCPP void ShowAllSmoke(void);
EXTERNCPP void HideAllSmoke(void);
EXTERNCPP void HideAllSlices(void);
EXTERNCPP void ShowAllSlices(char *type1, char *type2);
EXTERNCPP void UnloadSliceMenu(int value);
EXTERNCPP void ViewpointMenu(int value);
EXTERNCPP void FrameRateMenu(int var);
EXTERNCPP void LoadUnloadMenu(int value);
EXTERNCPP void TourMenu(int var);
EXTERNCPP void ResetMenu(int var);
EXTERNCPP void LabelMenu(int value);
EXTERNCPP void FontMenu(int value);
EXTERNCPP void ShowHideSliceMenu(int var);
EXTERNCPP void EvacShowMenu(int value);
EXTERNCPP void ParticleShowMenu(int value);
EXTERNCPP void Plot3DShowMenu(int value);
EXTERNCPP void IsoShowMenu(int value);
EXTERNCPP void ShowPatchMenu(int value);
EXTERNCPP void Smoke3DShowMenu(int value);
EXTERNCPP void ShowVSliceMenu(int value);
EXTERNCPP part5prop *get_part5prop_s(char *label);
EXTERNCPP int get_part5prop_index_s(char *shortlabel);
EXTERNCPP int get_part5prop_index(char *label);
EXTERNCPP void print_part5prop(void);
EXTERNCPP part5prop *get_part5prop(char *label);
EXTERNCPP void init_part5prop(void);
EXTERNCPP void update_streakvalue(float value);
EXTERNCPP void update_all_partvis2(void);
EXTERNCPP void ParticleMenu(int value);
EXTERNCPP void LoadPatchMenu(int value);
EXTERNCPP void LoadSliceMenu(int value);
EXTERNCPP void LoadVSliceMenu(int value);

EXTERNCPP void initvars(void);
EXTERNCPP void RenderState(int onoff);
EXTERNCPP void update_windowsizelist(void);
EXTERNCPP void ResizeWindow(int width, int height);
EXTERNCPP void update_glui_streakvalue(float rvalue);
EXTERNCPP void glui_alert_setup(int main_window);
EXTERNCPP void show_glui_alert(void);
EXTERNCPP void hide_glui_alert(void);
EXTERNCPP void update_trainer_outline(void);
EXTERNCPP void update_trainer_moves(void);
EXTERNCPP mesh *getmesh(float *xyz);

EXTERNCPP sv_object *get_object(char *label);
EXTERNCPP void get_labels(char *buffer, int type, char **label1, char **label2, char prop_buffer[255]);
EXTERNCPP void snap_scene(void);
EXTERNCPP void level_scene(int level_x, int level_y, float *quat);
#ifdef pp_SHOOTER
EXTERNCPP void get_plot3d_uvw(float xyz[3], float uvw[3]);
EXTERNCPP void solve_shooter_data(void);
EXTERNCPP void increment_shooter_data(shootpointdata *pold, shootpointdata *pnew, float dt);
EXTERNCPP void show_glui_shooter(void);
EXTERNCPP void hide_glui_shooter(void);
EXTERNCPP void draw_shooter(void);
#endif
EXTERNCPP void show_glui_trainer(void);
EXTERNCPP void hide_glui_trainer(void);
EXTERNCPP int get_trainee_location(void);
EXTERNCPP void set_trainer_controls(void);
EXTERNCPP void load_startup_smoke(void);
EXTERNCPP void get_startup_vslice(int seq_id);
EXTERNCPP void get_startup_slice(int seq_id);
EXTERNCPP void get_startup_part(int seq_id);
EXTERNCPP void get_startup_plot3d(int seq_id);
EXTERNCPP void get_startup_smoke(int seq_id);
EXTERNCPP void get_startup_iso(int seq_id);
EXTERNCPP void get_startup_patch(int seq_id);
EXTERNCPP void set_3dsmoke_startup(void);
EXTERNCPP void clear_3dsmoke_startup(void);
EXTERNCPP void put_startup_smoke3d(FILE *fileout);
EXTERNCPP void drawonlythreshold(const mesh *meshi);
EXTERNCPP void draw_transparent_faces(void);
EXTERNCPP smoothblockage *getsmoothblockage(mesh *meshi,float tt);
EXTERNCPP void freesmoothblocks(smoothblockage *sb);
EXTERNCPP int isblockagevisible(blockagedata *bc, float time);
EXTERNCPP float zoom2aperture(float zoom0);
EXTERNCPP float aperture2zoom(float ap);
EXTERNCPP int getZoneColor(float t, float tmin, float tmax, int nlevel);
EXTERNCPP void fill_zonedata(int izone);
EXTERNCPP void update_overwrite(void);
EXTERNCPP void compress_svzip(void);
EXTERNCPP void drawTargets(void);
EXTERNCPP void drawBlockages(int mode, int flag);
EXTERNCPP void drawLabels(void);
EXTERNCPP void Update_Tourlist(void);
EXTERNCPP void update_glui_speed(void);
EXTERNCPP void getnewpos(float *oldpos, float dx, float dy, float dz, float speed_factor);
EXTERNCPP void free_skybox(void);
EXTERNCPP void draw_skybox(void);
EXTERNCPP void loadskytexture(char *filebase, texture *texti);
#ifdef USE_ZLIB
EXTERNCPP void uncompress_slicedataframe(slicedata *sd,int frame_index);
EXTERNCPP void uncompress_patchdataframe(mesh *meshi,int frame_index);
#endif
EXTERNCPP void getpatchdata_zlib(patchdata *patchi,unsigned char *data,int ndata, 
                       float *times, unsigned int *zipoffset, unsigned int *zipsize, int ntimes);
EXTERNCPP void getpatchsizeinfo(patchdata *patchi, int *nframes, int *buffersize);
EXTERNCPP void getpatchheader2(char *file, int *version, int *i1, int *i2, int *j1, int *j2, int *k1, int *k2, int *patchdir);
EXTERNCPP void getpatchheader(char *file,int *npatches,float *valmin, float *valmax);
EXTERNCPP int getsmoke3d_version(smoke3ddata *smoke3di);
EXTERNCPP void update_cadtextcoords(cadquad *quadi);
EXTERNCPP void open_smokepanel(void);
EXTERNCPP void open_volsmokepanel(void);
EXTERNCPP void open_smokezippanel(void);
EXTERNCPP void close_smokepanel(void);
EXTERNCPP void close_volsmokepanel(void);
EXTERNCPP void close_smokezippanel(void);
EXTERNCPP void UpdateIndexColors(void);
EXTERNCPP void adjusttourtimes(tourdata *touri);
EXTERNCPP void update_tourindex(void);
EXTERNCPP void update_glui_zoom(void);
EXTERNCPP void SetTour(tourdata *thetour);
EXTERNCPP void freetrainers(void);
EXTERNCPP void update_plot3d_display(void);
EXTERNCPP void ShellMenu(int var);
EXTERNCPP int getshellmenu_index(int menuid);
EXTERNCPP void makeshellmenus(int menuid,int flag);
EXTERNCPP void destroyshellmenus(void);
EXTERNCPP void update_smoke3dflags(void);
EXTERNCPP void mergesmoke3dcolors(smoke3ddata *smoke3dset);
EXTERNCPP void setsmokecolorflags(void);
EXTERNCPP void Sort_Embedded_Geometry(float *mm);
EXTERNCPP void Sort_Transparent_Faces(float *mm);
EXTERNCPP void getsmokedir(float *mm);
EXTERNCPP void get_vdevice_vel(float time, vdevicedata *vdevicei, float *vel, float *angle, float *dvel, float *dangle, int *valid_vel);
EXTERNCPP float get_device_val(float time, devicedata *devicei, int *valid);
EXTERNCPP void getvolsmokedir(float *mm);
EXTERNCPP void getzonesmokedir(float *mm);
EXTERNCPP void get_world_eyepos(float *mm, float user_eyepos[3], float scaled_eyepos[3]);
EXTERNCPP culldata *get_face_port(mesh *meshi, facedata *facei);
EXTERNCPP void set_cull_vis(void);
EXTERNCPP void ExtractFrustum(void);
EXTERNCPP int PointInFrustum( float x, float y, float z);
EXTERNCPP int RectangleInFrustum( float *x11, float *x12, float *x22, float *x21);
EXTERNCPP unsigned char adjustalpha(unsigned char alpha, float factor);
EXTERNCPP void updatesmoke3d(smoke3ddata *smoke3di);
EXTERNCPP void drawsmoke3d(smoke3ddata *smoke3di);
EXTERNCPP void drawsmoke_frame(void);
EXTERNCPP void drawpart_frame(void);
EXTERNCPP void drawevac_frame(void);
EXTERNCPP void drawplot3d_frame(void);
EXTERNCPP void drawvslice_frame(void);
EXTERNCPP void drawslice_frame(void);
EXTERNCPP void drawgslice_dataGPU(slicedata *slicei);
EXTERNCPP void drawgslice_data(slicedata *slicei);
EXTERNCPP void drawgslice_outline(void);
EXTERNCPP void drawpatch_frame(void);
EXTERNCPP void Motion_CB(int var);
EXTERNCPP void init_slice3d_texture(mesh *meshi);

#ifdef pp_GPU
EXTERNCPP void drawsmoke3dGPU(smoke3ddata *smoke3di);
#endif
EXTERNCPP void drawsmoke3dVOL(void);
#ifdef pp_CULL
EXTERNCPP void drawsmoke3dCULL(void);
#endif
EXTERNCPP void get_drawing_parms(int *drawing_smooth, int *drawing_transparent, int *drawing_blockage_transparent, int *drawing_vent_transparent);
EXTERNCPP void updatesmoke3dmenulabels(void);
EXTERNCPP void Labels_CB(int value);
EXTERNCPP void bench_out(float frame_rate);
EXTERNCPP void output_Slicedata(void);
EXTERNCPP void init_Slicedata(void);
EXTERNCPP void update_camera_label(void);
EXTERNCPP void update_extreme(int flag);
EXTERNCPP void update_colorbar_type(void);
EXTERNCPP void update_colorbar_label(void);
EXTERNCPP void init_camera_list(void);
EXTERNCPP camera *insert_camera(camera *cb,camera *source, char *name);
EXTERNCPP void add_default_views(void);
EXTERNCPP void update_view_gluilist(void);
EXTERNCPP void gluiIdle(void);
EXTERNCPP void gluiIdleNULL(void);
EXTERNCPP void reset_gltime(void);
EXTERNCPP void enable_reset_saved_view(void);
EXTERNCPP void reset_glui_view(int ival);
EXTERNCPP void init_camera(camera *camera_data,char *name);
EXTERNCPP void copy_camera(camera *to, camera *from);
EXTERNCPP void set_camera_current(float angles[2], float eye[3], float zoom);
EXTERNCPP void update_camera(camera *ca);
EXTERNCPP void update_projection_type(void);
EXTERNCPP void update_eyerotate(void);
EXTERNCPP void update_cursor_checkbox(void);
EXTERNCPP void update_clip_all(void);
EXTERNCPP void backup_blockage(blockagedata *bc);
EXTERNCPP void update_blockpath(void);
EXTERNCPP void getinverse(float *m, float *mi);
EXTERNCPP void matmatmult(float *m1, float *m2, float *m3);
EXTERNCPP void matvecmult(double *m1, float *v1, float *v2);
EXTERNCPP void update_meshlist1(int val);
EXTERNCPP void update_translate(void);
EXTERNCPP void BlockageMenu(int value);
EXTERNCPP void parsedatabase(char *databasefile);
EXTERNCPP char *STRSTR(char *c, const char *key);
EXTERNCPP void update_sorted_surfidlist(void);
EXTERNCPP void handle_plot3d_keys(int  key);
EXTERNCPP void handle_move_keys(int  key);
EXTERNCPP int get_interval(float val, float *array, int n);

EXTERNCPP void set_unit_vis(void);
EXTERNCPP void memorystatus(void);
EXTERNCPP void showhide_translate(int var);
EXTERNCPP void updateallplotslices(void);
EXTERNCPP int makeiblank(void);
EXTERNCPP int makeiblank_carve(void);
EXTERNCPP void makeiblank_smoke3d(void);
EXTERNCPP void getunitinfo(const char *unitlabel, int *unitclass, int *unittype);
EXTERNCPP void update_unit_defs(void);

EXTERNCPP void SmoothIsoSurface(isosurface *surfacedata);
EXTERNCPP void updateslicefilenum(void);
EXTERNCPP void drawstaticiso(const isosurface *asurface,int surfacetype, 
                             int smoothnorms, int trans_flag, int data_type, 
                             float line_width);
EXTERNCPP int getplot3dtime(float *time);
EXTERNCPP void normalize(float *xyz, int n);
#ifndef CPP
EXTERNCPP void getisosizes(const char *isofile, int dataflag, EGZ_FILE **isostreamptr,
				 int *nvertices, int *ntriangles, float **levels, int *nisolevels,
				 int *niso_times, float *tmin, float *tmax, int endian);
#endif
EXTERNCPP void array2string(float *array, int narray, char *string);
EXTERNCPP void getisolevels(const char *isofile, int dataflag, float **levelsptr, float ***colorlevelsptr, int *nisolevels);

EXTERNCPP void getsmoothblockparms(mesh *gb, smoothblockage *sb);
EXTERNCPP void MakeIsoBlockages(mesh *gb, smoothblockage *sb);

EXTERNCPP int ifsmoothblock(void);
EXTERNCPP void updatevslices(void);
EXTERNCPP void updatepartmenulabels(void);
EXTERNCPP void updateisomenulabels(void);
EXTERNCPP void updatepatchmenulabels(void);
EXTERNCPP void updateslicemenulabels(void);
EXTERNCPP void updatevslicemenulabels(void);
EXTERNCPP void updateplot3dmenulabels(void);
EXTERNCPP void handle_rotation_type(int flag);

EXTERNCPP void init_texturedir(void);
EXTERNCPP void getrgb(unsigned int val, unsigned char *rr, unsigned char *gg, unsigned char *bb);
EXTERNCPP unsigned char *readpicture(char *filename, int *width, int *height, int printflag);
#ifdef pp_JPEG
EXTERNCPP unsigned char *readjpeg(const char *filename,int *width, int *height, int skip);
#endif
EXTERNCPP unsigned char *readpng(const char *filename,int *width, int *height);

EXTERNCPP void update_whichface(int which_face);
EXTERNCPP void update_blockvals(int flag);
EXTERNCPP void show_glui_colorbar(void);
EXTERNCPP void hide_glui_colorbar(void);
EXTERNCPP void show_glui_motion(void);
EXTERNCPP void hide_glui_motion(void);
EXTERNCPP void show_glui_clip(void);
EXTERNCPP void Update_Glui_Clip(void);

EXTERNCPP void hide_glui_clip(void);
EXTERNCPP void show_glui_wui(void);
EXTERNCPP void hide_glui_wui(void);
EXTERNCPP void show_glui_display(void);
EXTERNCPP void show_glui_device(void);
EXTERNCPP void hide_glui_device(void);
EXTERNCPP void set_labels_controls(void);
EXTERNCPP void hide_glui_display(void);

EXTERNCPP void create_tourlist(void);
EXTERNCPP void delete_tourlist(void);
EXTERNCPP void updateviewtour(void);
EXTERNCPP void update_tourcontrols(void);
EXTERNCPP void adjustviewangle(keyframe *kf,float *azimuth, float *elevation);
EXTERNCPP void setup_tour(void);
EXTERNCPP void createtourpaths(void);
EXTERNCPP void drawtours(void);
EXTERNCPP void set_glui_keyframe(void);
EXTERNCPP void drawselect_tours(void);
EXTERNCPP void freetour(tourdata *touri);
EXTERNCPP void inittour(tourdata *touri);
EXTERNCPP void updatetourmenulabels(void);
EXTERNCPP void update_globaltension(void);
EXTERNCPP void defaulttour(void);
EXTERNCPP void show_glui_tour(void);
EXTERNCPP void hide_glui_tour(void);
EXTERNCPP void new_select(keyframe *newselect);
EXTERNCPP void delete_tour(int tour_index);
EXTERNCPP tourdata *add_tour(char *label);
EXTERNCPP void init_circulartour(void);
EXTERNCPP keyframe *delete_frame(keyframe *step);
EXTERNCPP void ReallocTourMemory(void);
EXTERNCPP keyframe *add_frame(keyframe *framei, float time, float *xyz, float key_azimuth, float elevation, float bank,
                    float params[3],int viewtype,float zoom,float view[3]);
EXTERNCPP void hide_glui_trainer(void);
EXTERNCPP void show_glui_stereo(void);
EXTERNCPP void hide_glui_stereo(void);
EXTERNCPP void show_glui_3dsmoke(void);
EXTERNCPP void hide_glui_3dsmoke(void);

EXTERNCPP void enable_boundary_glui(void);
EXTERNCPP void disable_boundary_glui(void);
EXTERNCPP void update_clipplanes(void);
EXTERNCPP void show_glui_bounds(void);
EXTERNCPP void hide_glui_bounds(void);

EXTERNCPP void get_blockvals(float *xmin, float *xmax,
                   float *ymin, float *ymax,
                   float *zmin, float *zmax,
                   int *imin, int *jmin, int *kmin);
EXTERNCPP void show_glui_edit(void);
EXTERNCPP void hide_glui_edit(void);

EXTERNCPP void updateslicelistindex(int sfn);
EXTERNCPP void updatepatchlistindex(int patchfilenum);
EXTERNCPP void updatepatchlistindex2(char *label);
EXTERNCPP void updateplot3dlistindex(void);
EXTERNCPP void transparentoff(void);
EXTERNCPP void transparenton(void);
EXTERNCPP void getobstlabels(const char *filein);
EXTERNCPP void initobst(blockagedata *bc,surfdata *surf,int index,int meshindex);
EXTERNCPP void setsurfaceindex(blockagedata *bc);
EXTERNCPP void updateusetextures(void);
EXTERNCPP int updatergbhist(int width, int height,int maketable, int *colortable, int nrgb);
EXTERNCPP void antialias(int flag);
EXTERNCPP void saveview(void);
EXTERNCPP void savelastview(void);
EXTERNCPP void setslicebounds(int islicetype);
EXTERNCPP void setisobounds(int islicetype);
EXTERNCPP void local2globalpatchbounds(const char *key);
EXTERNCPP void global2localpatchbounds(const char *key);
EXTERNCPP void update_loaded_lists(void);
EXTERNCPP void updateLights(int pos);
EXTERNCPP int mergescreenbuffers(int nscreen_rows, GLubyte **screenbuffers);
EXTERNCPP GLubyte *getscreenbuffer(void);
EXTERNCPP void ShowScene(int mode, int view_mode, int quad, GLint s_left, GLint s_down);
EXTERNCPP int  inblockage(const mesh *gb,float x, float y, float z);
EXTERNCPP int inmesh_smoke(float x, float y, float z, int n, int flag);
EXTERNCPP void initmesh(mesh *gb);
EXTERNCPP void updateglui(void);
EXTERNCPP void updateslicelist(int index);
EXTERNCPP void drawiso(int tranflag);
EXTERNCPP void drawplot3d(mesh *gb);
EXTERNCPP void drawplot3d_texture(mesh *gb);
EXTERNCPP void updateshowstep(int val, int slicedir);
EXTERNCPP void ClearBuffers(int mode);
EXTERNCPP void updateplotslice(int slicedir);
EXTERNCPP void drawpatch(const mesh *gb);
EXTERNCPP void drawpatch_cellcenter(const mesh *gb);
EXTERNCPP void drawpatch_texture(const mesh *gb);
EXTERNCPP void drawpatch_texture_cellcenter(const mesh *gb);
EXTERNCPP void drawpatch_texture_threshold(const mesh *gb);
EXTERNCPP void drawpatch_threshold_cellcenter(const mesh *meshi);

EXTERNCPP void Render(int view_mode);
EXTERNCPP void updateslicebounds(void);
EXTERNCPP void updateisobounds(void);
EXTERNCPP void updateallslicecolors(int islicetype,int *errorcode);
EXTERNCPP void updateallisocolors(int iisotype,int *errorcode);
EXTERNCPP void updatevslicetypes(void);
EXTERNCPP int getvsliceindex(const vslicedata *vd);
EXTERNCPP int getvslicetype(const vslicedata *vd);
EXTERNCPP int getslicetype(const slicedata *sd);
EXTERNCPP int getslicetype_fromlabel(char *label);
EXTERNCPP void updateslicetypes(void);
EXTERNCPP int getsliceindex(const slicedata *sd);
EXTERNCPP void updatesliceboundlabels(void);
EXTERNCPP int getisotype(const isodata *isoi);
EXTERNCPP int getisottype(const isodata *isoi);
EXTERNCPP int getisoindex(const isodata *isoi);
EXTERNCPP void update_isotype(void);
EXTERNCPP void updateisotypes(void);
EXTERNCPP int getpatchtype(const patchdata *patchi);
EXTERNCPP void update_patchtype(void);
EXTERNCPP void updatepatchtypes(void);

EXTERNCPP void update_mesh_terrain(void);
EXTERNCPP void update_terrain_options(void);
EXTERNCPP void update_glui_cellcenter(void);
EXTERNCPP void update_plot3dtitle(void);
EXTERNCPP void LoadPlot3dMenu(int value);
EXTERNCPP void init_plot3dtimelist(void);
EXTERNCPP void update_iso_showlevels(void);
EXTERNCPP void update_current_mesh(mesh *meshi);
EXTERNCPP void DialogMenu(int value);
EXTERNCPP void ApertureMenu(int value);
EXTERNCPP void ZoomMenu(int value);
EXTERNCPP void setClipPlanes(int mode);
EXTERNCPP void unsetClipPlanes(void);
EXTERNCPP void setslicecolors(float slicemin, float slicemax, slicedata *sd, int *errorcode);
EXTERNCPP void setisocolors(float isomin, float isomax, isodata *sd, int *errorcode);
EXTERNCPP void drawvolslice_terrain(const slicedata *sd);
EXTERNCPP void drawvolslice_texture(const slicedata *sd);
EXTERNCPP void drawvolslice_cellcenter(const slicedata *sd);
EXTERNCPP int new_multi_slice(slicedata *sdold,slicedata *sd);
EXTERNCPP int hide_slice2(slicedata *sdi,slicedata *sdj);
EXTERNCPP void drawvolslice(const slicedata *sd);
EXTERNCPP void drawvvolslice_cellcenter(const vslicedata *vd);
EXTERNCPP void drawvvolslice(const vslicedata *vd);
EXTERNCPP void drawvvolslice_terrain(const vslicedata *vd);
EXTERNCPP void drawTimeBar(float xleft, float xright, float ybot, float ytop);
EXTERNCPP void drawColorBars(void);
EXTERNCPP void drawPart(const partdata *parti);
EXTERNCPP void drawEvac(const partdata *parti);
EXTERNCPP void drawStaticPart(const partdata *parti);
EXTERNCPP void drawgrid(const mesh *gb);
EXTERNCPP void drawroomgeom(void);
EXTERNCPP void drawfiredata(void);
EXTERNCPP void drawroomdata(void);
EXTERNCPP void drawventdata(void);
EXTERNCPP void ResetView(int option);
EXTERNCPP void UpdateTimeLabels(void);
EXTERNCPP void RenderFrame(int view_mode);
EXTERNCPP int readlabels_terrain(flowlabels *label, FILE *stream);
EXTERNCPP int readlabels_cellcenter(flowlabels *label, FILE *stream);
EXTERNCPP void update_terrain(int allocate_memory, float vertical_factor);
EXTERNCPP void PART_CB_INIT(void);
EXTERNCPP void Slice_CB(int var);
EXTERNCPP void RenderMenu(int value);
EXTERNCPP void LoadSmoke3DMenu(int value);
EXTERNCPP void Visible(int state);
EXTERNCPP void parse_commandline(int argc, char **argv);
EXTERNCPP void usage(char **argv);
EXTERNCPP void display_version_info(void);
EXTERNCPP int getmaxrevision(void);
EXTERNCPP void draw_demo(int nlat, int nlong);
EXTERNCPP void draw_demo2(int option);
EXTERNCPP void init_demo(float rad, int nlat, int nlong);
EXTERNCPP void drawoutlines(void);
EXTERNCPP void drawcbox(float x, float y, float z, float size);
EXTERNCPP void handleiso(void);
EXTERNCPP void updatesurface(void);
EXTERNCPP void WindowStatus(int state);
EXTERNCPP void nodein_extvent(
                    int ipatch, 
                    int *patchblankcopy,const mesh *meshi,int i1,int i2, int j1, int j2, int k1, int k2);
EXTERNCPP void setventdirs(void);
EXTERNCPP int nodeinblockage(const mesh *meshi, int i,int j,int k, int *imesh, int *iblockage);
EXTERNCPP int nodeinvent(const mesh *gb, int i,int j,int k, int dir);
EXTERNCPP void writeboundini(void);
EXTERNCPP void readboundini(void);
EXTERNCPP int readini2(char *inifile, int localfile);
EXTERNCPP void obst_or_vent2faces(const mesh *gb,blockagedata *bc, ventdata *vi, facedata *faceptr,int facetype);
EXTERNCPP void initsurface(surfdata *surf);
EXTERNCPP void initventsurface(surfdata *surf);
EXTERNCPP void UpdateHiddenFaces(void);
EXTERNCPP void update_selectfaces(void);
EXTERNCPP void update_selectblocks(void);
EXTERNCPP void draw_faces(void);
EXTERNCPP void draw_facesOLD(void);
EXTERNCPP void drawselect_faces(void);
EXTERNCPP void allocate_faces(void);
EXTERNCPP void update_facelists(void);
EXTERNCPP void update_faces(void);
EXTERNCPP void drawticks(void);
EXTERNCPP void set_startup_view(void);
EXTERNCPP void add_list_view(char *label_in);
EXTERNCPP float color2bw(const float *color);
EXTERNCPP float *getcolorptr(const float *color);
EXTERNCPP void colorconvert(int flag);
EXTERNCPP void initcadcolors(void);
EXTERNCPP void UpdateRGBColors(int colorindex);
EXTERNCPP void initrgb(void);
EXTERNCPP void updatechopcolors(void);
EXTERNCPP void freelabels(flowlabels *label);
EXTERNCPP int readini(int scriptconfigfile);
EXTERNCPP void writeini(int flag);
EXTERNCPP void DrawFirePlume(float radius, float height, float maxheight);
EXTERNCPP int ispatchtype(int type);
EXTERNCPP void adjustdatabounds(const float *pdata, int skip, int ndata, int setpmin, float *pmin, int setpmax, float *pmax);
EXTERNCPP void adjustpartbounds(const float *pdata, int particle_type, int droplet_type, const unsigned char *isprink, 
                      int skip, int ndata, int setpmin, float *pmin, int setpmax, float *pmax);
EXTERNCPP void adjustpart5bounds(partdata *parti);
EXTERNCPP void adjustPlot3Dbounds(int iplot3d, int setpmin, float *pmin, int setpmax, float *pmax);
EXTERNCPP void adjustslicebounds(const slicedata *sd, float *pmin, float *pmax);
EXTERNCPP void getslicedatabounds(const slicedata *sd, float *pmin, float *pmax);
EXTERNCPP void scalefloat2string(float floatfrom, char *stringto, const float *scale, float range);
EXTERNCPP void scalestring(const char *stringfrom, char *stringto, const float *scale, float range);
EXTERNCPP void num2string(char *string, float tval, float range);
EXTERNCPP int setup_case(int argc, char **argv);
EXTERNCPP int get_min_partframes(void);
EXTERNCPP int Update_Bounds(void);


EXTERNCPP void freecadinfo(void);

EXTERNCPP void init_unit_defs(void);
EXTERNCPP void InitUnits(void);
EXTERNCPP void readcad2geom(cadgeom *cd);
EXTERNCPP void readcadgeom(cadgeom *cd);
EXTERNCPP void drawcadgeom(const cadgeom *cd);
EXTERNCPP void drawcad2geom_opaque(const cadgeom *cd,int trans_flag);

EXTERNCPP void draw_geomdata(patchdata *patchi, int frameflag);
EXTERNCPP char *newtextptr(char ***texture_list,int *n_texture_list,char *texturebuffer,char *lastbuffer);

EXTERNCPP void readplot3d(char *file, int ifile, int flag,int *errorcode);
EXTERNCPP void read_geom_header(geomdata *geomi, int *ntimes_local);
EXTERNCPP void read_all_geom(void);
EXTERNCPP void read_geom(geomdata *geomi, int flag, int type, int *errorcode);
EXTERNCPP void init_geom(geomdata *geomi);
EXTERNCPP void read_geomdata(int ifile, int flag, int *errorcode);
EXTERNCPP void readpatch(int ifile, int flag, int *errorcode);
EXTERNCPP void readpart(char *file, int ifile, int flag, int *errorcode);
EXTERNCPP void readzone(int ifile, int flag, int *errorcode);
EXTERNCPP void readvslice(int ivslice, int flag, int *errorcode);

EXTERNCPP void smooth_blockages(void);
EXTERNCPP void freesmoke3d(smoke3ddata *smoke3di);
EXTERNCPP void readsmoke(int ifile,int flag, int *errorcode);
EXTERNCPP void readsmoke3d(int ifile,int flag, int *errorcode);
EXTERNCPP int getsmoke3d_sizes(int skip, char *smokefile, int version, 
                      float **timelist, int **use_smokeframe,
                      int *nchars_uncompressed, 
                      int **nchars_compressed,
                      int **nchars_compressed_full,
                      int *nframes, int *nframes_full,int *have_light);
EXTERNCPP void readfed(int ifile, int flag, int file_type, int *errorcode);
EXTERNCPP void readslice(char *file, int ifile, int flag, int *errorcode);
EXTERNCPP void readtarget(const char *file, int ifile, int flag, int *errorcode);
EXTERNCPP void update_smooth_blockages(void);
EXTERNCPP void readtarget2(const char *file, int ifile, int flag, int *errorcode);
EXTERNCPP void readiso(const char *file, int ifile, int flag, int *errorcode);

EXTERNCPP void InitMenus(int unload);
EXTERNCPP void smoothlabel(float *min, float *max, int n);
EXTERNCPP int readsmv(char *file, char *file2);
EXTERNCPP void readsmv_dynamic(char *file);
EXTERNCPP int STRCMP(const char *s1, const char *s2);
EXTERNCPP int gettargetposition(int itarget, float time, float *x, float *y, float *z);
EXTERNCPP void outputAxisLabels(void);
EXTERNCPP void outputLargeText(float x, float y, char *string);
EXTERNCPP void outputText(float x, float y, char *string);
EXTERNCPP void output3Text(float *color, float x, float y, float z, char *string);
EXTERNCPP void output3Val(float x, float y, float z, float val);
EXTERNCPP void outputBarText(float x, float y, const GLfloat *color, char *string);
EXTERNCPP void getzonebounds(const float *pdata, int ndata, int setpmin, float *pmin, int setpmax, float *pmax);
EXTERNCPP void updatechar(void);
EXTERNCPP void updatetracers(void);
EXTERNCPP void update_fedinfo(void);
void update_gslice_planes(void);

EXTERNCPP void getPart5Colors(partdata *parti, int nlevels);
EXTERNCPP void getPartColors(const float *t, int skip, int nt, unsigned char *it,
                   const unsigned char *isprink, int particle_type, int droplet_type,
              const float *tmin, const float *tmax, int nlevel,
              char **labels, char *scale, float *partlevels256);
EXTERNCPP void getBoundaryColors(float *t, int nt, unsigned char *it, 
              int settmin, float *tmin, int settmax, float *tmax, 
              float *tmin_global, float *tmax_global,
              int ndatalevel, int nlevel,
              char **labels, char *scale, float *tvals256,
              int *extreme_min, int *extreme_max);
EXTERNCPP void getBoundaryColors2(float *t, int nt, unsigned char *it, 
              int settmin, float *ttmin, int settmax, float *ttmax,
              float *tmin_global, float *tmax_global,
              int ndatalevel,
              int *extreme_min, int *extreme_max
              );
EXTERNCPP void getBoundaryColors3(patchdata *patchi, float *t, int nt, unsigned char *it, 
              int settmin, float *tmin, int settmax, float *tmax, 
              float *tmin_global, float *tmax_global,
              int nlevel,
              char **labels, char *scale, float *tvals256,
              int *extreme_min, int *extreme_max);
EXTERNCPP void getBoundaryLabels(
              float tmin, float tmax,
              char **labels, char *scale, float *tvals256, int nlevel);
EXTERNCPP void getZoneColors(const float *t, int nt, unsigned char *it,
               const float *tmin, const float *tmax, int nlevel, int nlevel_full,
               char **labels, char *scale, float *tvals256
               );
EXTERNCPP void get_faceinfo(void);

EXTERNCPP void getPlot3DColors(int iplot, int settmin, float *ttmin, int settmax, float *ttmax, 
              int ndatalevel, int nlevel,
              char **labels,char **labelsiso, char **scale, float *fscale, float *tlevels, float *tlevels256,
              int *extreme_min, int *extreme_max
              );
EXTERNCPP float getsliceval(slicedata *sd, unsigned char ival);
EXTERNCPP void updateallslicelabels(int slicetype, int *errorcode);
EXTERNCPP void updateallisolabels(int slicetype, int *errorcode);
EXTERNCPP void setslicelabels(float smin, float smax, 
                    slicedata *sd, int *errorcode);
EXTERNCPP void getSliceLabels(float tmin, float tmax, int nlevel,
              char labels[12][11],char **scale, float *fscale, float *tlevels256);
EXTERNCPP void updatePart5extremes(void);
EXTERNCPP void getSliceColors(const float *t, int nt, unsigned char *it,
              float tmin, float tmax, 
              int ndatalevel, int nlevel,
              char labels[12][11],char **scale, float *fscale, float *tlevels2,
              int *extreme_min, int *extreme_max
              );
EXTERNCPP mesh *get_loaded_isomesh(void);
EXTERNCPP void unload_iso_trans(void);
EXTERNCPP void setisolabels(float smin, float smax, 
                    isodata *sd, int *errorcode);
EXTERNCPP void getIsoLabels(float tmin, float tmax, int nlevel,
              char labels[12][11],char **scale, float *tlevels256);
EXTERNCPP int SVimage2file(char *GIFfilename, int rendertype, int width, int height);
EXTERNCPP void update_showhidebuttons(void);
EXTERNCPP void update_fileload(void);
EXTERNCPP surfdata *get_surface(char *label);
EXTERNCPP void CalcTriNormal(float *v1, float *v2, float *v3, float *norm);
EXTERNCPP void update_triangles(void);

#ifndef CPP
#include "smokefortheaders.h"
#endif
#include "message.h"

#endif
