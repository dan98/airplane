#!/bin/bash
#SBATCH --time=00:05:00
#SBATCH --mem=2000
#SBATCH --nodes=4
#SBATCH --ntasks=16
#SBATCH --output=mainv4.out
module load MATLAB/2017b-GCC-4.9.3-2.25
matlab -nodisplay -r mainv4
