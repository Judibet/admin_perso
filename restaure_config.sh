#!/bin/bash
## RESTAURATION CONFIGURATION PERSONNALISÉE ##
# VARIABLES GLOBALES ##
VERSION="1.0"																	# Version du script
PARAMETRES="${*}"																# Paramètres
REPERTOIRE="/media/sauvegardes/Kubuntu"														# Répertoire backup
FONDSGRUB="/media/nfspersonnalisation/Ordinateurs/Linux/Grub/"											# Fonds d'écran pour GRUB
UTILISATEUR="$(echo ${USER})"															# Utilisateur
SYSTEME="$(cat /etc/issue | awk '{print $1}')"													# Système d'exploitation
ORDINATEUR="$(echo ${HOSTNAME})"														# PC
SCRIPT="$(basename ${0})"															# Nom du script

## COULEURS ET STYLES ##
DEFAUT="$(tput sgr0)"																# Aucun style
NOIR="$(tput setaf 0)"																# Texte noir
ROUGE="$(tput setaf 1)"																# Texte rouge
VERT="$(tput setaf 2)"																# Texte vert
JAUNE="$(tput setaf 3)"																# Texte jaune
BLEU="$(tput setaf 4)"																# Texte bleu
MAGENTA="$(tput setaf 5)"															# Texte magenta
CYAN="$(tput setaf 6)"																# Texte cyan
BLANC="$(tput setaf 7)"																# Texte blanc
FNOIR="$(tput setab 0)"																# Fond noir
FROUGE="$(tput setab 1)"															# Fond rouge
FVERT="$(tput setab 2)"																# Fond vert
FJAUNE="$(tput setab 3)"															# Fond jaune
FBLEU="$(tput setab 4)"																# Fond bleu
FMAGENTA="$(tput setab 5)"															# Fond magenta
FCYAN="$(tput setab 6)"																# Fond cyan
FBLANC="$(tput setab 7)"															# Texte blanc
GRAS="$(tput bold)"																# Gras
DEMI_TEINTE="$(tput dim)"															# Demi-teinte
MODESOULIGNE="$(tput smul)"															# Activer le soulignement
PASSOULIGNE="$(tput rmul)"															# Désactiver le soulignement
INVERSE="$(tput rev)"																# Inverser le style
MODEGRAS="$(tput smso)"																# Activer la mise en gras
PASGRAS="$(tput rmso)"																# Désactiver la mise en gras
SONNETTE="$(tput bel)"																# Faire sonner le PC


# FONCTIONS #
# Manuel
function Usage(){
    # Variables locales
    local TypeErreur="${1}"															# Type erreur
    local Script="${2}"																# Nom du script
    local BlancScript="$(echo ${Script} | tr '[:alnum:][:cntrl:][:print:][=C=]' ' ')"								# Espace à la taille du nom du script
    local Version="${3}"															# Version du script
    local CodeErreur=0																# Code retour
    #
    case "${TypeErreur}" in
        "aide" )
        echo " ${CYAN}${Script}${DEFAUT}"
        echo " ${BlancScript}                                   --tout"
        echo " ${BlancScript}                                   --restauration"
        echo " ${BlancScript}                                   --pilotes"
        echo " ${BlancScript}                                   --cachelogs-apache"
        echo " ${BlancScript}                                   --ren-disques"
        echo " ${BlancScript}                                   --moins-swapp"
        echo " ${BlancScript}                                   --nfs"
        echo " ${BlancScript}                                   --liens-vbox"
        echo " ${BlancScript}                                   --splash-grub"
        echo " ${BlancScript}                                   --aide"
        echo " ${BlancScript}                                   --version"
        echo
        ;;
        * )
        echo " Utilisation :"
        echo " ${CYAN}${Script}${DEFAUT}"
        echo " ${BlancScript}                                   --aide"
        echo " ${BlancScript}                                   --version"
        echo
        ;; 
    esac
}

# Test des paramètres
function TestParams(){
    # Variables locales
    local Parametre="${1}"															# Paramètre à tester
    local Script="${2}"																# Nom du script
    local Version="${3}"															# Version du script
    local CodeErreur=0																# Code retour
    #
    case "${Parametre}" in
        "-a"|"--aide"|"-h"|"--help" )
        echo "${MAGENTA} **AIDE**${DEFAUT}"
        Usage "aide" "${Script}" "${Version}"
        echo
        exit 0
        ;;
        "-r"|"--restauration" )
        ExecutionPrincipale "restauration"
        ;;
        "-d"|"--depots" )
        ExecutionPrincipale "depots"
        ;;
        "-t"|"--tout" )
        ExecutionPrincipale "tout"
        ;;
        "--pilotes" )
        ExecutionPrincipale "pilotes"
        ;;
        "--cachelogs-apache" )
        ExecutionPrincipale "cachelogs-apache"
        ;;
        "--ren-disques" )
        ExecutionPrincipale "ren-disques"
        ;;
        "--moins-swapp" )
        ExecutionPrincipale "moins-swapp"
        ;;
        "--nfs" )
        ExecutionPrincipale "nfs"
        ;;
        "--liens-vbox" )
        ExecutionPrincipale "liens-vbox"
        ;;
        "--splash-grub" )
        ExecutionPrincipale "splash-grub"
        ;;
        "-v"|"--version" )
        echo "${CYAN} Version ${Version}${DEFAUT}"
        echo
        exit 0
        ;;
        * )
        if [[ ! -z "${Parametre}" ]]; then
            echo "${ROUGE} Paramètre ${Parametre} inconnu${DEFAUT}"
            echo
            Usage "params" "${Script}" "${Version}"
            exit 1
        else
            ExecutionPrincipale "tout"
        fi
        ;;
     esac
}

# Test du code retour
function TestCodeErreur(){
    # Variables locales
    local CodeRetour=${1}															# Code retourné
    local FonctionEnErreur="${2}"														# Fonction en erreur
    #
    if [[ "${CodeRetour}" -ne 0 ]]; then
        echo "${ROUGE} Une erreur est survenue dans la fonction ${FonctionEnErreur} [${CodeRetour}]${DEFAUT}"
        echo
        exit ${CodeRetour}
    fi
    :
}

# Test si le système est bien basé sous Ubuntu ou non
function TestUbuntu(){
    # Variables locales
    local SystemeExploitation="${1}"														# Système d'exploitation
    local CodeErreur=0																# Code retour
    if [[ "${SystemeExploitation}" != "Ubuntu" ]]; then
        local CodeErreur=2
        echo "${ROUGE} Erreur [${CodeErreur}] : le système d'exploitation n'est pas basé sous Ubuntu !${DEFAUT}"
        echo
        exit ${CodeErreur}
    fi
    :
}

# Test si le PC est valide, pour éviter que le script soit utilsé par erreur sur un PC non référencé
function TestOrdinateur(){
    # Variables locales
    local PC="${1}"																# Ordinateur en cours d'utilisation
    local CodeErreur=0																# Code retour
    #
    if [[ "${PC}" =~ ^PTX-040A$|^RTX-050C$ ]]; then
        :
    else
        if [[ -z "${PC}" ]]; then
            echo "${ROUGE} Ce PC n'est pas autorisé à utiliser ce script${DEFAUT}"
            echo
        else
            echo "${ROUGE} Ce PC [${PC}] n'est pas autorisé à utiliser ce script${DEFAUT}"
            echo
        fi
        local CodeErreur=3
        exit ${CodeErreur}
    fi
    :
}

# Titre
function Titre(){
    # Variables locales
    local VersionScript="${1}"															# Version du script
    local CodeErreur=0																# Code retour
    #
    echo "${FBLEU}${BLANC} REMISE EN PLACE DE LA CONFIGURATION ${VersionScript}${DEFAUT}"
    echo
}

# Restauration des configurations
function Restaurations(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo "${VERT} Restauration${DEFAUT}"
    # Restauration du fichier hots
    sudo cp "${REPERTOIRE}/etc/hosts" "/etc/"							2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Restaurations"
    # Effets personnalisés Roccat
    sudo cp "${REPERTOIRE}/usr/share/roccat/*.lua" "/usr/share/roccat/ryos_effect_modules/"	2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Restaurations"
    # Activation Trim
    sudo fstrim -v /
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Restaurations"
    sudo cp "${REPERTOIRE}/etc/cron.daily/fstrim" "/etc/cron.daily/"				2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Restaurations"
    sudo chmod +x "/etc/cron.daily/fstrim"							2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Restaurations"
}

# Mise à jour des dépôts
function MAJDepots(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo "${VERT} Ajout des dépôts en cours...${DEFAUT}"
    # Restauration de la liste des sources
    sudo cp "${REPERTOIRE}/etc/apt/sources.list" "/etc/apt"					2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Ajout de dépôts manuel :
    # Grub Customizer
    sudo add-apt-repository ppa:danielrichter2007/grub-customizer
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # NVidia
    sudo add-apt-repository ppa:graphics-drivers/ppa
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Lecturs vidéos Google Play etc.
    sudo add-apt-repository ppa:mjblenner/ppa-hal
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Cinelerra
    sudo add-apt-repository ppa:cinelerra-ppa/ppa
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    #
    # Moonlight (Mono Project)
    #sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    #CodeErreur=${?}
    #TestCodeErreur ${CodeErreur} "MAJDepots"
    #echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
    #CodeErreur=${?}
    #TestCodeErreur ${CodeErreur} "MAJDepots"
    # Gimp
    sudo add-apt-repository ppa:otto-kesselgulasch/gimp
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # UfRAM
    #sudo add-apt-repository ppa:ferramroberto/ufraw
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Google
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1397BC53640DB551
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Lauchpad
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv E671B39AF038E545
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    gpg --export --armor E671B39AF038E545 | sudo apt-key add -
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Multisystem
    sudo apt-add-repository 'deb http://liveusb.info/multisystem/depot all main'
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | sudo apt-key add -
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Mumble
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 85DECED27F05CF9E
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Nextcloud
    sudo add-apt-repository ppa:nextcloud-devs/client
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    #OBS
    sudo add-apt-repository ppa:obsproject/obs-studio
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Spotify
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    # Virtual Box
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"
    sudo apt-key add "${REPERTOIRE}/Clés publiques/*"
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MAJDepots"

    sleep 3
}

# Restauration des pilotes
function Pilotes(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo " ${VERT}Remise en place de la configuration des périphériques :${DEFAUT}"
    sudo cp "$#REPERTOIRE}/usr/share/X11/xorg.conf.d/*" "/usr/share/X11/xorg.conf.d/"		2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Pilotes"
    sudo chmod -x +r "/usr/share/X11/xorg.conf.d/*"						2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Pilotes"
    sudo cp "${REPERTOIRE}/etc/X11/*" "/etc/X11/"						2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Pilotes"
    sudo chmod -x +r "/etc/X11/xorg.conf"							2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "Pilotes"
}

# Mise en cache RAM des logs Apache
function CacheJournauxApache(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo "${VERT} Mise en cache des logs Apache en RAM :${DEFAUT}"
    sudo cp "${REPERTOIRE}/etc/init.d/*" "/etc/init.d/"						2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "CacheJournauxApache"
    sudo chmod +x "/etc/init.d/apache2-tmpfs" "/etc/init.d/mysql-tmpfs"				2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "CacheJournauxApache"
}

# Renommer les disques dur
function RenommerDisques(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo "${VERT} Renommage des lecteurs :${DEFAUT}"
    #sudo e2label /dev/sda1 Racine
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo jfs_tune -L Racine /dev/sda1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo e2label /dev/sdb1 HOMES
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo e2label /dev/sdb2 Donnees
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo umount /dev/sdc1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo ntfslabel /dev/sdc1 Sauvegardes
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo mount /dev/sdc1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo swapoff -v /dev/sdc2
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo mkswap -L "SWAP" /dev/sdc2
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
    #sudo swapon -v /dev/sdc2
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "RenommerDisques"
}

# Réduire la possibilité de SWAP
function ReduireSWAP(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo "${VERT} Réduction de la possibilité de swapper :${DEFAUT}"
    sudo cp "${REPERTOIRE}/etc/sysctl.conf" "/etc/"						2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "ReduireSWAP"
}

## Rajout de points de montages NFS
function MiseEnPlaceNFS(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo "${VERT} Rajout des points de montage NFS${DEFAUT}"
    sudo mkdir "/media/nfsjeux" "/media/nfsiso" "/media/nfslogiciels" "/media/nfspilotes" "/media/nfsmusique" "/media/nfsimages" "/media/nfsvideos" "/media/nfsvm" "/media/nfspersonnalisation"	2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MiseEnPlaceNFS"
    sudo echo -e "\n\n## Montages NFS\n192.168.1.151:/export/Jeux/ /media/nfsjeux                nfs     ro                0       0\n192.168.1.151:/export/Logiciels/ /media/nfslogiciels      nfs     ro                0       0\n192.168.1.151:/export/ISO/ /media/nfsiso                  nfs     ro                0       0\n192.168.1.151:/export/Pilotes/ /media/nfspilotes          nfs     ro                0       0\n192.168.1.151:/export/Musique/ /media/nfsmusique          nfs     ro                0       0\n192.168.1.151:/export/Images/ /media/nfsimages            nfs     ro                0       0
192.168.1.151:/export/Vidéos/ /media/nfsvideos            nfs     ro                0       0\n192.168.1.151:/export/MachinesVirtuelles/ /media/nfsvm    nfs     defaults,user,auto,noatime,intr 0       0\n192.168.1.151:/export/Personnalisation/ /media/nfspersonnalisation nfs ro           0       0\n" >> /etc/fstab						2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MiseEnPlaceNFS"
    sudo mount -a										2>&1
    CodeErreur=${?}
    TestCodeErreur ${CodeErreur} "MiseEnPlaceNFS"
}

# Création du lien symbolique pour VirtualBox
function LiensSymboliquesVirtualBox(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    if [[ -L "${HOME}/VirtualBox VMs" ]]; then
        unlink "${HOME}/VirtualBox VMs"								2>&1
        CodeErreur=${?}
        TestCodeErreur ${CodeErreur} "LiensSymboliquesVirtualBox"
        ln -s "/media/nfsvm" "${HOME}/VirtualBox VMs"						2>&1
        CodeErreur=${?}
        TestCodeErreur ${CodeErreur} "LiensSymboliquesVirtualBox"
    else
        ln -s "/media/nfsvm" "${HOME}/VirtualBox VMs"						2>&1
        CodeErreur=${?}
        TestCodeErreur ${CodeErreur} "LiensSymboliquesVirtualBox"
    fi
}

# Fonds d'écran pour Grub
function FondsGrub(){
    # Variables locales
    local CodeErreur=0																# Code retour
    #
    echo "${VERT} Copie des fonds d'écran pour Grub :${DEFAUT}"
    if [[ ! -d "/boot/grub/splash" ]]; then
        sudo mkdir "/boot/grub/splash"								2>&1
        CodeErreur=${?}
        TestCodeErreur ${CodeErreur} "FondsGrub"
        sudo cp "${FONDSGRUB}/*" "/boot/grub/splash/"						2>&1
        CodeErreur=${?}
        TestCodeErreur ${CodeErreur} "FondsGrub"
    fi
}

# Fonction pricipale
function ExecutionPrincipale(){
    # Variables locales
    local Type="${1}"																# Type de lancement
    local CodeErreur=0																# Code retour
    #
    TestOrdinateur "${ORDINATEUR}"
    TestUbuntu "${SYSTEME}"
    Titre "${VERSION}"
    case "${Type}" in
        "restauration" )
        #echo "${VERT} Restauration${DEFAUT}"
        Restaurations
        :
        ;;
        "depots" )
        #echo "${VERT} Mise à jour des dépôts${DEFAUT}"
        MAJDepots
        :
        ;;
        "pilotes" )
        #echo "${VERT} Restauration des pilotes${DEFAUT}"
        Pilotes
        :
        ;;
        "cachelogs-apache" )
        #echo "${VERT} Mise en place du cache des journaux pour apache2${DEFAUT}"
        CacheJournauxApache
        :
        ;;
        "ren-disques" )
        #echo "${VERT} Renommage des partitions${DEFAUT}"
        RenommerDisques
        :
        ;;
        "moins-swapp" )
        #echo "${VERT} Réduction des tentatives de SWAP${DEFAUT}"
        ReduireSWAP
        :
        ;;
        "nfs" )
        #echo "${VERT} Mise en place NFS${DEFAUT}"
        MiseEnPlaceNFS
        :
        ;;
        "liens-vbox" )
        #echo "${VERT} Liens symboliques pour VirtualBox${DEFAUT}"
        LiensSymboliquesVirtualBox
        :
        ;;
        "splash-grub" )
        #echo "${VERT} Fonds d'écrans pour GRUB${DEFAUT}"
        FondsGrub
        :
        ;;
        "tout"| * )
        Restaurations
        MAJDepots
        Pilotes
        CacheJournauxApache
        RenommerDisques
        ReduireSWAP
        MiseEnPlaceNFS
        LiensSymboliquesVirtualBox
        FondsGrub
        :
        ;;
    esac
    echo "${FVERT}${BLEU} RESTAURATION DE LA CONFIGURATION TERMINÉE${DEFAUT}"
    echo
}

# DÉBUT #
    if [[ "${#}" -gt 1 ]]; then
        echo "${ROUGE} Ce script n'accèpte pas de prendre ${#} paramètres"
        echo
        Usage "params" "${SCRIPT}" "${VERSION}"
        exit 1
    else
        TestParams "${PARAMETRES}" "${SCRIPT}" "${VERSION}"
    fi

# FIN
    #pause
    exit 0
