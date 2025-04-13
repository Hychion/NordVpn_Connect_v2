# 🔐 NordVPN Connect Tool v2

Un script interactif en **Bash** pour te connecter facilement à NordVPN via le terminal.  
Pas besoin de retenir les commandes ou codes serveurs : tu navigues dans un menu propre, tu choisis ton pays, ta ville ou un type de serveur spécialisé, et tu te connectes en toute sécurité.  

Ce script a été pensé pour combiner **simplicité**, **puissance**, et **compréhension des technologies VPN** utilisées.

---

## 🚀 Installation

1. Télécharge le script :

```bash
git clone https://github.com/tonrepo/nordvpn-connect-v2.git
cd nordvpn-connect-v2
chmod +x nordvpn-connect-v2.sh
```

2. Lance-le

```bash
./nordvpn-connect-v2.sh
```
❗ Assure-toi que NordVPN est installé sur ta machine :

```bash
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
```


## 🧭 Fonctionnalités

✅ Connexion rapide au meilleur serveur disponible

✅ Choix par pays + ville avec noms lisibles

✅ Accès aux serveurs spécialisés : P2P, Double VPN, Onion Over VPN, Obfuscated

✅ Changement du protocole VPN (OpenVPN ou NordLynx)

✅ Aide intégrée dans le menu

✅ Navigation intuitive avec option de retour à tout moment

## 🛠️ Technologies NordVPN – Explication

NordVPN propose plusieurs types de serveurs pour s’adapter à différents besoins. Voici ce qu’ils font :
### 🌐 Serveurs Standard

    Serveurs classiques utilisés pour la navigation, le streaming ou tout usage général.

    Chiffrement fort (AES-256)

    Bonne vitesse, stabilité

    Utilisés par défaut via nordvpn connect




### 🔄 Serveurs P2P

    Optimisés pour les torrents et les partages de fichiers en peer-to-peer (ex: qBittorrent).

    Aucun blocage de trafic P2P

    Très stables pour les gros transferts

    Dispo dans plusieurs pays
```bash
nordvpn connect --group P2P
```

### 🧅 Serveurs Onion Over VPN

    Combine un VPN + le réseau Tor (sans avoir à utiliser Tor Browser).

    Idéal pour l’anonymat extrême

    Le trafic est d’abord chiffré par le VPN, puis envoyé sur le réseau Tor

    Parfait pour le dark web ou la protection des sources
```bash
nordvpn connect --group Onion_Over_VPN
```

### 🧊 Serveurs Double VPN

    Le trafic est chiffré deux fois, en passant par deux serveurs VPN successifs dans des pays différents.

    Excellent pour les journalistes, activistes ou parano bienveillants 😄

    Un peu plus lent, mais ultra-sécurisé
```bash
nordvpn connect --group Double_VPN
```
###🕳️ Serveurs Obfuscated

    Permettent de masquer que tu utilises un VPN.

    Indispensable dans les pays où les VPN sont bloqués (ex: Chine, Iran)

    Fonctionne uniquement avec le protocole OpenVPN

    Contourne les pare-feux et restrictions réseau

```bash
nordvpn set technology openvpn
nordvpn set obfuscate on
nordvpn connect
```
### ⚙️ Protocole VPN

Deux protocoles sont disponibles :
🔹 NordLynx

    Basé sur WireGuard – rapide et moderne.

    Ultra-performant

    Idéal pour le streaming, la navigation et les jeux

    Pas compatible avec certains serveurs spéciaux (ex: Obfuscated)

nordvpn set technology nordlynx

🔸 OpenVPN

    Classique et robuste.

    Compatible avec tous les types de serveurs

    Recommandé pour Obfuscation
```bash
nordvpn set technology openvpn
```

### 🛡️ Prérequis

    Linux (Debian, Ubuntu, Arch…)

    Un compte NordVPN actif

    Client NordVPN installé

