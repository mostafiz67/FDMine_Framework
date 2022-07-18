# FDMine_Framework

# Abstract
Food-drug interactions (FDIs) arise when nutritional dietary consumption regulates biochemical mechanisms involved in drug metabolism. 
This study proposes FDMine, a novel systematic framework that models the FDI problem as a homogenous graph. Our dataset consists of 788 unique approved 
small molecule drugs with metabolism-related drug-drug interactions and 320 unique food items, composed of 563 unique compounds. 
The potential number of interactions is 87,192 and 92,143 for disjoint and joint versions of the graph. We defined several similarity 
subnetworks comprising food-drug similarity, drug-drug similarity, and food-food similarity networks.  A unique part of the graph involves encoding the food composition as a set of nodes and calculating a content contribution score.  To predict new FDIs, we considered several link prediction algorithms and various performance metrics, including the precision@top (top 1%, 2%, and 5%) of the newly predicted links.  The shortest path-based method  has achieved a precision of 84%, 60% and 40% for the top 1%, 2% and 5% of FDIs identified, respectively. We validated  the top FDIs predicted using FDMine to demonstrate its applicability, and we relate therapeutic anti-inflammatory effects of food items  informed by FDIs. FDMine is publicly available to support clinicians and researchers.},

[The framework of FDMine] (https://github.com/mostafiz67/FDMine_Framework/blob/master/figures/Figure_1.png)

[Comparison of the precision@top over eight methods and two different graph networks] (https://github.com/mostafiz67/FDMine_Framework/blob/master/figures/Figure_1.png)



# Framework Execute
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


### Citation

Please cite the following publication if any of the results in this paper or code are beneficial in your research:

```
﻿@Article{Rahman2022,
author={Rahman, Md. Mostafizur and Vadrev, Srinivas Mukund and Magana-Mora, Arturo and Levman, Jacob and Soufan, Othman},
title={A novel graph mining approach to predict and evaluate food-drug interactions},
journal={Scientific Reports},
year={2022},
month={Jan},
day={20},
volume={12},
number={1},
pages={1061},
issn={2045-2322},
doi={10.1038/s41598-022-05132-y},
url={https://doi.org/10.1038/s41598-022-05132-y}
}

```


### Required R Packages

- library(tidyverse) [1.3.0]
- library(igraph) [1.2.6]
- library(LinkPrediction) [1.0]
- library(bayestestR) [0.8.2]
- library(zoo) [1.8-9]
- library(dplyr) [1.0.5]

### Required Python Packages
- Python==3.8.5
- rdkit==2021.03.2
- panda
