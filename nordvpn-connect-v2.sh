#!/bin/bash

pause() {
  echo ""
  read -p "🔁 Appuie sur Entrée pour continuer..."
}

# Fonction pour vérifier l'état de Tor
check_tor_status() {
  if systemctl is-active --quiet tor; then
    return 0  # Tor est actif
  else
    return 1  # Tor est inactif
  fi
}

main_menu() {
  clear
  echo "╔════════════════════════════════════╗"
  echo "║    🔐 NordVPN Connection Tool v2   ║"
  echo "╠════════════════════════════════════╣"
  echo "║ 1. Connexion rapide (meilleur VPN) ║"
  echo "║ 2. Connexion par pays et ville     ║"
  echo "║ 3. Serveurs spécialisés (P2P...)   ║"
  echo "║ 4. Changer de protocole VPN        ║"
  echo "║ 5. Quitter                         ║"
  echo "║ 6. ℹ️ Aide / Explication           ║"
  
  # Affichage dynamique du statut Tor
  if check_tor_status; then
    echo "║ 7. Tor (Actif) 🟢                ║"
  else
    echo "║ 7. Tor (Inactif) 🔴              ║"
  fi
  
  echo "╚════════════════════════════════════╝"
  echo ""
  read -p "👉 Choix [1-7] : " choix

  case $choix in
    1) nordvpn connect && pause && main_menu ;;
    2) country_menu ;;
    3) special_servers_menu ;;
    4) protocol_menu ;;
    5) echo "👋 À bientôt !"; exit 0 ;;
    6) show_help ;;
    7) tor_menu ;;
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
  echo "6. Aide : Affiche cette aide."
  echo ""
  echo "7. Gestion Tor :"
  echo "   - Démarrer/arrêter le service Tor local."
  echo "   - Vérifier l'état et tester la connexion via Tor."
  echo "   - Compatible avec proxychains pour router le trafic."
  echo ""
  echo "📌 Astuce : tu peux taper 'retour' dans n'importe quel menu pour revenir en arrière."
  pause
  main_menu
}

tor_menu() {
  while true; do
    clear
    echo "🧅 Menu de gestion Tor"
    echo ""
    echo "1. Démarrer Tor"
    echo "2. Arrêter Tor"
    echo "3. Vérifier l'état"
    echo "4. Retour au menu principal"
    echo ""
    read -p "👉 Choix [1-4] : " tor_choice

    case $tor_choice in
      1)
        echo "🔄 Démarrage de Tor..."
        if sudo systemctl start tor 2>/dev/null; then
          echo "✅ Tor est lancé."
        else
          echo "❌ Échec du démarrage de Tor. Vérifiez que Tor est installé."
        fi
        pause
        ;;
      2)
        echo "🔄 Arrêt de Tor..."
        if sudo systemctl stop tor 2>/dev/null; then
          echo "✅ Tor est arrêté."
        else
          echo "❌ Échec de l'arrêt de Tor."
        fi
        pause
        ;;
      3)
        echo "🔍 Vérification de l'état de Tor..."
        echo ""
        echo "📊 État du service Tor :"
        sudo systemctl status tor --no-pager -l
        echo ""
        
        if check_tor_status; then
          echo "🔗 Test de connexion via Tor..."
          if command -v proxychains &> /dev/null; then
            tor_test=$(proxychains -q curl -s --max-time 10 https://check.torproject.org/ 2>/dev/null)
            if echo "$tor_test" | grep -q "Congratulations"; then
              echo "✅ Connexion Tor fonctionnelle ! Vous utilisez bien Tor."
            elif echo "$tor_test" | grep -q "Sorry"; then
              echo "❌ Vous n'utilisez pas Tor pour cette connexion."
            else
              echo "⚠️  Test Tor inconcluant. Vérifiez votre configuration proxychains."
            fi
          else
            echo "⚠️  proxychains non installé. Impossible de tester la connexion Tor."
            echo "💡 Installez proxychains avec : sudo apt install proxychains"
          fi
        else
          echo "❌ Tor n'est pas en cours d'exécution."
        fi
        pause
        ;;
      4)
        main_menu
        return
        ;;
      *)
        echo "❌ Choix invalide."
        pause
        ;;
    esac
  done
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
  echo "1. P2P (torrent)"
  echo "2. Onion Over VPN"
  echo "3. Double VPN"
  echo "4. Obfuscated"
  echo "5. Retour"
  echo ""
  read -p "👉 Choix [1-5] : " type

  case $type in
    1)
      echo "🔗 Connexion à un serveur P2P..."
      nordvpn connect --group P2P || echo "❌ Échec de connexion P2P"
      ;;
    2)
      echo "⚙️ Passage à OpenVPN requis..."
      nordvpn set technology openvpn
      echo "🔗 Connexion à un serveur Onion Over VPN..."
      nordvpn connect --group Onion_Over_VPN || echo "❌ Échec de connexion Onion Over VPN"
      ;;
    3)
      echo "⚙️ Passage à OpenVPN requis..."
      nordvpn set technology openvpn
      echo "🔗 Connexion à un serveur Double VPN..."
      nordvpn connect --group Double_VPN || echo "❌ Échec de connexion Double VPN"
      ;;
    4)
      echo "⚙️ Passage à OpenVPN + obfuscation..."
      nordvpn set technology openvpn
      nordvpn set obfuscate on
      echo "🔗 Connexion à un serveur obfusqué..."
      nordvpn connect || echo "❌ Échec de connexion Obfuscated"
      ;;
    5)
      main_menu
      return
      ;;
    *)
      echo "❌ Choix invalide."
      pause
      special_servers_menu
      return
      ;;
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
