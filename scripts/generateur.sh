#!/bin/bash

OUTPUT=www/livres

if [ ! -d $OUTPUT ]
then
    echo "Création d'un répertoire pour les pages HTML de livres."
    mkdir $OUTPUT
fi

tail -n +2 data/livres.csv > data/tmp.csv

echo -n "Génération des pages des livres" 

IFS="|"
COUNT=0
while read Auteur Titre Editeur Annee ISBN QCouv; do 
    File=${ISBN//-/}; File=${File// /}; File=${File// /}
    cat templates/livre.template.html | \
    sed s/%TITRE%/"$Titre"/ | 
    sed s/%AUTEUR%/"$Auteur"/ |
    sed s/%EDITEUR%/"$Editeur"/ |
    sed s/%ANNEE%/"$Annee"/ |
    sed s/%ISBN%/"$File"/ |
    sed s/%QCOUV%/"$QCouv"/ > $OUTPUT/$File.html
    echo -n "."
    COUNT=$(expr $COUNT + 1)
done < data/tmp.csv

echo 
if [ "$COUNT" = "1" ] || [ "$COUNT" = "0" ]
then
    echo "$COUNT page générée."
else 
    echo "$COUNT pages générées."
fi

echo Génération du tableau des livres.
cat templates/livres_debut.html > www/livres.html
while read Auteur Titre Editeur Annee ISBN QCouv; do 
    File=${ISBN//-/}; File=${File// /}; File=${File// /}
    echo "<tr><td>$Auteur</td><td><a href=\"livres/$File.html\">$Titre</a></td><td>$File</td><tr>" >> www/livres.html
done < data/tmp.csv
cat templates/livres_fin.html >> www/livres.html

echo "Suppression des fichiers temporaires."
rm -f data/tmp.csv