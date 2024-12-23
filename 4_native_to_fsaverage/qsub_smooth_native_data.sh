#!/bin/bash

########################################
# Set directories
########################################
 
data_root=$(jq -r '.data_root' ../config_HCPD.json)
outputs_root=$(jq -r '.outputs_root' ../config_HCPD.json)
dataset=$(jq -r '.dataset' ../config_HCPD.json)

 
# Specify the path to the subjects file
subjects_file="${data_root}/subject_list/${dataset}_subject_list.txt"
 
# load connectome_workbench
module load connectome_workbench/1.4.2

# Loop through subjects in the file
while IFS= read -r sub; do
  echo "Processing ${sub}"
	 
	########################################
	# Check for required directories
	########################################

	# Check for native directory
	if [ ! -d ${outputs_root}/${sub}/vol_to_surf/dsistudio_scalars/native ] ; then
		echo "Skipping ${sub} - no native directory"
		continue
	fi
 

	########################################
	# Create log directory if not already made
	########################################

	if [ ! -d ${outputs_root}/${sub}/logs ]; then
		mkdir -p ${outputs_root}/${sub}/logs
	fi
	outputs_dir_logs=${outputs_root}/${sub}/logs

	########################################
	# Submit job
	########################################
	qsub -l h_vmem=16G,s_vmem=16G \
		-j n \
		-o ${outputs_dir_logs} \
		-e ${outputs_dir_logs} \
		./smooth_native_data.sh -c ../config_HCPD.json ${sub}  
		
		

done < "$subjects_file"
 