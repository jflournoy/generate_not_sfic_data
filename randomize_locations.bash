#!/bin/bash
fx_data_dir=/home/jflournoy/data/sfic_fx/sfic_fx
temp_data_dir=/home/jflournoy/data/tmpdata
shuffled_data_dir=/home/jflournoy/data/not_sfic_fx/fx
mask_file="/home/jflournoy/data/sfic_fx/wave1_T-2_2mm.nii"
clustsim=/home/jflournoy/abin/3dClustSim

mkdir -p $temp_data_dir
mkdir -p $shuffled_data_dir

echo "Generating fake data..."
$clustsim -mask $mask_file -pthr .001 \
  -iter 1000 \
  -athr .05 -acf 0.457482  4.97156  12.535 \
  -ssave:masked $temp_data_dir/blur.nii

echo "Renaming fake data..."
indx=1
for file in `ls $fx_data_dir`; do
  echo "Creating $file..."
  cp `ls -1 $temp_data_dir/blur*|head -n $indx|tail -n 1` $shuffled_data_dir/$file
  indx=$((indx + 1))
done

echo "Cleaning up temporary files..."
rm -rf $temp_data_dir

echo "All done!"

