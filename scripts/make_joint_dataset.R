library(tidyverse)
library(igraph)

# Setting Seed
set.seed(9999)

# Making Joint Dataset from Disjoint main dataset

making_joint_dataset <- function(main_dataset_disjoint){
  
  g <- main_dataset_disjoint
  graph1 <-  graph_from_data_frame(g, directed = FALSE)
  E(graph1)$weight <- g$new_ssp
  cl <- components(graph1)
  
  if(cl$no >=2 ){
  mat_1 <- shortest.paths(graph1, weights=E(graph1)$weight)
  
  graph2 <- with(
    stack(membership(cl)),
    add.edges(
      graph1,
      c(combn(sapply(split(ind, values), sample, size = 1), 2)),
      weight = 0.00001))
  
  df <- igraph::as_data_frame(graph2)
  
  
  df$new_ssp <-NULL
  write.csv(df, "output/dataset_2_joint.csv", row.names = FALSE) 
  }
  else{
    print("Dataset dose not contain subgraphs. So, Disjoint and Joint they are same graph")
    write.csv(g, "output/dataset_2_joint.csv", row.names = FALSE) 
  }
  
  
}

# Loading disjoint dataset
main_dataset_disjoint <- read.csv("~/Desktop/FDMine_Docker/output/dataset_1_disjoint.csv", header = TRUE)
# main_dataset_disjoint <- read.csv("~/output/dataset_1_disjoint.csv", header = TRUE)

# Calling function to make joint dataset from disjoint
making_joint_dataset(main_dataset_disjoint)
