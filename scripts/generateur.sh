#!/bin/bash

OUTPUT=www/livres

if [ ! -d $OUTPUT ]
then
    mkdir $OUTPUT
fi

tail -n +2 data/livres.csv > data/tmp.csv

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
    COUNT=$(expr $COUNT + 1)
done < data/tmp.csv

cat templates/livres_debut.html > www/livres.html
while read Auteur Titre Editeur Annee ISBN QCouv; do 
    File=${ISBN//-/}; File=${File// /}; File=${File// /}
    echo "<tr><td>$Auteur</td><td><a href=\"livres/$File.html\">$Titre</a></td><td>$File</td><tr>" >> www/livres.html
done < data/tmp.csv
cat templates/livres_fin.html >> www/livres.html
