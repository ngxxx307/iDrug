# import numpy as np

with open("./rawdata/DiseaseName", "r") as f:
    DiseaseName = f.readlines()
    f.close()
DiseaseName = [x.strip() for x in DiseaseName]
DiseaseName = DiseaseName[1:]

with open("./rawdata/Drug-Disease Interactions", "r") as f:
    Drug_Disease = f.readlines()
    f.close()

Drug_Disease = [x.strip() for x in Drug_Disease]
Drug_Disease = Drug_Disease[1:]
Drug_Disease = [x.split('\t') for x in Drug_Disease]
print(Drug_Disease[0:5])

