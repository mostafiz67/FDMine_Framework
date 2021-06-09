

import os, sys
from rdkit import Chem
from rdkit import DataStructs
from rdkit.Chem.Fingerprints import FingerprintMols
import pandas as pd
from pandas import DataFrame

# python3 -m scripts.calculate_ssp (from FDMine_Docker)

def calculate_ssp():
  drug_data = pd.read_csv(os.path.join(os.path.join(os.getcwd(), "dataset"), "Drug_SSP.csv"), index_col=None)
  # print(drug_data)
  drug_data.columns=['ID_Name', 'SMILES']
  food_data = pd.read_csv(os.path.join(os.path.join(os.getcwd(), "dataset"), "Food_SSP.csv"), index_col=None)
  # print(food_data)
  food_data.columns = ['ID_Name', 'SMILES']

  drug_food_data = drug_data.append(food_data, ignore_index = True) # Whole dataset

  #Proff and make a list of Smiles and id
  c_smiles = []
  count = 0
  for index, row in drug_food_data.iterrows():
    try:
      cs = Chem.CanonSmiles(row['SMILES'])
      c_smiles.append([row['ID_Name'], cs])
    except:
      count = count + 1
      print('Count Invalid SMILES:', count, row['ID_Name'], row['SMILES'])
  # print()

  # make a list of id, smiles, and mols
  ms = []
  df = DataFrame(c_smiles,columns=['ID_Name','SMILES'])
  for index, row in df.iterrows():
    mol = Chem.MolFromSmiles(row['SMILES'])
    ms.append([row['ID_Name'], row['SMILES'], mol])
  # print(*ms, sep='\n')

  # make a list of id, smiles, mols, and fingerprints (fp)
  fps = []
  df_fps = DataFrame(ms,columns=['ID_Name','SMILES', 'mol'])
  df_fps.head

  for index, row in df_fps.iterrows():
    fps_cal = FingerprintMols.FingerprintMol(row['mol'], minPath=1, maxPath=7, fpSize=2048,
                               bitsPerHash=2, useHs=True, tgtDensity=0.0,
                               minSize=128)
    fps.append([row['ID_Name'], fps_cal])
  # print(*fps, sep='\n')

  # the list for the dataframe
  qu, ta, sim = [], [], []

  fps_2 = DataFrame(fps,columns=['ID_Name','fps'])
  fps_2 = fps_2[fps_2.columns[1]]
  fps_2 = fps_2.values.tolist()

  c_smiles2 = DataFrame(fps,columns=['ID_Name','fps'])
  c_smiles2 = c_smiles2[c_smiles2.columns[0]]
  c_smiles2 = c_smiles2.values.tolist()
  print(len(c_smiles2))

  # compare all fp pairwise without duplicates
  for n in range(len(fps_2)): 
      s = DataStructs.BulkTanimotoSimilarity(fps_2[n], fps_2[n+1:]) # +1 compare with the next to the last fp
      # print(len(s))
      for m in range(len(s)):
          qu.append(c_smiles2[n])
          ta.append(c_smiles2[n+1:][m])
          sim.append(s[m])
  print(len(qu))
  print(len(ta))
  print(len(sim))

  # build the dataframe and sort it
  d = {'query':qu, 'target':ta, 'similarity':sim}
  df_final = pd.DataFrame(data=d)
  df_final = df_final.sort_values('query')
  print(df_final)

  # Removing Duplicate 
  df_final = df_final[['query', 'target', 'similarity']].drop_duplicates()
  # save as csv
  df_final.to_csv(os.path.join(os.path.join(os.getcwd(), "dataset"),"drugid_foodid-name_similarity.csv"), index=False, sep=',')

  tanimoto_threshold = float(sys.argv[1])
  df_threshold = df_final[(df_final['similarity'] >= tanimoto_threshold)]
  new_file_name = "drugid_foodid-name_similarity_" + "threshold" + ".csv"

  df_threshold.to_csv(os.path.join(os.path.join(os.getcwd(), "dataset"),new_file_name), index=False, sep=',')

# if __name__=="__main":
calculate_ssp()