#!/bin/bash

# this script should run as root

apt-get update && apt-get -y upgrade
apt-get install -y build-essential make zlib1g-dev librrd-dev libpcap-dev autoconf libarchive-dev iperf3 htop bmon vim wget pkg-config git python-dev python-pip libtool

######################
### EDIT /etc/hosts ##
######################

#cat << EOF >> /etc/hosts
#EOF


############################
### INSTALL APACHE2     ####
############################
apt-get install -y apache2
a2enmod userdir


############################
### INSTALL TSTAT       ####
############################

cd
wget http://www.tstat.polito.it/download/tstat-3.1.1.tar.gz
tar -xzvf tstat-3.1.1.tar.gz
cd tstat-3.1.1
./autogen.sh
./configure --enable-libtstat --enable-zlib
make && make install

############################
### SETUP PANORAMA USER ####
############################
cd
useradd -s /bin/bash -d /home/panorama -m panorama

echo "panorama     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

mkdir /home/panorama/.ssh
chmod -R 700 /home/panorama/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMnR9XlDv/NiEyKPgMzO/WOcQ9ZoDt2BYC7CHB9EmJQG4dwtzhioLJspJ8t4IuHpw6JlxjybTYqVUJqbKKT56t7PdFrzy7R5D5MO31CcAMhzaaFL7mtviIj+jy4wEitZr5Jh7SGgPFTLA54cx3fHCsrs0I0PjSRcaKtEi0RK0HsmUNrh5cRFm1oOgShkthM9KMfZAJ2hhkaoneywGfBvfq3dOQkfFdTCxn3B+Sc28l6wtT+n9ruNhasQ3OqmkZ5lhg+/CH5zTd7dCy57Fd/BuFEUq3pdhLIXXhnxDTftn1Nwd6FLy865XlIMnSSt8ds/X3sndupkA7G5f6ZyDKZinJRjr+pGrKC5lly1L3sw/oPguQDfHJ7VJI/jVWP4A4Xp0etXw50pF0GgA9+UT84tBfe3LB4cMhdJ/UWrEgK/jjCtSIe9bahT4gCL2PIbIacOXFqla3DiEcw/ZcCr8hprFLey04BgDvbMN1x+AydXvLjl4eDar5/ey1AlLzaNLXobEdK17DMsG6I3spJFJ/MB18vEu+F4QpTh9A4btX81XFWssdXhynVrrSbMgepQQAYoa92VVAD/re9PgwMXDHaERJW190SyV+ruv0R9FEmp9izWN44tx8E6hyo/eHZ7H65DlBilRQBehsefN7dY0BApLAxmpRkuwa0c1XE0UkEkZQOw== georgpap@iris.isi.edu" > /home/panorama/.ssh/authorized_keys
chmod 600 /home/panorama/.ssh/authorized_keys
chown -R panorama:panorama /home/panorama/.ssh


#### Add http userdir for user panorama #####
mkdir /home/panorama/public_html
chmod -R 755 /home/panorama/public_html
chown -R panorama:panorama /home/panorama/public_html
sed -i 's/.*UserDir disabled.*/\tUserDir disabled root\n\tUserDir enabled panorama/g' /etc/apache2/mods-available/userdir.conf

systemctl restart apache2
