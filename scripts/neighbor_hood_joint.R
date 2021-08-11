library(tidyverse)
library(igraph)
library(LinkPrediction)
library(bayestestR)
library(zoo)

# Setting Seed
set.seed(9999)

# Creating Some dataframe for storing result
df_ddi_fdi_ffi_info_sp_algo <- data.frame(1,2,3)
write.table(df_ddi_fdi_ffi_info_sp_algo, "output/Final_Calculation_Information_NB_dataset_2_joint.csv", row.names = FALSE, col.names = FALSE, sep=",") 

# Calculating Shortest Path Function
neighbor_final_output <- function(main_dataset_for_neighbor_algo) {
  
  train_dataset_for_neighbor_algo <- main_dataset_for_neighbor_algo
  
  graph_build <- graph_from_data_frame(train_dataset_for_neighbor_algo, directed = FALSE)
  
  cn_edgelist <- lp_cn(graph_build)
  cn_edgelist <- cn_edgelist %>%
    mutate(
      across(c("nodeA", "nodeB"), ~V(graph_build)[.x]$name)
    )
  
  cn_edgelist <- cn_edgelist %>% arrange(desc(scr))
  
  write.csv(cn_edgelist, "output/new_link_prediction_NB_CN_dataset_2_joint.csv", row.names = FALSE) 
  
  
  aa_edgelist <- lp_aa(graph_build)
  aa_edgelist <- aa_edgelist %>%
    mutate(
      across(c("nodeA", "nodeB"), ~V(graph_build)[.x]$name)
    )
  
  aa_edgelist <- aa_edgelist %>% arrange(desc(scr))
  write.csv(aa_edgelist, "output/new_link_prediction_NB_AA_dataset_2_joint.csv", row.names = FALSE) 
  
  
  l3_edgelist <- lp_l3(graph_build)
  l3_edgelist <- l3_edgelist %>%
    mutate(
      across(c("nodeA", "nodeB"), ~V(graph_build)[.x]$name)
    )
  
  l3_edgelist <- l3_edgelist %>% arrange(desc(scr))
  write.csv(l3_edgelist, "output/new_link_prediction_NB_L3_dataset_2_joint.csv", row.names = FALSE) 
  
  # Predicting new link using Dice
  ra_edgelist <- lp_ra(graph_build)
  ra_edgelist <- ra_edgelist %>%
    mutate(
      across(c("nodeA", "nodeB"), ~V(graph_build)[.x]$name)
    )
  
  ra_edgelist <- ra_edgelist %>% arrange(desc(scr))
  write.csv(ra_edgelist, "output/new_link_prediction_NB_RA_dataset_2_joint.csv", row.names = FALSE) 
  
}

# Training the dataset using Neighbor Methods

train_dataset_for_neighbor <- read.csv("output/dataset_2_joint.csv", header = TRUE)
neighbor_final_output(train_dataset_for_neighbor)
  



Calculation_Information_function <- function(nb_methods)
{
  nb_method <- nb_methods
  
  # The dataset path link
  all_data_ddi_fdi_ffi_info_sp_algo <- read.csv(file = paste0("output/new_link_prediction_NB_", nb_method, 
                                                             "_dataset_2_joint", ".csv", sep=""))
  all_data_ddi_fdi_ffi_info_sp_algo <- all_data_ddi_fdi_ffi_info_sp_algo %>% distinct(nodeA, nodeB, .keep_all = TRUE) # Taking Unique FDI Only
  #Removing DD and FF Interaction
  
  all_ddi <- all_data_ddi_fdi_ffi_info_sp_algo %>% 
    filter(grepl('^DB', nodeA) & grepl('^DB', nodeB))
  
  all_ddi <- all_ddi %>% arrange(desc(scr))
  write.csv(all_ddi, file = paste0("output/new_link_prediction_NB_", nb_method,
                                   "_dataset_2_joint", "_DDI", ".csv", sep=""), row.names = FALSE)
  
  
  all_fdi_dfi_ffi <- all_data_ddi_fdi_ffi_info_sp_algo %>% 
    filter(!grepl('^DB', nodeA) | !grepl('^DB', nodeB))
  
  
  df_remove_dd <- all_data_ddi_fdi_ffi_info_sp_algo %>% 
    filter(!grepl('^DB', nodeA) | !grepl('^DB', nodeB))
  
  df_remove_ff <- df_remove_dd %>% 
    filter(grepl('^DB', nodeA) | grepl('^DB', nodeB))
  
  #Simple calculation 
  totalDDInter <- nrow(all_data_ddi_fdi_ffi_info_sp_algo) - nrow(df_remove_dd)
  totalFFInter <- nrow(df_remove_dd) - nrow(df_remove_ff)
  totalFDInter <- nrow(df_remove_ff)
  
  df_remove_ff <- df_remove_ff %>% arrange(desc(scr))
  write.csv(df_remove_ff, file = paste0("output/new_link_prediction_NB_", nb_method,
                                        "_dataset_2_joint", "_FDI", ".csv", sep=""), row.names = FALSE)
  
  temp_df_ddi_fdi_ffi_info_sp_algo <- data.frame(method = nb_method,
                                                 Total = totalDDInter + totalFDInter + totalFFInter,
                                                 DDI = totalDDInter,
                                                 FDI = totalFDInter,
                                                 FFI = totalFFInter)
  
  df_ddi_fdi_ffi_info_sp_algo <-  read.csv(file = paste0("output/Final_Calculation_Information_NB_", 
                                                         "dataset_2_joint",".csv", sep=""))
  
  df_ddi_fdi_ffi_info_sp_algo <- rbind(df_ddi_fdi_ffi_info_sp_algo, temp_df_ddi_fdi_ffi_info_sp_algo) 
  
  write.csv(df_ddi_fdi_ffi_info_sp_algo, file = paste0("output/Final_Calculation_Information_NB_", 
                                                        "dataset_2_joint", ".csv", sep=""), row.names = FALSE)
}

# Calculating and splitting DDI, FDI and FFI from the prediction
for (method_name in 1:4) {
  if(method_name == 1)
  {
      Calculation_Information_function("CN")
    
  }
  
  else if(method_name == 2)
  {
      Calculation_Information_function("AA")
    
  }
  
  
  else if(method_name == 3)
  {
      Calculation_Information_function("L3")
    
  }
  
  
  else
  {

      Calculation_Information_function("RA")
    
  }
}

