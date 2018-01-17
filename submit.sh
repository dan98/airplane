#!/bin/bash
#SBATCH --time=00:05:00
#SBATCH --mem=32000
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --output=mainv4.out
module load MATLAB/2017b-GCC-4.9.3-2.25
matlab -nodisplay -r genvideo
