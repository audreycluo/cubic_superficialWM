
# done locally 
workbench="/Applications/workbench/bin_macosx64"
glasser_dir="/cbica/projects/luo_wm_dev/atlases/glasser"
SAaxis_dir="/cbica/projects/luo_wm_dev/SAaxis"

#Resample glasser atlas from fslr mesh to fsaverage5 mesh with -label-resample
${workbench}/wb_command -label-resample ${glasser_dir}/FSLRVertex/glasser_360_L.label.gii \
${SAaxis_dir}/FSLRVertex/fs_LR-deformed_to-fsaverage.L.sphere.32k_fs_LR.surf.gii \
${SAaxis_dir}/fsaverage5_std_sphere.L.10k_fsavg_L.surf.gii \
ADAP_BARY_AREA ${glasser_dir}/fsaverage5/label/glasser_space-fsaverage5_desc-atlas-LH.label.gii  \
-area-metrics ${SAaxis_dir}/FSLRVertex/fs_LR.L.midthickness_va_avg.32k_fs_LR.shape.gii ${SAaxis_dir}/fsaverage5.L.midthickness_va_avg.10k_fsavg_L.shape.gii

${workbench}/wb_command -label-resample ${glasser_dir}/FSLRVertex/glasser_360_R.label.gii \
${SAaxis_dir}/FSLRVertex/fs_LR-deformed_to-fsaverage.R.sphere.32k_fs_LR.surf.gii \
${SAaxis_dir}/fsaverage5_std_sphere.R.10k_fsavg_R.surf.gii \
ADAP_BARY_AREA ${glasser_dir}/fsaverage5/label/glasser_space-fsaverage5_desc-atlas-RH.label.gii  \
-area-metrics ${SAaxis_dir}/FSLRVertex/fs_LR.R.midthickness_va_avg.32k_fs_LR.shape.gii ${SAaxis_dir}/fsaverage5.R.midthickness_va_avg.10k_fsavg_R.shape.gii

 