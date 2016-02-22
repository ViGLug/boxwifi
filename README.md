# boxwifi

**boxwifi** è un Box WiFi che, utilizzando come base un RaspberryPi 2 ed un router WiFi, offre l'accesso ad una rete locale e provvede a servire alcune pagine web e download relativi all'evento in corso.

Non è previsto l'accesso alla rete internet, il box stesso infatti agisce come strumento stand-alone fisicamente scollegato da qualsiasi altra rete e dispone di un server DNS interno che redirige qualsiasi richiesta ad una pagina di landing che rimanda al sito locale.

## Hardware
L'hardware utilizzato comprende

* Un router wifi con OpenWRT installato (un TL-WR841N ad esempio)
* Un RaspberryPi 2
* Una scheda MicroSD (8Gb o superiore, a seconda del volume dei contenuti da pubblicare)

## Software

L'OS utilizzato è [Raspbian 7](https://www.raspberrypi.org/downloads/raspbian/), tutti i passi di installazione presuppongono di partire da una MicroSD appena flashata.
Nella guida si presuppone che la rete utilizzi la classe di IP privati **192.168.1.0/24**, che l'IP del router sia **192.168.1.1** e quello del raspberry **192.168.1.20**.

## Installazione

### Espansione del filesystem

```
sudo raspi-config
```

quindi selezionare l'opzione 1, terminata l'operazione effettuare il reboot.

```
sudo reboot
```

### Update dei pacchetti

```
sudo apt-get update
sudo apt-get upgrade
```

### Update del firmware

```
sudo rpi-update
```

### Installazione dei pacchetti necessari

```
sudo apt-get install apache2 php5 phpmyadmin mysql-server htop bind9
```

### Clonare il repo

```
git clone https://github.com/ViGLug/boxwifi.git
cd boxwifi
```

### Files del sito locale

```
sudo mv landing viglug /var/www
sudo chown -R www-data:www-data /var/www/*
```

E' inoltre necessario popolare il contenuto di ```/var/www/viglug/download/``` con i files mancanti:

* Direcory ```iso/```: con le ISO delle distribuzioni
* Direcory ```libri/```: con il contenuto dell'archivio recuperabile su https://mega.nz/#!DMEnUTDR!5BFZcvD6wnAEbucrEQtXa4M5n6CgauMbiZ8hnQbL9QM
* Direcory ```musica/```: con la top 50 di [Jamendo](https://www.jamendo.com/charts)
* Direcory ```video/```: con il contenuto dell'archivio recuperabile su https://mega.nz/#!XVFz2IiT!B348JlXSlKbaVZq3hqEt5_HHdKzTTK-2pM8KaAn7-2Q

### Configurazione del webserver

Upload dei certificati SSL in ```/etc/apache2/certs/```, i file richiesti sono:

```
/etc/apache2/certs/viglug.crt
/etc/apache2/certs/viglug.key
/etc/apache2/certs/tls-chain.crt
```

Configurazione di vhosts:

```
sudo mv -f apache/* /etc/apache2/sitest-available/
sudo chown root:root /etc/apache2/sitest-available/*
sudo a2ensite default
sudo a2ensite default-ssl
sudo a2ensite viglug
sudo a2ensite viglug-ssl
sudo service apache2 restart
```

### Configurazione del database

Creiamo un database ed un'utenza ed andiamo ad editare il file di configurazione:

```
sudo nano /var/www/viglug/config.inc.php
```

Carichiamo quindi lo schema del database:

```
mysql -uroot -p viglug < mysql/schema.sql
```

### Configurazione di BIND

```
sudo echo "zone "." {" >> /etc/bind/named.conf
sudo echo "    type master;" >> /etc/bind/named.conf
sudo echo "    file "/etc/bind/db.fakeroot";" >> /etc/bind/named.conf
sudo echo "};" >> /etc/bind/named.conf
sudo echo "@ IN SOA ns.viglug.org. hostmaster.viglug.org. ( 1 3h 1h 1w 1d )" > /etc/binf/db.fakeroot
sudo echo "  IN NS 192.168.1.20" >> /etc/binf/db.fakeroot
sudo echo "* IN A 192.168.1.20" >> /etc/binf/db.fakeroot
sudo service bind9 restart
```

### Configurazione di iptables

Attivare iptables:

```
sudo modprobe ip_tables
sudo echo "ip_tables" >> /etc/modules
```

Attivare ip_forward:

```
sudo nano /etc/sysctl.conf

net.ipv4.ip_forward = 1
```

Configurazione del firewall:

```
sudo iptables -t nat -A PREROUTING -i eth0 -p udp --dport 53 -j DNAT --to 192.168.1.20
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 53 -j DNAT --to 192.168.1.20
sudo iptables-save > /etc/iptables
sudo echo "iptables-restore < /etc/iptables" >> /etc/rc.local
```

### Configurazone del DHCP del router

Per fare si che il Raspberry venga impostato come default gateway è necessario un workaround sulla configurazione del DHCP:

```
LuCi > Network > Interface > LAN - Edit > DHCP Server - Advanced Settings > DHCP-Options
```

ed inserire la stringa:

```
3,192.168.1.20 6,192.168.1.20
```
