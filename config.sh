## CONFIGURATION PERSONNALISÉE ##
#!/bin/sh
export REPERTOIRE=/media/sauvegardes/Kubuntu
export FONDSGRUB=/media/nfspersonnalisation/Ordinateurs/Linux/Grub/

echo REMISE EN PLACE DE LA CONFIGURATION && echo ""



## Restauration fichier Hosts
sudo cp $REPERTOIRE/etc/hosts /etc/



## Activation Trim :
sudo fstrim -v /
sudo cp $REPERTOIRE/etc/cron.daily/fstrim /etc/cron.daily/
sudo chmod +x /etc/cron.daily/fstrim



## Mise à jour des dépôts
echo Ajout des dépôts en cours...
sudo cp $REPERTOIRE/etc/apt/sources.list /etc/apt			# Restauration de la liste des sources
# Ajout de dépôts manuel :
sudo add-apt-repository ppa:danielrichter2007/grub-customizer           # Pour Grub Customizer
sudo add-apt-repository ppa:graphics-drivers/ppa                        # Pour NVidia
sudo add-apt-repository ppa:mjblenner/ppa-hal                           # Permet de lire les vidéos Google Play
# Cinelerra
sudo add-apt-repository ppa:cinelerra-ppa/ppa
#
# Moonlight (Mono Project)
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
#echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
# Gimp et UfRAW
sudo add-apt-repository ppa:otto-kesselgulasch/gimp
#sudo add-apt-repository ppa:ferramroberto/ufraw
# Google
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1397BC53640DB551
# Lauchpad
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv E671B39AF038E545
gpg --export --armor E671B39AF038E545 | sudo apt-key add -
# Multisystem
sudo apt-add-repository 'deb http://liveusb.info/multisystem/depot all main'
wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | sudo apt-key add -
# Mumble
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 85DECED27F05CF9E
# Nextcloud
sudo add-apt-repository ppa:nextcloud-devs/client
#OBS
sudo add-apt-repository ppa:obsproject/obs-studio
# Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
# Virtual Box
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-key add $REPERTOIRE/Clés\ publiques/*

sleep 3



# Pilotes
echo "Remise en place de la configuration des périphériques :"
sudo cp $REPERTOIRE/usr/share/X11/xorg.conf.d/* /usr/share/X11/xorg.conf.d/
sudo chmod -x +r /usr/share/X11/xorg.conf.d/*
sudo cp $REPERTOIRE/etc/X11/* /etc/X11/
sudo chmod -x +r /etc/X11/xorg.conf



# Effets personnalisés Roccat
sudo cp $REPERTOIRE/usr/share/roccat/*.lua /usr/share/roccat/ryos_effect_modules/



# Mise en cache RAM des logs Apache
echo "Mise en cache des logs Apache en RAM :"
sudo cp $REPERTOIRE/etc/init.d/* /etc/init.d/
sudo chmod +x /etc/init.d/apache2-tmpfs /etc/init.d/mysql-tmpfs



# Renommer les disques dur
#echo "Renonommage des lecteurs :"
#sudo e2label /dev/sda1 Racine
#sudo jfs_tune -L Racine /dev/sda1
#sudo e2label /dev/sdb1 HOMES
#sudo e2label /dev/sdb2 Donnees
#sudo umount /dev/sdc1
#sudo ntfslabel /dev/sdc1 Sauvegardes
#sudo mount /dev/sdc1
#sudo swapoff -v /dev/sdc2
#sudo mkswap -L "SWAP" /dev/sdc2
#sudo swapon -v /dev/sdc2



# Réduire la possibilité de SWAP
echo "Réduction de la possibilité de swapper :"
sudo cp $REPERTOIRE/etc/sysctl.conf /etc/



## Rajout de points de montages NFS
echo "Rajout des points de montage NFS"
sudo mkdir /media/nfsjeux /media/nfsiso /media/nfslogiciels /media/nfspilotes /media/nfsmusique /media/nfsimages /media/nfsvideos /media/nfsvm /media/nfspersonnalisation
sudo echo -e "\n\n## Montages NFS\n192.168.1.151:/export/Jeux/ /media/nfsjeux                nfs     ro                0       0\n192.168.1.151:/export/Logiciels/ /media/nfslogiciels      nfs     ro                0       0\n192.168.1.151:/export/ISO/ /media/nfsiso                  nfs     ro                0       0\n192.168.1.151:/export/Pilotes/ /media/nfspilotes          nfs     ro                0       0\n192.168.1.151:/export/Musique/ /media/nfsmusique          nfs     ro                0       0\n192.168.1.151:/export/Images/ /media/nfsimages            nfs     ro                0       0
192.168.1.151:/export/Vidéos/ /media/nfsvideos            nfs     ro                0       0\n192.168.1.151:/export/MachinesVirtuelles/ /media/nfsvm    nfs     defaults,user,auto,noatime,intr 0       0\n192.168.1.151:/export/Personnalisation/ /media/nfspersonnalisation nfs ro           0       0\n" >> /etc/fstab
sudo mount -a



# Création du lien symbolique pour VirtualBox
if [ -L "$HOME/VirtualBox VMs" ];
    then
    unlink "$HOME/VirtualBox VMs";
    ln -s /media/nfsvm "$HOME/VirtualBox VMs";
        else
        ln -s /media/nfsvm "$HOME/VirtualBox VMs";
fi

# Divers
echo "Copie des fonds d'écran pour Grub :"
sudo mkdir /boot/grub/splash
sudo cp $FONDSGRUB/* /boot/grub/splash/



echo RESTAURATION DE LA CONFIGURATION TERMINÉE && echo ""
#pause

exit 0