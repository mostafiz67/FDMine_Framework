# Calculating New similarity using multiplication and matching

library(dplyr)


# ----------------------------- This Part is for taking Contribution threashhold of the food compound -----------------------------------------------------------
args <- commandArgs(TRUE)

df_1 <- read.csv("dataset/food_contribution.csv", header = TRUE)
print(nrow(df_1))
df_2 <- read.csv("dataset/drugid_foodid-name_similarity_threshold.csv", header = TRUE)
print(nrow(df_2))

o <- lapply(df_2[c("query","target")], function(x) {
  df_1$contribution[match(x, df_1$public_food_id_compound_id_name)] * df_2$similarity
})
o <- do.call(pmax, c(o, na.rm=TRUE))
o[is.na(o)] <- df_2$similarity[is.na(o)]

df_2$new_ssp <- o


# Removing rows based on the new_similarity (0.1)
food_contribution <- as.double(args) 
df_remove <- df_2
df_remove<-df_remove[!(df_remove$new_ssp < food_contribution),]
df_remove$similarity <- NULL

# Saving for further use
write.csv(df_remove, "output/dataset_1_disjoint.csv", row.names = FALSE)  
