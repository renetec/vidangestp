#!/bin/bash

# Script de déploiement automatique pour VidangeSTP 2026
# Ce script compile l'application et l'installe sur le Pixel via ADB

APP_DIR="/home/rene/vidangestp/vidangestp_app"
COLOR_BLUE='\033[0;34m'
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${COLOR_BLUE}--- DÉPLOIEMENT VIDANGE STP 2026 ---${NC}"

# 1. Vérification de la connexion du téléphone
echo "Vérification de la connexion du Pixel..."
ADB_DEVICE=$(adb devices | grep -v "List" | grep "device")

if [ -z "$ADB_DEVICE" ]; then
    echo -e "${COLOR_RED}Erreur: Aucun appareil trouvé via ADB.${NC}"
    echo "Assurez-vous que votre Pixel est branché et que le 'Débogage USB' est activé."
    exit 1
fi
echo -e "${COLOR_GREEN}Pixel détecté!${NC}"

# 2. Compilation de l'APK
cd "$APP_DIR"
echo "Nettoyage et mise à jour des dépendances..."
# Utilisation de flutter si disponible, sinon on affiche une instruction
if command -v flutter &> /dev/null
then
    flutter pub get
    echo "Compilation de l'APK (Release)..."
    flutter build apk --release
else
    echo -e "${COLOR_RED}Erreur: La commande 'flutter' n'est pas dans le PATH.${NC}"
    echo "Veuillez lancer ce script depuis un terminal où Flutter est configuré."
    exit 1
fi

# 3. Installation sur le téléphone
APK_PATH="$APP_DIR/build/app/outputs/flutter-apk/app-release.apk"

if [ -f "$APK_PATH" ]; then
    echo "Installation de l'APK sur votre Pixel..."
    adb install -r "$APK_PATH"
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_GREEN}TERMINÉ! L'application est installée sur votre téléphone.${NC}"
        echo "Cherchez l'icône 'VidangeSTP 2026' dans vos applications."
    else
        echo -e "${COLOR_RED}Erreur lors de l'installation.${NC}"
    fi
else
    echo -e "${COLOR_RED}Erreur: Fichier APK non trouvé.${NC}"
fi
