import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

pd.options.display.max_rows = 9999 # augmente le nombre de lignes max (cappé à 60 de base)

donnees = pd.read_csv("./personnelBidule.csv",sep = ';') # lecture du CSV

longueur = len(donnees)

civilites = donnees.iloc[0:longueur,1] # On récupère les civilités

noms = donnees.iloc[0:longueur,2] # idem pour les noms

prenoms = donnees.iloc[0:longueur,3] # idem pour les prénoms

datesNaissance = donnees.iloc[0:longueur,4] # idem pour les dates de naissance

personnel = [] # va contenir les employés du laboratoire sans doublon

for i in range(longueur): # On parcourt le csv
    personne = [civilites[i],noms[i],prenoms[i],datesNaissance[i]] # une personne = civilite + nom + prenom + dateNaissance
    if personne not in personnel: # si la personne est pas déjà dans le personnel...
        personnel.append(personne) # ...on la rajoute
        
hommes = 0
femmes = 0

for personne in personnel: # on parcourt le personnel sans doublon
    if personne[0] == 'M': # on compte les hommes et les femmes
        hommes += 1
    else:
        femmes += 1

total = hommes + femmes
x = np.array([(hommes/total)*100,(femmes/total)*100]) # calculs des pourcentages d'hommes et de femmes mis dans une liste
sexes = ["hommes","femmes"]
explosion = [0,0.2]
plt.pie(x, labels = sexes, explode = explosion, autopct='%.1f%%')

plt.title('Répartition des sexes dans le laboratoire Bidule')

plt.show()