#!/bin/bash

pause() {
  echo ""
  read -p "🔁 Appuie sur Entrée pour continuer..."
}

main_menu() {
  clear
  echo "╔════════════════════════════════════╗"
  echo "║    🔐 NordVPN Connection Tool v2   ║"
  echo "╠════════════════════════════════════╣"
  echo "║ 1. Connexion rapide (meilleur VPN)║"
  echo "║ 2. Connexion par pays et ville    ║"
  echo "║ 3. Serveurs spécialisés (P2P...)  ║"
  echo "║ 4. Changer de protocole VPN       ║"
  echo "║ 5. Quitter                        ║"
  echo "║ 6. ℹ️ Aide / Explication           ║"
  echo "╚════════════════════════════════════╝"
  echo ""
  read -p "👉 Choix [1-6] : " choix

  case $choix in
    1) nordvpn connect && pause && main_menu ;;
    2) country_menu ;;
    3) special_servers_menu ;;
    4) protocol_menu ;;
    5) echo "👋 À bientôt !"; exit 0 ;;
    6) show_help ;;
    *) echo "❌ Choix invalide." && pause && main_menu ;;
  esac
}

show_help() {
  clear
  echo "🆘 Aide – Explication des options"
  echo ""
  echo "1. Connexion rapide :"
  echo "   -> Se connecte automatiquement au meilleur serveur disponible."
  echo ""
  echo "2. Connexion par pays et ville :"
  echo "   -> Affiche la liste des pays et leurs villes disponibles."
  echo "   -> Permet une connexion ciblée comme 'France Paris'."
  echo ""
  echo "3. Serveurs spécialisés :"
  echo "   - P2P : Pour les téléchargements torrents."
  echo "   - Double VPN : Trafic chiffré via 2 serveurs VPN."
  echo "   - Onion Over VPN : Trafic passant par Tor + VPN."
  echo "   - Obfuscated : Pour contourner les restrictions (Chine, Émirats...)."
  echo ""
  echo "4. Changer de protocole VPN :"
  echo "   - NordLynx : Rapide, basé sur WireGuard."
  echo "   - OpenVPN : Plus classique, supporte les serveurs obfusqués."
  echo ""
  echo "5. Quitter : Ferme le script."
  echo ""
  echo "📌 Astuce : tu peux taper 'retour' dans n'importe quel menu pour revenir en arrière."
  pause
  main_menu
}


country_menu() {
  clear
  echo "🌍 Liste des pays disponibles :"
  nordvpn countries
  echo ""
  read -p "✏️ Entre un pays (ou 'retour' pour revenir) : " pays

  if [[ "$pays" == "retour" ]]; then
    main_menu
    return
  fi

  city_picker "$pays"
}

city_picker() {
  local country="$1"
  villes=$(nordvpn cities "$country" 2>/dev/null)

  if [[ -z "$villes" ]]; then
    echo "🔗 Connexion à $country..."
    nordvpn connect "$country"
    pause
    main_menu
  else
    echo ""
    echo "🏙️ Villes disponibles pour $country :"

    for ville in $villes; do
      ville_nom=$(echo "$ville" | sed -E 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}' | xargs)
      echo "- $ville_nom"
    done

    echo ""
    read -p "✏️ Entre le nom exact de la ville (ou 'retour') : " ville_choisie

    if [[ "$ville_choisie" == "retour" ]]; then
      country_menu
      return
    fi

    echo "🔗 Connexion à $country $ville_choisie..."
    nordvpn connect "$country" "$ville_choisie"
    pause
    main_menu
  fi
}


special_servers_menu() {
  clear
  echo "🎯 Types de serveurs spécialisés :"
  echo "1. P2P"
  echo "2. Onion Over VPN"
  echo "3. Double VPN"
  echo "4. Obfuscated"
  echo "5. Retour"
  echo ""
  read -p "👉 Choix [1-5] : " type

  case $type in
    1) nordvpn connect --group P2P ;;
    2) nordvpn connect --group Onion_Over_VPN ;;
    3) nordvpn connect --group Double_VPN ;;
    4)
      nordvpn set technology openvpn
      nordvpn set obfuscate on
      nordvpn connect
      ;;
    5) main_menu ;;
    *) echo "❌ Choix invalide." && pause && special_servers_menu ;;
  esac
  pause
  main_menu
}

protocol_menu() {
  clear
  echo "⚙️ Choix du protocole VPN :"
  echo "1. NordLynx (rapide)"
  echo "2. OpenVPN (compatible obfuscation)"
  echo "3. Retour"
  echo ""
  read -p "👉 Choix [1-3] : " proto

  case $proto in
    1) nordvpn set technology nordlynx ;;
    2) nordvpn set technology openvpn ;;
    3) main_menu ;;
    *) echo "❌ Choix invalide." && pause && protocol_menu ;;
  esac
  pause
  main_menu
}

main_menu
