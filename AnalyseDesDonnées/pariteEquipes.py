import pandas as pd
import matplotlib.pyplot as plt

pd.options.display.max_rows = 9999 # augmente le nombre de lignes max (cappé à 60 de base)

donnees = pd.read_csv("./personnelBidule.csv",sep = ';')

longueur = len(donnees)

civilites = donnees.iloc[0:longueur,1]

noms = donnees.iloc[0:longueur,2]

prenoms = donnees.iloc[0:longueur,3]

datesNaissance = donnees.iloc[0:longueur,4]

equipes = donnees.iloc[0:longueur,13]

personnel = [] # va contenir les employés du laboratoire sans doublon

for i in range(longueur): # On parcourt le csv
    personne = [civilites[i],noms[i],prenoms[i],datesNaissance[i],equipes[i]] # une personne = civilite + nom + prenom + dateNaissance + equipe
    if personne not in personnel and (equipes[i] != "--- Inconnue ---"): # si la personne est pas déjà dans le personnel et qu'on connaît son équipe...
        personnel.append(personne) # ...on la rajoute

listeEquipes = [] # va contenir la liste des équipes
pariteEquipes = [] # va contenir des listes de ce format [x,y] avec x : nombre d'hommes, y : nombres de femmes

for personne in personnel: # on parcourt le personnel sans doublon
    equipe = personne[4] # récupération de l'équipe
    civilite = personne[0] # récupération de la civilité
    
    if equipe not in listeEquipes: # si l'équipe n'est pas dans la liste des équipes...
        listeEquipes.append(equipe) # ...on rajoute l'équipe dans la liste des équipes...
        pariteEquipes.append([0,0]) # ...et la liste des sexes correspondante
   
    indexEquipe = listeEquipes.index(equipe) # recherche de l'index de l'équipe correspondante

    if civilite == 'M': # on incrémente les compteurs de l'équipe selon le sexe de la personne
        pariteEquipes[indexEquipe][0] += 1
    else:
        pariteEquipes[indexEquipe][1] += 1
        
pourcentageHommes = [] # va contenir les pourcentages d'hommes
for parite in pariteEquipes: # calcul des pourcentages
    total = parite[0] + parite[1]
    pourcentageHommes.append((parite[0] / total) * 100)
    
pourcentageHommesParEquipe = [[listeEquipes[i],pourcentageHommes[i]] for i in range(len(listeEquipes))]
# la liste au dessus contient des listes de ce format [x,y] avec x : nom de l'équipe, y : pourcentage d'hommes dans l'équipe

plt.boxplot(pourcentageHommes)
plt.title("Pourcentage d'hommes par équipe")
plt.ylim(0,110)
plt.show()

def moyenne(liste):
    '''
    Cette fonction calcule la moyenne d'une liste rentrée en paramètre.
    [param]
        [list] : une liste contenant des nombres.
    [return]
        [double] : la moyenne de la liste
    '''
    somme = 0
    for pourcentage in liste:
        somme += pourcentage
    return somme / len(liste)



# CALCUL DES MEDAILLES

# QUESTION 2, MEDAILLE D'OR, EQUIPE QUI RESPECTE LA PARITE-
def respectParite():
    '''
    Fonction affichant les équipes respectant la parité.
    '''
    for equipe in pourcentageHommesParEquipe:
        if equipe[1] <= 60 and equipe[1] >= 40:
            print("Equipe :",equipe[0]," Pourcentage :",equipe[1])
# Equipe :  GRAPHIX  Pourcentage :  50.0

# QUESTION 2, MEDAILLE DE PLASTIQUE, EQUIPE LA PLUS DISCRIMINATOIRE
def equipeDiscriminatoire():
    '''
    Cette fonction retourne la liste des équipes les plus discriminatoires.
    [return]
        list : liste des équipes les plus discriminatoires
    '''
    equipesDiscriminatoires = []
    maxi = max(pourcentageHommes)
    for i in range(len(pourcentageHommes)):
        if pourcentageHommes[i] == maxi:
            equipesDiscriminatoires.append([listeEquipes[i],pourcentageHommes[i],pariteEquipes[i][0]+pariteEquipes[i][1]])
    return equipesDiscriminatoires

# MEDAILLE D'ARGENT
def maxFemmes():
    '''
    Cette fonction renvoie le pourcentage de l'équipe ayant une majorité de femmes.
    '''
    equipesPlusDeFemmes = []
    mini = min(pourcentageHommes)
    for i in range(len(pourcentageHommes)):
        if pourcentageHommes[i] == mini:
            equipesPlusDeFemmes.append([listeEquipes[i],100 - pourcentageHommes[i]])
    return equipesPlusDeFemmes

        
        
        
        