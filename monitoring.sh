#!/bin/bash
arch=$(uname -srvmo)
pcpu=$(grep 'physical id' /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep ^processor /proc/cpuinfo | sort | uniq | wc -l)
ram=$(free -m | grep Mem | awk '{print $2}')
uram=$(free -m | grep Mem | awk '{print $3}')
pram=$(free -m | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
disk=$(df -h --total | grep total | awk '{print $2}')
udisk=$(df -h --total | grep total | awk '{print $3}' | tr -d 'G')
pdisk=$(df -h --total | grep total | awk '{print $5}')
cpul=$(top -bn1 | grep ^%Cpu | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
tboot=$(who -b | awk '{print($3" "$4)}')
lvm=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
conn=$(grep TCP /proc/net/sockstat | awk '{print $3}')
usern=$(who | wc -l)
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | grep link/ether | awk '{print $2}')
cmdsu=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)
wall "  #Architecture: $arch
        #CPU physical: $pcpu
        #vCPU: $vcpu
        #Memory Usage: $uram/${ram}MB ($pram)
        #Disk Usage: $udisk/${disk}b ($pdisk)
        #CPU load: $cpul
        #Last boot: $tboot
        #LVM use: $lvm
        #Connections TCP: $conn ESTABLISHED
        #User log: $usern
        #Network: $ip ($mac)
        #Sudo: $cmdsu cmd"
