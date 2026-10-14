#!/bin/bash
# Double-clic pour construire l'app (une seule fois), puis l'ouvrir.
cd "$(dirname "$0")"
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Les outils de développement Apple sont nécessaires."
    echo "Une fenêtre d'installation va s'ouvrir : clique sur « Installer », puis relance ce fichier."
    xcode-select --install
    read -n 1 -s -r -p "Appuie sur une touche pour fermer..."
    exit 1
fi
./build.sh && open AutoClick.app
echo; read -n 1 -s -r -p "Terminé. Appuie sur une touche pour fermer..."
