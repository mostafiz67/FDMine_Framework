#!/bin/bash

python3 -m scripts.calculate_ssp 0.5

#Write the folder address of the FDMine_Docker
cd /home/mostafiz/Desktop/FDMine_Docker

#Change the path address of the scripts folder
Rscript  /home/mostafiz/Desktop/FDMine_Docker/scripts/food_contribution_threshold.R 0.6
Rscript  /home/mostafiz/Desktop/FDMine_Docker/scripts/make_joint_dataset.R 
Rscript  /home/mostafiz/Desktop/FDMine_Docker/scripts/shortest_path_L2_disjoint.R 
Rscript  /home/mostafiz/Desktop/FDMine_Docker/scripts/neighbor_hood_joint.R
Rscript  /home/mostafiz/Desktop/FDMine_Docker/scripts/make_top_10.R

# other bash commands
