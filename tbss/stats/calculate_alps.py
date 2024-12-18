# This script calculates the DTI-ALPS index according to 
#   Taoka, T., Masutani, Y., Kawai, H. et al. 
#   Evaluation of glymphatic system activity with the diffusion MR technique: diffusion tensor image analysis 
#   along the perivascular space (DTI-ALPS) in Alzheimer’s disease cases.
#   Jpn J Radiol 35, 172–178 (2017). https://doi.org/10.1007/s11604-017-0617-z

import pandas as pd

df_sph = pd.read_csv('diffusivities_spherical.csv')
df_skel = pd.read_csv('diffusivities_skeletonised.csv')

# Calculate spherical ALPS
df_sph['lalps'] = ((df_sph['dxx_lproj'] + df_sph['dxx_lassoc'])/2) / ((df_sph['dyy_lproj'] + df_sph['dzz_lassoc'])/2)
df_sph['ralps'] = ((df_sph['dxx_rproj'] + df_sph['dxx_rassoc'])/2) / ((df_sph['dyy_rproj'] + df_sph['dzz_rassoc'])/2)
df_sph['malps'] = (df_sph['lalps'] + df_sph['ralps'])/2

df_sph.to_csv('diffusivities_spherical.csv', index=False)

# Calculate skeletonised ALPS
df_skel['lalps'] = ((df_skel['dxx_lproj'] + df_skel['dxx_lassoc'])/2) / ((df_skel['dyy_lproj'] + df_skel['dzz_lassoc'])/2)
df_skel['ralps'] = ((df_skel['dxx_rproj'] + df_skel['dxx_rassoc'])/2) / ((df_skel['dyy_rproj'] + df_skel['dzz_rassoc'])/2)
df_skel['malps'] = (df_skel['lalps'] + df_skel['ralps'])/2

df_skel.to_csv('diffusivities_skeletonised.csv', index=False)
