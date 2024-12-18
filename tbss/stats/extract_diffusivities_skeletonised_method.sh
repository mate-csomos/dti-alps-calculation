#!/bin/bash

# GET THE DIFFUSIVITIES FROM THE SKELETON
# Usage: 
#   In the origdata folder create a file called subjects.txt by running this script: "for i in *FA.nii.gz;do echo $i >> subjects.txt;done".
#   Copy the created subjects.txt into stats folder.
#   Open with fsleyes the all_FA_skeletonized.nii.gz and the included ROIs. Enter Edit mode. 
#   Create 4 empty 4D mask image (names below). After creating the 4 empty files, choose the all_FA_skeletonised layer.
#   Toggle "select" mode and use the "select by intensity" tool. Use 3D search and limit the search to a circle. 
#   Parameters: Selection size: 4; Fill value: 1; Intensity threshold: set according to selected voxel; Search radius: 4
#   Target image: set according the location that is selected under the ROIs. Then press "Fill selected voxels" and save the mask image. Repeat this 4 times.
#   Files to create:
#    - skeleton_lproj_mask.nii.gz
#    - skeleton_lassoc_mask.nii.gz
#    - skeleton_rproj_mask.nii.gz
#    - skeleton_rassoc_mask.nii.gz
#   Then run this script in the stats folder.
# Output: csv file containing the diffusivity values.

output=diffusivities_skeletonised.csv

# Get diffusivity values necessary from left projection area
fslmeants -i all_dxx_skeletonised.nii.gz -m skeleton_lproj_mask.nii.gz -o dxx_lproj_skeletonised.txt
fslmeants -i all_dyy_skeletonised.nii.gz -m skeleton_lproj_mask.nii.gz -o dyy_lproj_skeletonised.txt

# Get diffusivity values necessary from left association area
fslmeants -i all_dxx_skeletonised.nii.gz -m skeleton_lassoc_mask.nii.gz -o dxx_lassoc_skeletonised.txt
fslmeants -i all_dzz_skeletonised.nii.gz -m skeleton_lassoc_mask.nii.gz -o dzz_lassoc_skeletonised.txt

# Get diffusivity values necessary from right projection area
fslmeants -i all_dxx_skeletonised.nii.gz -m skeleton_rproj_mask.nii.gz -o dxx_rproj_skeletonised.txt
fslmeants -i all_dyy_skeletonised.nii.gz -m skeleton_rproj_mask.nii.gz -o dyy_rproj_skeletonised.txt

# Get diffusivity values necessary from right association area
fslmeants -i all_dxx_skeletonised.nii.gz -m skeleton_rassoc_mask.nii.gz -o dxx_rassoc_skeletonised.txt
fslmeants -i all_dzz_skeletonised.nii.gz -m skeleton_rassoc_mask.nii.gz -o dzz_rassoc_skeletonised.txt

echo "subject,dxx_lproj,dyy_lproj,dxx_lassoc,dzz_lassoc,dxx_rproj,dyy_rproj,dxx_rassoc,dzz_rassoc" > "$output"

paste -d ',' subjects.txt dxx_lproj_skeletonised.txt dyy_lproj_skeletonised.txt dxx_lassoc_skeletonised.txt dzz_lassoc_skeletonised.txt dxx_rproj_skeletonised.txt dyy_rproj_skeletonised.txt dxx_rassoc_skeletonised.txt dzz_rassoc_skeletonised.txt >> "$output"

echo "CSV file created as $output"