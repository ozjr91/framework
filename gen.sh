#!/bin/bash 

IFS='|'

while read Auteur Titre Maison Publication ISBN Description; do
    sed "s/%TITRE%/$Titre/g; s/%AUTEUR%/$Auteur/g; s/%EDITEUR%/$Maison/g; \
    s/%ANNEE%/$Publication/g; s/%ISBN%/$ISBN/g; s/%QCOUV%/$Quatrième_couverture/g" \
    templates/livre.template.html > "$Site.html"
done < data/livres.csv    
