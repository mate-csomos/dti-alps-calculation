#!/bin/sh

# Step 2. Extract diffusivity values from the tensor files and move to tbss folder.
# This script assumes you have separate folders for each subject and within those folders there is a dtifit folder containig the tensor file.
# Change the tensor filename if it is named differently
# input: subjects.txt file, containing one subject (main folder) per row

tensor_filename=dti_tensor.nii.gz

while IFS= read -r subject; do
    # Extract Dxx Dyy and Dzz from the tensor file
    fslroi ${subject}/dtifit/${tensor_filename} ${subject}/dtifit/dti_dxx 0 1
    fslroi ${subject}/dtifit/${tensor_filename} ${subject}/dtifit/dti_dyy 3 1
    fslroi ${subject}/dtifit/${tensor_filename} ${subject}/dtifit/dti_dzz 5 1

    # Create separate directories for the tensor files
    mkdir -p tbss/dxx/
    mkdir -p tbss/dyy/
    mkdir -p tbss/dzz/    

    # Copy FA images to tbss folder
    cp ${subject}/dtifit/dti_FA.nii.gz tbss/${subject}_dti_FA.nii.gz

    # Copy the diffusivities to the corresponding tbss subfolder
    cp ${subject}/dtifit/dti_dxx.nii.gz tbss/dxx/${subject}_dti_FA.nii.gz
    cp ${subject}/dtifit/dti_dyy.nii.gz tbss/dyy/${subject}_dti_FA.nii.gz
    cp ${subject}/dtifit/dti_dzz.nii.gz tbss/dzz/${subject}_dti_FA.nii.gz
    
    # Optional (2 rows): create a folder for Mean Diffusivity and copy the MD file too
    mkdir -p tbss/MD/
    cp ${subject}/dtifit/dti_MD.nii.gz tbss/dzz/${subject}_dti_FA.nii.gz
done < subjects.txt
