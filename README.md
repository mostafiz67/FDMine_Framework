# FDMine_Framework

Use `run.sh` to run the FDMine Framework. Before executing `run.sh` you have to change the path address in the `run.sh` file. You do not have to do anything else!

### Dataset Description
 The FDMine need 3 datasets (in .CSV formate) to execute. They are `Drug_SSP.csv`, `Food_SSP.csv`, and `food_contribution.csv`. The structure of the dataset are given below
 
 ### Drug_SSP.csv

drugbank.id  | smiles
------------- | -------------
DB01059 | OC(=O)C1=CN=CC=C1
DB04908  | FC(F)(F)C1=CC(=CC=C1)N1CCN(CCN2C(=O)NC3=CC=CC=C23)CC1

 ### Food_SSP.csv

public_food_id_compound_id_name | compound_SMILES
------------- | -------------
FOOD00004 _ FDB001014 _ Nicotinic acid | CCN1C=C(C(O)=O)C(=O)C2=CC(F)=C(C=C12)N1CCNCC1
FOOD00004 _ FDB003513 _ Calcium | [Ca++]

 ### food_contribution.csv

public_food_id_compound_id_name | contribution
------------- | -------------
FOOD00004 _ FDB001014 _ Nicotinic acid | 0.000417143789774213
FOOD00004 _ FDB003513 _ Calcium | 0.0246710755666463


### Parameter passing from the bash script

Change the argument given in the `run.sh` file, if you want to set your own `Tanimotot threshold` and `Food contribution threshold`. The Tanimoto threshold is related to `calculate_ssp.py` and the food contribution threshold is related to `food_contribution_threshold.R` files respectively.




### Required Packages of R

- library(tidyverse) [1.3.0]
- library(igraph) [1.2.6]
- library(LinkPrediction) [1.0]
- library(bayestestR) [0.8.2]
- library(zoo) [1.8-9]
- library(dplyr) [1.0.5]

### Required Packages of Python
- Python==3.8.5
- rdkit==2021.03.2
- panda
