

workbench="/Applications/workbench/bin_macosx64"
SAaxis_dir="/cbica/projects/luo_wm_dev/SAaxis"


#Extract left cortex and right cortex data from the fslr cifti (generate hemisphere .func.gii files)
${workbench}/wb_command -cifti-separate ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis.dscalar.nii COLUMN -metric CORTEX_LEFT ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis_LH.fslr32k.func.gii 
${workbench}/wb_command -cifti-separate ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis.dscalar.nii COLUMN -metric CORTEX_RIGHT ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis_RH.fslr32k.func.gii



#Resample S-A axis from fslr mesh to fsaverage5 mesh with metric-resample
${workbench}/wb_command -metric-resample ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis_LH.fslr32k.func.gii \
${SAaxis_dir}/FSLRVertex/fs_LR-deformed_to-fsaverage.L.sphere.32k_fs_LR.surf.gii \
${SAaxis_dir}/fsaverage5_std_sphere.L.10k_fsavg_L.surf.gii \
ADAP_BARY_AREA ${SAaxis_dir}/metric/SensorimotorAssociation_Axis_LH.fsaverage5.func.gii \
-area-metrics ${SAaxis_dir}/FSLRVertex/fs_LR.L.midthickness_va_avg.32k_fs_LR.shape.gii ${SAaxis_dir}/fsaverage5.L.midthickness_va_avg.10k_fsavg_L.shape.gii

${workbench}/wb_command -metric-resample ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis_RH.fslr32k.func.gii \
${SAaxis_dir}/FSLRVertex/fs_LR-deformed_to-fsaverage.R.sphere.32k_fs_LR.surf.gii \
${SAaxis_dir}/fsaverage5_std_sphere.R.10k_fsavg_R.surf.gii \
ADAP_BARY_AREA ${SAaxis_dir}/metric/SensorimotorAssociation_Axis_RH.fsaverage5.func.gii \
-area-metrics ${SAaxis_dir}/FSLRVertex/fs_LR.R.midthickness_va_avg.32k_fs_LR.shape.gii ${SAaxis_dir}/fsaverage5.R.midthickness_va_avg.10k_fsavg_R.shape.gii



#Resample S-A axis from fslr mesh to fsaverage5 mesh with -label-resample
${workbench}/wb_command -label-resample ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis_LH.fslr32k.func.gii \
${SAaxis_dir}/FSLRVertex/fs_LR-deformed_to-fsaverage.L.sphere.32k_fs_LR.surf.gii \
${SAaxis_dir}/fsaverage5_std_sphere.L.10k_fsavg_L.surf.gii \
ADAP_BARY_AREA ${SAaxis_dir}/label/SensorimotorAssociation_Axis_LH.fsaverage5.label.gii \
-area-metrics ${SAaxis_dir}/FSLRVertex/fs_LR.L.midthickness_va_avg.32k_fs_LR.shape.gii ${SAaxis_dir}/fsaverage5.L.midthickness_va_avg.10k_fsavg_L.shape.gii

${workbench}/wb_command -label-resample ${SAaxis_dir}/FSLRVertex/SensorimotorAssociation_Axis_RH.fslr32k.func.gii \
${SAaxis_dir}/FSLRVertex/fs_LR-deformed_to-fsaverage.R.sphere.32k_fs_LR.surf.gii \
${SAaxis_dir}/fsaverage5_std_sphere.R.10k_fsavg_R.surf.gii \
ADAP_BARY_AREA ${SAaxis_dir}/label/SensorimotorAssociation_Axis_RH.fsaverage5.label.gii \
-area-metrics ${SAaxis_dir}/FSLRVertex/fs_LR.R.midthickness_va_avg.32k_fs_LR.shape.gii ${SAaxis_dir}/fsaverage5.R.midthickness_va_avg.10k_fsavg_R.shape.gii

