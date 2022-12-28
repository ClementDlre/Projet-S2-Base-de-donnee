import pandas as pd
import matplotlib.pyplot as plt
from datetime import date

'''
/!\
ATTENTION
Avant de lancer le programme, lisez lee commentaire ligne 128
ATTENTION
/!\
'''

pd.options.display.max_rows = 9999 # augmente le nombre de lignes max (cappé à 60 de base)

donnees = pd.read_csv("./personnelBidule.csv",sep = ';')

longueur = len(donnees)

dateArriveeLabo = donnees.iloc[0:longueur,0] # récupération de la date d'arrivée au laboratoire

civilites = donnees.iloc[0:longueur,1] # idem pour les civilités

noms = donnees.iloc[0:longueur,2] # idem pour les noms

prenoms = donnees.iloc[0:longueur,3] # idem pour les prénoms

datesNaissance = donnees.iloc[0:longueur,4] # idem pour les dates de naissance

def age(dateN):
    '''
    Fonction calculant l'âge au 1er Janvier 2022 grâce à la date de naissance en paramètre
    [param]
        dateN [date] : date de naissance de la personne dont on veut savoir l'âge
    [return]
        [int] : l'âge de la personne.
    '''
    repere = date(2022, 1, 1)
    age = repere.year - dateN.year - ((repere.month, repere.day) < (dateN.month, dateN.day))
    return age

ages = []

def strEnDate(chaine):
    '''
    Fonction permettant de traduire une chaine de caractère en date.
    /!\ La chaine de caractère doit être sous la forme "jj/mm/aaaa" /!\
    [param]
        string : Une chaine de caractère sous la forme "jj/mm/aaaa"
    [return]
        date : La date correspondante
    '''
    annee = int(chaine[6:])
    mois = int(chaine[3:5])
    jour = int(chaine[0:2])
    return date(annee, mois, jour)

for dateNaissance in datesNaissance:
    ages.append(age(strEnDate(dateNaissance))) # récupération des âges
    
paysOrigine = donnees.iloc[0:longueur,5] # idem pour les pays d'origine

categories = donnees.iloc[0:longueur,6] # idem pour les catégories

statuts = donnees.iloc[0:longueur,7] # idem pour les statuts

datesDebutSupport = donnees.iloc[0:longueur,11] # idem pour les dates de début du support

personnel = [] # va contenir les employés du laboratoire sans doublon
personnesTraitees = [] # va contenir les informations importantes des personnes déjà traitées : nom, prenom, date de naissance

for i in range(longueur): # On parcourt le csv
    personne = [dateArriveeLabo[i],civilites[i],noms[i],prenoms[i],datesNaissance[i],ages[i],paysOrigine[i],categories[i],statuts[i],datesDebutSupport[i]] # on récupère les données d'une personne
    testDoublon = [noms[i],prenoms[i],datesNaissance[i]] # on récupère les données importantes de la personne
    if (testDoublon not in personnesTraitees) and (i != longueur-1): # si la personne n'a pas encore été traitée.
        personnesTraitees.append(testDoublon) # on la rajoute dans la liste des personnes traitées
        j = i+1 # on choisit la personne suivante
        listeDoublons = [] # va contenir les doublons de la personne
        listeDoublons.append(personne)
        while testDoublon == [noms[j],prenoms[j],datesNaissance[j]]: # tant que la personne suivante est la même personne que celle d'avant...
            listeDoublons.append([dateArriveeLabo[j],civilites[j],noms[j],prenoms[j],datesNaissance[j],ages[j],paysOrigine[j],categories[j],statuts[j],datesDebutSupport[j]]) # ...on la rajoute dans la liste des doublons
            j+=1 # on passe à la personne suivante
        
        plusRecent = listeDoublons[0] # on initialise plusRecent à la première personne des doublons
        for doublon in listeDoublons: # pour chaque doublon
            if strEnDate(plusRecent[4]) <= strEnDate(doublon[4]): # si la date de début du support précède celle du plus récent...
                plusRecent = doublon #... le plus récent devient le doublon
            
        personnel.append(plusRecent) # ...on rajoute ensuite le doublon le plus récent dans le personnel
    elif (testDoublon not in personnesTraitees) and (i == longueur-1): # cas particulier pour i == longueur -1
        personnel.append(personne)    

for personne in personnel:
    del personne[9] # on supprime la date de début du support pour chaque personne car on en a plus besoin

dateArrivee = []
civilite = []
nom = []
prenom = []
dateN = []
age = []
paysOrigine = []
categorie = []
statut = []

for personne in personnel: # création des listes qui vont contenir les différentes données
    dateArrivee.append(personne[0])
    civilite.append(personne[1])
    nom.append(personne[2])
    prenom.append(personne[3])
    dateN.append(personne[4])
    age.append(personne[5])
    paysOrigine.append(personne[6])
    categorie.append(personne[7])
    statut.append(personne[8])
    
# Création de la dataFrame du csv.
donneesRH = pd.DataFrame({"Date d'arrivée labo" : dateArrivee,
                          "Civilité" : civilite,
                          "Nom" : nom,
                          "Prénom" : prenom,
                          "Date de naissance" : dateN,
                          "Âge au 1er janvier 2022" : age,
                          "Pays d'origine" : paysOrigine,
                          "Catégorie la plus récente" : categorie,
                          "Statut le plus récent" : statut})

# Création du fichier .csv
# /!\ Si vous voulez éxécuter ce code, il faut changer le path ci-dessous pour qu'il corresponde à un endroit sur votre PC. /!\
donneesRH.to_csv(r'C:\Users\jonat\OneDrive\Documents\SAE S2.04\Mission 3\donneeRH_Vage.csv', index=False)