#!/bin/bash

# GET THE DIFFUSIVITIES FROM THE INCLUDED REGION OF INTERESTS (ROIs)
# Usage: In the origdata folder create a file called subjects.txt by running this script: "for i in *FA.nii.gz;do echo $i >> subjects.txt;done" 
#   Then copy the subjects.txt and the included ROIs to the stats folder and run the script.
# Output: csv file containing the diffusivity values.

output=diffusivities_spherical.csv

# Get diffusivity values necessary from left projection area
fslmeants -i all_dxx.nii.gz -m sphere_lproj-117-110-101_mask.nii.gz -o dxx_lproj_sphere.txt
fslmeants -i all_dyy.nii.gz -m sphere_lproj-117-110-101_mask.nii.gz -o dyy_lproj_sphere.txt

# Get diffusivity values necessary from left association area
fslmeants -i all_dxx.nii.gz -m sphere_lassoc-128-110-101_mask.nii.gz -o dxx_lassoc_sphere.txt
fslmeants -i all_dzz.nii.gz -m sphere_lassoc-128-110-101_mask.nii.gz -o dzz_lassoc_sphere.txt

# Get diffusivity values necessary from right projection area
fslmeants -i all_dxx.nii.gz -m sphere_rproj-64-110-101_mask.nii.gz -o dxx_rproj_sphere.txt
fslmeants -i all_dyy.nii.gz -m sphere_rproj-64-110-101_mask.nii.gz -o dyy_rproj_sphere.txt

# Get diffusivity values necessary from right association area
fslmeants -i all_dxx.nii.gz -m sphere_rassoc-52-110-101_mask.nii.gz -o dxx_rassoc_sphere.txt
fslmeants -i all_dzz.nii.gz -m sphere_rassoc-52-110-101_mask.nii.gz -o dzz_rassoc_sphere.txt

echo "subject,dxx_lproj,dyy_lproj,dxx_lassoc,dzz_lassoc,dxx_rproj,dyy_rproj,dxx_rassoc,dzz_rassoc" > "$output"

paste -d ',' subjects.txt dxx_lproj_sphere.txt dyy_lproj_sphere.txt dxx_lassoc_sphere.txt dzz_lassoc_sphere.txt dxx_rproj_sphere.txt dyy_rproj_sphere.txt dxx_rassoc_sphere.txt dzz_rassoc_sphere.txt >> "$output"

echo "CSV file created as $output"