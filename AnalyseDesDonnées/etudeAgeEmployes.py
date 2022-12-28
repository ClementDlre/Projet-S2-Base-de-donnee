import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

pd.options.display.max_rows = 9999 # augmente le nombre de lignes max (cappé à 60 de base)

donnees = pd.read_csv("./donneeRH_Vage.csv") # stockage du fichier csv

ages = donnees.iloc[0:len(donnees),5] # récupération de l'âge

def moyenne(liste):
    '''
    Cette fonction calcule la moyenne d'une liste donnée en paramètre.
    [param]
        liste : Une liste contenant des nombres
    [return]
        double : la moyenne de la liste.
    '''
    somme = 0
    for age in liste:
        somme += age
    return somme / len(liste)

def repartitionAges(listeAges):
    '''
    Cette fonction calcule la répartition des âges d'une liste d'âges selon différentes tranches.
    [param]
        listeAges : une liste d'âges
    [return]
        list[double] : Le pourcentage des âges selon différentes tranches d'âge.
    '''
    age18_25 = 0
    age26_35 = 0
    age36_45 = 0
    age46_60 = 0
    age60Plus = 0
    for age in listeAges:
        if age <= 25:
            age18_25 += 1
        elif age > 25 and age <= 35:
            age26_35 += 1
        elif age > 35 and age <= 45:
            age36_45 += 1
        elif age > 45 and age <= 60:
            age46_60 += 1
        else:
            age60Plus += 1
            
    total = len(listeAges)
    repartition = [age18_25/total,age26_35,age36_45,age46_60,age60Plus]
    
    for valeur in repartition:
        valeur = (valeur / total) * 100 # calcul des pourcentages.
        
    return repartition


repartition = repartitionAges(ages)
x = np.array(repartition)
intervalles = ["18-25","26-35","36-45","46-60","60+"]

plt.pie(x, labels = intervalles, autopct='%.1f%%')

plt.title('Répartition des âges dans le laboratoire Bidule')

plt.show()
plt.close()

plt.boxplot(ages)
plt.title("Répartition des âges dans le laboration Bidule")
plt.ylim(0,80)
plt.show()
plt.close()