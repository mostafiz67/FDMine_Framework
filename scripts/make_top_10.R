library(tidyverse)
library(stringr)

# Shortest Path TOP 10 (Dis joint Dataset) ------------------------------------------------------------------------------------------------------------

FDI_SP_L2_dataset_1_disjoint <- read.csv("output/new_link_prediction_SP_L2_dataset_1_disjoint_FDI.csv", header = TRUE)
FDI_SP_L2_dataset_1_disjoint_new <- FDI_SP_L2_dataset_1_disjoint %>%
  separate(nodeB, c("food_ID", "Compound_ID", "Compound_Name"), "_")

FDI_SP_L2_dataset_1_disjoint_new$foodID_CompoundID_Compound_Name <- paste(FDI_SP_L2_dataset_1_disjoint_new$food_ID, "_",
                                                                          FDI_SP_L2_dataset_1_disjoint_new$Compound_ID, "_",
                                                                          FDI_SP_L2_dataset_1_disjoint_new$Compound_Name)

FDI_SP_L2_dataset_1_disjoint_new_unique <- FDI_SP_L2_dataset_1_disjoint_new %>% distinct(nodeA, Compound_Name, .keep_all = TRUE)
FDI_SP_L2_dataset_1_disjoint_new_unique <- FDI_SP_L2_dataset_1_disjoint_new %>% arrange(desc(score.y))


FDI_SP_L2_dataset_1_disjoint_new_unique_top_10 <- FDI_SP_L2_dataset_1_disjoint_new_unique[1:10, c("nodeA", 
                                                                                                  "foodID_CompoundID_Compound_Name", 
                                                                                                  "score.y")]

FDI_SP_L2_dataset_1_disjoint_new_unique_top_10$method <- "SP_2_disjoint"
colnames(FDI_SP_L2_dataset_1_disjoint_new_unique_top_10)[3] <- c("scr")


# 
# FDI_SP_L2_dataset_2_joint <- read.csv("output/new_link_prediction_SP_L2_dataset_2_joint_FDI.csv", header = TRUE)
# FDI_SP_L2_dataset_2_joint_new <- FDI_SP_L2_dataset_2_joint %>%
#   separate(nodeB, c("food_ID", "Compound_ID", "Compound_Name"), "_")
# 
# FDI_SP_L2_dataset_2_joint_new$foodID_CompoundID_Compound_Name <- paste(FDI_SP_L2_dataset_2_joint_new$food_ID, "_",
#                                                                        FDI_SP_L2_dataset_2_joint_new$Compound_ID, "_",
#                                                                        FDI_SP_L2_dataset_2_joint_new$Compound_Name)
# 
# FDI_SP_L2_dataset_2_joint_new_unique <- FDI_SP_L2_dataset_2_joint_new %>% distinct(nodeA, Compound_Name, .keep_all = TRUE)
# FDI_SP_L2_dataset_2_joint_new_unique <- FDI_SP_L2_dataset_2_joint_new_unique %>% arrange(desc(score.y))
# 
# 
# FDI_SP_L2_dataset_2_joint_new_unique_top_10 <- FDI_SP_L2_dataset_2_joint_new_unique[1:10, c("nodeA", 
#                                                                                             "foodID_CompoundID_Compound_Name", 
#                                                                                             "score.y")]
# 
# FDI_SP_L2_dataset_2_joint_new_unique_top_10$method <- "SP_2_joint"
# colnames(FDI_SP_L2_dataset_2_joint_new_unique_top_10)[3] <- c("scr")


# ------------ TOP 10 NeighborHood --------------------------------------------------------------------------------------------------------------------

FDI_NB_AA_dataset_2_joint <- read.csv("output/new_link_prediction_NB_AA_dataset_2_joint_FDI.csv", header = TRUE, stringsAsFactors = FALSE)

FDI_NB_AA_dataset_2_joint = FDI_NB_AA_dataset_2_joint %>% 
  mutate(col1 = pmin(nodeA, nodeB), col2 = pmax(nodeA, nodeB), 
         id = paste(col1, col2, sep="__")) %>% 
  separate(id, into=c("nodeA", "nodeB"), sep="__")

FDI_NB_AA_dataset_2_joint$col1 <- NULL
FDI_NB_AA_dataset_2_joint$col2 <- NULL

FDI_NB_AA_dataset_2_joint_new <- FDI_NB_AA_dataset_2_joint %>%
  separate(nodeB, c("food_ID", "Compound_ID", "Compound_Name"), "_")

FDI_NB_AA_dataset_2_joint_new$foodID_CompoundID_Compound_Name <- paste(FDI_NB_AA_dataset_2_joint_new$food_ID, "_",
                                                                       FDI_NB_AA_dataset_2_joint_new$Compound_ID, "_",
                                                                       FDI_NB_AA_dataset_2_joint_new$Compound_Name)

FDI_NB_AA_dataset_2_joint_new_unique_food_ID <- FDI_NB_AA_dataset_2_joint_new %>% distinct(food_ID, nodeA, .keep_all = TRUE)
FDI_NB_AA_dataset_2_joint_new_unique_food_ID <- FDI_NB_AA_dataset_2_joint_new_unique_food_ID %>% arrange(desc(scr))

FDI_NB_AA_dataset_2_joint_new_unique_food_ID_top_10 <- FDI_NB_AA_dataset_2_joint_new_unique_food_ID[1:10, c("nodeA", 
                                                                                                            "foodID_CompoundID_Compound_Name", 
                                                                                                            "scr")]
FDI_NB_AA_dataset_2_joint_new_unique_food_ID_top_10$method <- "AA"

FDI_NB_AA_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_AA_dataset_2_joint_new %>% distinct(food_ID, Compound_ID, Compound_Name, .keep_all = TRUE)
FDI_NB_AA_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_AA_dataset_2_joint_new_unique_food_ID_compound_ID %>% arrange(desc(scr))

FDI_NB_AA_dataset_2_joint_new_unique_food_ID_compound_ID_top_10 <- FDI_NB_AA_dataset_2_joint_new_unique_food_ID_compound_ID[1:10, c("nodeA", 
                                                                                                                                    "foodID_CompoundID_Compound_Name", 
                                                                                                                                    "scr")]

# For 2 mwthods (unique drug and food) and (unique food and compound) drug does not matter

FDI_NB_AA_dataset_2_joint_new_unique_food_ID_compound_ID_top_10$method <- "AA"


#--------------------- CN --------------------------------------------


FDI_NB_CN_dataset_2_joint <- read.csv("output/new_link_prediction_NB_CN_dataset_2_joint_FDI.csv", header = TRUE, stringsAsFactors = FALSE)

FDI_NB_CN_dataset_2_joint = FDI_NB_CN_dataset_2_joint %>% 
  mutate(col1 = pmin(nodeA, nodeB), col2 = pmax(nodeA, nodeB), 
         id = paste(col1, col2, sep="__")) %>% 
  separate(id, into=c("nodeA", "nodeB"), sep="__")

FDI_NB_CN_dataset_2_joint$col1 <- NULL
FDI_NB_CN_dataset_2_joint$col2 <- NULL

FDI_NB_CN_dataset_2_joint_new <- FDI_NB_CN_dataset_2_joint %>%
  separate(nodeB, c("food_ID", "Compound_ID", "Compound_Name"), "_")

FDI_NB_CN_dataset_2_joint_new$foodID_CompoundID_Compound_Name <- paste(FDI_NB_CN_dataset_2_joint_new$food_ID, "_",
                                                                       FDI_NB_CN_dataset_2_joint_new$Compound_ID, "_",
                                                                       FDI_NB_CN_dataset_2_joint_new$Compound_Name)

FDI_NB_CN_dataset_2_joint_new_unique_food_ID <- FDI_NB_CN_dataset_2_joint_new %>% distinct(food_ID, nodeA, .keep_all = TRUE)
FDI_NB_CN_dataset_2_joint_new_unique_food_ID <- FDI_NB_CN_dataset_2_joint_new_unique_food_ID %>% arrange(desc(scr))

FDI_NB_CN_dataset_2_joint_new_unique_food_ID_top_10 <- FDI_NB_CN_dataset_2_joint_new_unique_food_ID[1:10, c("nodeA", 
                                                                                                            "foodID_CompoundID_Compound_Name", 
                                                                                                            "scr")]
FDI_NB_CN_dataset_2_joint_new_unique_food_ID_top_10$method <- "CN"

FDI_NB_CN_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_CN_dataset_2_joint_new %>% 
  distinct(food_ID, Compound_ID, Compound_Name, .keep_all = TRUE)
FDI_NB_CN_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_CN_dataset_2_joint_new_unique_food_ID_compound_ID %>% arrange(desc(scr))

FDI_NB_CN_dataset_2_joint_new_unique_food_ID_compound_ID_top_10 <- FDI_NB_CN_dataset_2_joint_new_unique_food_ID_compound_ID[1:10, c("nodeA", 
                                                                                                                                    "foodID_CompoundID_Compound_Name", 
                                                                                                                                    "scr")]
# For 2 methods drugs and score remain the same


FDI_NB_CN_dataset_2_joint_new_unique_food_ID_compound_ID_top_10$method <- "CN"


# --------------------------- L3 ------------------------------------------------------------------------------------

FDI_NB_L3_dataset_2_joint <- read.csv("output/new_link_prediction_NB_L3_dataset_2_joint_FDI.csv", header = TRUE, stringsAsFactors = FALSE)

FDI_NB_L3_dataset_2_joint = FDI_NB_L3_dataset_2_joint %>% 
  mutate(col1 = pmin(nodeA, nodeB), col2 = pmax(nodeA, nodeB), 
         id = paste(col1, col2, sep="__")) %>% 
  separate(id, into=c("nodeA", "nodeB"), sep="__")

FDI_NB_L3_dataset_2_joint$col1 <- NULL
FDI_NB_L3_dataset_2_joint$col2 <- NULL

FDI_NB_L3_dataset_2_joint_new <- FDI_NB_L3_dataset_2_joint %>%
  separate(nodeB, c("food_ID", "Compound_ID", "Compound_Name"), "_")

FDI_NB_L3_dataset_2_joint_new$foodID_CompoundID_Compound_Name <- paste(FDI_NB_L3_dataset_2_joint_new$food_ID, "_",
                                                                       FDI_NB_L3_dataset_2_joint_new$Compound_ID, "_",
                                                                       FDI_NB_L3_dataset_2_joint_new$Compound_Name)

FDI_NB_L3_dataset_2_joint_new_unique_food_ID <- FDI_NB_L3_dataset_2_joint_new %>% distinct(food_ID, nodeA, .keep_all = TRUE)
FDI_NB_L3_dataset_2_joint_new_unique_food_ID <- FDI_NB_L3_dataset_2_joint_new_unique_food_ID %>% arrange(desc(scr))

FDI_NB_L3_dataset_2_joint_new_unique_food_ID_top_10 <- FDI_NB_L3_dataset_2_joint_new_unique_food_ID[1:10, c("nodeA", 
                                                                                                            "foodID_CompoundID_Compound_Name", 
                                                                                                            "scr")]
FDI_NB_L3_dataset_2_joint_new_unique_food_ID_top_10$method <- "L3"

FDI_NB_L3_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_L3_dataset_2_joint_new %>% 
  distinct(food_ID, Compound_ID, Compound_Name, .keep_all = TRUE)
FDI_NB_L3_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_L3_dataset_2_joint_new_unique_food_ID_compound_ID %>% arrange(desc(scr))

FDI_NB_L3_dataset_2_joint_new_unique_food_ID_compound_ID_top_10 <- FDI_NB_L3_dataset_2_joint_new_unique_food_ID_compound_ID[1:10, c("nodeA", 
                                                                                                                                    "foodID_CompoundID_Compound_Name", 
                                                                                                                                    "scr")]
FDI_NB_L3_dataset_2_joint_new_unique_food_ID_compound_ID_top_10$method <- "L3"


# --------------------------- RA -----------------------------------------------------------------------------------------------

FDI_NB_RA_dataset_2_joint <- read.csv("output/new_link_prediction_NB_RA_dataset_2_joint_FDI.csv", header = TRUE, stringsAsFactors = FALSE)

FDI_NB_RA_dataset_2_joint = FDI_NB_RA_dataset_2_joint %>% 
  mutate(col1 = pmin(nodeA, nodeB), col2 = pmax(nodeA, nodeB), 
         id = paste(col1, col2, sep="__")) %>% 
  separate(id, into=c("nodeA", "nodeB"), sep="__")

FDI_NB_RA_dataset_2_joint$col1 <- NULL
FDI_NB_RA_dataset_2_joint$col2 <- NULL

FDI_NB_RA_dataset_2_joint_new <- FDI_NB_RA_dataset_2_joint %>%
  separate(nodeB, c("food_ID", "Compound_ID", "Compound_Name"), "_")

FDI_NB_RA_dataset_2_joint_new$foodID_CompoundID_Compound_Name <- paste(FDI_NB_RA_dataset_2_joint_new$food_ID, "_",
                                                                       FDI_NB_RA_dataset_2_joint_new$Compound_ID, "_",
                                                                       FDI_NB_RA_dataset_2_joint_new$Compound_Name)

FDI_NB_RA_dataset_2_joint_new_unique_food_ID <- FDI_NB_RA_dataset_2_joint_new %>% distinct(food_ID, nodeA, .keep_all = TRUE)
FDI_NB_RA_dataset_2_joint_new_unique_food_ID <- FDI_NB_RA_dataset_2_joint_new_unique_food_ID %>% arrange(desc(scr))

FDI_NB_RA_dataset_2_joint_new_unique_food_ID_top_10 <- FDI_NB_RA_dataset_2_joint_new_unique_food_ID[1:10, c("nodeA", 
                                                                                                            "foodID_CompoundID_Compound_Name", 
                                                                                                            "scr")]
FDI_NB_RA_dataset_2_joint_new_unique_food_ID_top_10$method <- "RA"

FDI_NB_RA_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_RA_dataset_2_joint_new %>% 
  distinct(food_ID, Compound_ID, Compound_Name, .keep_all = TRUE)
FDI_NB_RA_dataset_2_joint_new_unique_food_ID_compound_ID <- FDI_NB_RA_dataset_2_joint_new_unique_food_ID_compound_ID %>% arrange(desc(scr))

FDI_NB_RA_dataset_2_joint_new_unique_food_ID_compound_ID_top_10 <- FDI_NB_RA_dataset_2_joint_new_unique_food_ID_compound_ID[1:10, c("nodeA", 
                                                                                                                                    "foodID_CompoundID_Compound_Name", 
                                                                                                                                    "scr")]
FDI_NB_RA_dataset_2_joint_new_unique_food_ID_compound_ID_top_10$method <- "RA"


#FDI_NB_AA_dataset_2_joint_new_unique_food_ID_top_10,
#FDI_NB_CN_dataset_2_joint_new_unique_food_ID_top_10,
#FDI_NB_L3_dataset_2_joint_new_unique_food_ID_top_10,
#FDI_NB_RA_dataset_2_joint_new_unique_food_ID_top_10,
finalCSV <- rbind(FDI_SP_L2_dataset_1_disjoint_new_unique_top_10,
                  FDI_NB_AA_dataset_2_joint_new_unique_food_ID_compound_ID_top_10,
                  FDI_NB_CN_dataset_2_joint_new_unique_food_ID_compound_ID_top_10,
                  FDI_NB_L3_dataset_2_joint_new_unique_food_ID_compound_ID_top_10,
                  FDI_NB_RA_dataset_2_joint_new_unique_food_ID_compound_ID_top_10)

write.csv(finalCSV, "output/Top_10_FDI_All_Methods_Batch_1.csv", row.names = FALSE)
