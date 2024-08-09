import csv
import json
import matplotlib
from matplotlib import pyplot as plt
import nibabel as nib
from nilearn.plotting import show
from nipype.interfaces.workbench import CiftiSmooth
import numpy as np
import os
from os.path import join as ospj
import pandas as pd
import sys



# This script applies nilearn.smooth_img to smooth fsaverage superficial WM data
## all DSIStudio scalars at multiple depths will be smoothed


########################################
# Set directories
########################################
# Parse command-line arguments
if len(sys.argv) != 3:
    print("Usage: python smooth_vol_to_surf_data.py <config_file> <subject_id>")
    sys.exit(1)

config_file = sys.argv[1]
subject_id = sys.argv[2]

# Read config from the specified file
with open(config_file, "rb") as f:
    config = json.load(f)

dataset = config['dataset']
outputs_root = config['outputs_root']

inputs_dir=ospj(outputs_root, subject_id, "vol_to_surf/dsistudio_scalars/fsaverage5")
outputs_dir=ospj(outputs_root, subject_id, "vol_to_surf/dsistudio_scalars/fsaverage5") # maybe put smoothed dir inside the scalar dir

 
########################################
# Functions
########################################


# Define function for extracting probabilities at different depths
def smooth_vol_to_surf_data(img, depth, surf_mesh):
    surf_data = surface.vol_to_surf(img, 
                        surf_mesh, 
                        kind='line', 
                        radius=1,
                        n_samples=None, 
                        mask_img=None, 
                        inner_mesh=None, 
                        depth=[depth])
    return(surf_data)
# Notes: 
# radius = size in mm of the neighborhood around each vertex in which to draw samples
# depth = expressed as a fraction of radius (default = 3)



########################################
# Load Files
########################################

 
########################################
# Set depths
######################################## 
depths=['depth_1', 'depth_1p25', 'depth_1p5', 'depth_1p75', 'depth_2', 'depth_2p25', 'depth_2p5', 'depth_2p75', 'depth_3']
 

######################################################################################
# Smooth DSIStudio vol_to_surf output at different depths
######################################################################################
 
scalars = [d for d in os.listdir(inputs_dir) if os.path.isdir(os.path.join(inputs_dir, d))] # get scalar subdirs

fwhm_values=[1, 2, 3]


# Create directory for vol_to_surf outputs
if not os.path.exists(ospj(outputs_dir, scalar, "smoothed")):
    os.makedirs(ospj(outputs_dir, scalar, "smoothed"))

for scalar in scalars:
    for hemi in ["lh", "rh"]:
        for depth in depths: 
            for fwhm in fwhm_values:
                gii_in=f"{subject_id}_{scalar}_{hemi}_{depth}_fsaverage5.shape.gii"
                gii_out=f"{subject_id}_{scalar}_{hemi}_{depth}_fsaverage5_smoothed_fwhm{fwhm}.shape.gii"
                 
                # Check for the fsaverage5 scalar gifti
                if not os.path.exists(os.path.join(inputs_dir, scalar, gii_in)):
                    print(f"No {gii_in} for {sub}")
                    continue

                # Make smoothed outputs dir            
                smoothed_outputs_dir = os.path.join(outputs_dir, scalar, "smoothed")
                if not os.path.isdir(smoothed_outputs_dir):
                    os.makedirs(smoothed_outputs_dir)

                x = nib.load(ospj(inputs_dir, scalar, gii_in))
                y = image.smooth_img(x, fwhm)
 

smooth = CiftiSmooth()
smooth.inputs.in_file = ospj(inputs_dir, scalar, gii_in)
smooth.inputs.sigma_surf = 4
smooth.inputs.sigma_vol = 4
smooth.inputs.direction = 'COLUMN'
smooth.inputs.right_surf = 'sub-01.R.midthickness.32k_fs_LR.surf.gii'
smooth.inputs.left_surf = 'sub-01.L.midthickness.32k_fs_LR.surf.gii'
smooth.cmdline
 

 