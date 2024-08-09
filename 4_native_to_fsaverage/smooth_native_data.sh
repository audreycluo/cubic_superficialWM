#!/bin/bash


# smooth native superficial WM data



##############################################
# Set config file (based on dataset to analyze)
##############################################
 
# Parse command-line arguments
while getopts ":c:" opt; do
  case $opt in
    c) config_file="$OPTARG"
    ;;
    \?) echo "Invalid option: -$OPTARG" >&2
    ;;
  esac
done

# Check if the config_file variable is set
if [ -z "$config_file" ]; then
  echo "Error: Please specify a config file using the -c option." >&2
  exit 1
fi

# qsub your_script.sh -c config_dataset.json

########################################
# Read in subject ID
########################################
sub=${@:OPTIND}

########################################
# Set directories
########################################
dataset=$(jq -r '.dataset' "$config_file")
data_root=$(jq -r '.data_root' "$config_file")
outputs_root=$(jq -r '.outputs_root' "$config_file")
 
indir_scalars="${outputs_root}/${sub}/vol_to_surf/dsistudio_scalars/native"  
outdir_scalars="${outputs_root}/${sub}/vol_to_surf/dsistudio_scalars/native"  

module load connectome_workbench/1.4.2
 
 

########################################
# Set depths
######################################## 
depths=('depth_1' 'depth_1p25' 'depth_1p5' 'depth_1p75' 'depth_2' 'depth_2p25' 'depth_2p5' 'depth_2p75' 'depth_3')


######################################################################################
# Smooth DSIStudio vol_to_surf output at different depths
######################################################################################
 
scalars=($(find "${indir_scalars}" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)) # get scalar subdirs
echo "${scalars[@]}"
fwhm_values=(1 2 3)

# connectome_wb on cubic doesn't have -fwhm flag, so need to compute sigma values 
# Function to convert FWHM to sigma
convert_fwhm_to_sigma() {
    local fwhm=$1
    local sigma=$(echo "scale=10; $fwhm / (2 * sqrt(2 * l(2)))" | bc -l)
    echo $sigma
}

 
sigma_values=()

# Loop through FWHM values and convert to sigma
for fwhm in "${fwhm_values[@]}"; do
    sigma=$(convert_fwhm_to_sigma $fwhm)
    sigma_values+=($sigma)
done


 
for scalar in "${scalars[@]}"; do
    for hemi in lh rh; do
        for depth in "${depths[@]}"; do
            for fwhm in "${fwhm_values[@]}"; do
                for sigma in "${sigma_values[@]}"; do
                    gii_in="${sub}_${scalar}_${hemi}_${depth}.shape.gii"
                    gii_out="${sub}_${scalar}_${hemi}_${depth}_smoothed_fwhm${fwhm}.shape.gii"

                    # Check for the native vol_to_surf gifti  
                    if [ ! -f ${indir_scalars}/${scalar}/${gii_in}   ]; then
                        echo "No ${gii_in} for ${sub}"
                        continue
                    fi
                    
                    # make smoothed output dir
                    smoothed_outputs_dir="${outdir_scalars}/${scalar}/smoothed"
                    if [[ ! -d "${smoothed_outputs_dir}" ]]; then
                        mkdir -p "${smoothed_outputs_dir}"
                    fi

                    wb_command -metric-smoothing ${outputs_root}/${sub}/surfaces/native_acpc/${sub}.${hemi}.white.native_acpc.surf.gii ${indir_scalars}/${scalar}/${gii_in} ${sigma} ${smoothed_outputs_dir}/${gii_out} 

                done  
            done
        done
    done
done
 
 