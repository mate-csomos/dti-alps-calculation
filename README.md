# dti-alps-calculation
This repository describes the calculation of DTI-ALPS, introduced by Taoka et al. 2017 via two method: skeletonization method and the improved, reoriented method, introduced by Tatekawa et al. 2023.
The provided scripts can be used after preprocessing the DTI files (see good tutorial: https://andysbrainbook.readthedocs.io/en/latest/MRtrix/MRtrix_Course/MRtrix_04_Preprocessing.html) and running the complete FSL TBSS pipeline and tbss_non_FA on diffusivity files. Manual ROI selection is required for the skeletonization method.

The following steps are recommended after preprocessing of the DTI images:

1. [Run DTIFIT on the preprocessed images with FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/#/diffusion/dtifit).
    * Make sure "--save_tensor" is passed in as argument.
    * Recommended parameters (replace ${variable} with actual filepaths):
    ```bash
    dtifit -k ${data} -o ${subjects_main_folder}/dtifit/dti -m ${mask} -r ${bvec} -b ${bval} --save_tensor
    ```
2. Create a subjects.txt

   Example:
   ```bash
   for i in sub*;do echo $i >> subjects.txt;done
   ```
4. Extract the diffusivity directions from the tensor file: volumes 0, 3 and 5. Then copy the files into a 'tbss' folder.
   * Example script: [extract_tensor_and_prepare_tbss.sh](extract_tensor_and_prepare_tbss.sh)
   * Copy FA files into tbss and the dxx, dyy and dzz files into the corresponding folders.
5. [Run FSL's TBSS process](https://fsl.fmrib.ox.ac.uk/fsl/docs/#/diffusion/tbss).
    ```bash
    tbss_1_preproc *.nii.gz
    ```
    ```bash
    tbss_2_reg -T
    ```
    ```bash
    tbss_3_postreg -S
    ```
    ```bash
    tbss_4_prestats 0.2
    ```
6. Run tbss_non_FA from tbss folder. Repeat this for each folder.
   ```bash
   tbss_non_FA dxx
   ```
   ```bash
   tbss_non_FA dyy
   ```
   ```bash
   tbss_non_FA dzz
    ```
7. Extract diffusivities below the ROI-s.
    1. Copy subjects.txt, the [included .nii.gz ROIs](tbss/stats/), both [extract diffusivities .sh files](tbss/stats/) and [calculate_alps.py](tbss/stats/) into tbss/stats/ folder.
    2. Open with fsleyes the all_FA_skeletonized.nii.gz and the included ROIs. Enter Edit mode.
          1. Create 4 empty 4D mask image (names below).
          ```
           skeleton_lproj_mask.nii.gz
           skeleton_lassoc_mask.nii.gz
           skeleton_rproj_mask.nii.gz
           skeleton_rassoc_mask.nii.gz
          ```
          2. Choose the all_FA_skeletonised layer.
          3. Toggle "select" mode and use the "select by intensity" tool.
          4. Use 3D search (3D icon) and limit the search to a circle (circle icon).
          5. Parameters:
              * Selection size: 4
              * Fill value: 1
              * Intensity threshold: set according to selected voxel (e.g. subtract 1 from the second non-zero decimal place of the currently selected voxel)
              * Search radius: 4
              * Target image: set according the location that is selected under the ROIs
          7. Press "Fill selected voxels" then save the mask image. Repeat this 4 times. Make sure different target image is selected for each roi.
         ```
         skeleton_lproj_mask.nii.gz
         skeleton_lassoc_mask.nii.gz
         skeleton_rproj_mask.nii.gz
         skeleton_rassoc_mask.nii.gz
         ```
    4. Run both extract_diffusivities_file.
    5. Run [calculate_alps.py](tbss/stats/calculate_alps.py). [python with pandas package is required]
