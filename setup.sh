#!/bin/bash

#Check if root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Disable auto upgrades..."
cat << EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOF

echo "Installing prerequisite packages..."
apt install libpcap-dev libusb-1.0-0-dev libnetfilter-queue-dev libbluetooth-dev libncurses5-dev python-pip libglib2.0-dev git bluez

echo "Installing Bettercap..."
wget -P /tmp https://github.com/bettercap/bettercap/releases/download/v2.31.1/bettercap_linux_amd64_v2.31.1.zip
unzip /tmp/bettercap_linux_amd64_v2.31.1.zip -d /tmp
mv /tmp/bettercap /usr/local/bin/

echo "Installing Spooftooph..."
rm -rf spooftooph
git clone https://gitlab.com/kalilinux/packages/spooftooph.git

cat << 'EOF' > spooftooph/makefile
CC = gcc
BT_LIB = -lbluetooth
NCURSES_LIB = -lncurses
PTHREAD = -pthread
BIN = /usr/bin

all: spooftooph

spooftooph:
	$(CC) dev_class.c namelist.c spooftooph.c bdaddr.c oui.c $(BT_LIB) $(NCURSES_LIB) $(PTHREAD) -o spooftooph

install:
	cp spooftooph $(BIN)

uninstall:
	rm -i $(BIN)/spooftooph

clean:
	rm spooftooph
EOF

cd spooftooph && make && make install && make clean && cd ..

echo "Installing Insignia bluetooth drivers..."
wget https://github.com/winterheart/broadcom-bt-firmware/releases/download/v12.0.1.1105_p3/broadcom-bt-firmware-10.1.0.1115.deb
dpkg -i broadcom-bt-firmware-10.1.0.1115.deb

echo "Installing bleah..."
pip install -U pip setuptools
git clone https://github.com/IanHarvey/bluepy.git && cd bluepy && python setup.py build && sudo python setup.py install && cd ..
git clone https://github.com/evilsocket/bleah.git && cd bleah && git checkout 6a2fd3a && python2 setup.py build && python2 setup.py install

# Still have change 'queue' to 'Queue'

echo "Done."
