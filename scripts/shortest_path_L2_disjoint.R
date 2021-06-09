library(tidyverse)
library(igraph)
library(LinkPrediction)
library(bayestestR)

# Setting Seed
set.seed(9999)


# Creating Some dataframe for storing result
df_ddi_fdi_ffi_info_sp_algo <- data.frame(1,2,3)
write.table(df_ddi_fdi_ffi_info_sp_algo, "output/Final_Calculation_Information_SP_dataset_1_disjoint.csv", row.names = FALSE, col.names = FALSE, sep=",") 

# Calculating Shortest Path Function
shortest_path_final_model_l2 <- function(main_dataset_for_shortest_path_algo) {
  
  shortest_path_length <- 2
  # main_dataset_for_shortest_path_algo <- train_dataset_for_shortest_path
  train_dataset_for_shortest_path_algo <- main_dataset_for_shortest_path_algo
  
  df <- train_dataset_for_shortest_path_algo
  df$X <- NULL
  g1 <- df
  
  graph1 <- graph_from_data_frame(g1, directed = FALSE)
  
  mat_1 <- shortest.paths(graph1)
  
  mat_pivot_lon_1 <- as.data.frame.table(mat_1, responseName = "score") %>%
    mutate(Var1 = as.character(Var1),
           Var2 = as.character(Var2)) %>%
    filter(score ==shortest_path_length & Var1 <= Var2) %>%
    rename(nodeA = Var1, nodeB = Var2)
  
  
  # ------------------- This portion is finding new link summation of the path length (0.6, 1.7)      -----------------
  # train_dataset_for_shortest_path_algo <- read.csv(file = paste0(path_address_train_test, "train", "_", i, ".csv", sep=""))
  
  df <- train_dataset_for_shortest_path_algo
  df$X <- NULL
  g2 <- df
  
  graph2 <- graph_from_data_frame(g2, directed = FALSE)
  E(graph2)$weight <- g2$new_ssp
  mat_2 <- shortest.paths(graph2, weights=E(graph2)$weight)
  
  mat_pivot_lon_2 <- as.data.frame.table(mat_2, responseName = "score") %>%
    mutate(Var1 = as.character(Var1),
           Var2 = as.character(Var2)) %>%
    filter(Var1 <= Var2) %>%
    rename(nodeA = Var1, nodeB = Var2)
  
  # Merging and collecting only matched pair from both file and saving as new link predictions
  
  output <- inner_join(mat_pivot_lon_1, mat_pivot_lon_2, by = c("nodeA", "nodeB"))
  write.csv(output, "output/new_link_prediction_SP_L2_dataset_1_disjoint.csv", row.names = FALSE) 
  
  
  # This part is for calculating the number of DDI, FDI, and FFI from the new_link_prediction_SP_2_train_1_0.5.csv CSV file
  
  # The dataset path link
  
  all_data_ddi_fdi_ffi_info_sp_algo <- read.csv("output/new_link_prediction_SP_L2_dataset_1_disjoint.csv", header = TRUE)
  
  #Removing DD and FF Interaction
  
  all_ddi <- all_data_ddi_fdi_ffi_info_sp_algo %>% 
    filter(grepl('^DB', nodeA) & grepl('^DB', nodeB))
  
  all_ddi <- all_ddi %>% arrange(desc(score.y))
  
  write.csv(all_ddi, "output/new_link_prediction_SP_L2_dataset_1_disjoint_DDI.csv", row.names = FALSE) 
  
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
  
  df_remove_ff <- df_remove_ff %>% arrange(desc(score.y))
  
  write.csv(df_remove_ff, "output/new_link_prediction_SP_L2_dataset_1_disjoint_FDI.csv", row.names = FALSE) 
  
  temp_df_ddi_fdi_ffi_info_sp_algo <- data.frame(method = "Final_SP_dataset_1",
                                                 SP_length = shortest_path_length,
                                                 Total = totalDDInter + totalFDInter + totalFFInter,
                                                 DDI = totalDDInter,
                                                 FDI = totalFDInter,
                                                 FFI = totalFFInter)
  
  df_ddi_fdi_ffi_info_sp_algo <-  read.csv("output/Final_Calculation_Information_SP_dataset_1_disjoint.csv")
  
  df_ddi_fdi_ffi_info_sp_algo <- rbind(df_ddi_fdi_ffi_info_sp_algo, temp_df_ddi_fdi_ffi_info_sp_algo) 
  
  write.csv(df_ddi_fdi_ffi_info_sp_algo, "output/Final_Calculation_Information_SP_dataset_1_disjoint.csv", row.names = FALSE) 
  
}

# Training the dataset using shortest path
train_dataset_for_shortest_path <- read.csv("output/dataset_1_disjoint.csv", header = TRUE)
shortest_path_final_model_l2(train_dataset_for_shortest_path)
