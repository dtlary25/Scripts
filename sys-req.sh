#!/bin/bash

# Author: Larissa Tamagne
# Date: December 6th, 2021

# The format below is to add multiline comments

<<'Description'
At work, after each linux server installation, i usually had to manually ssh to the server and check that certain parameters meet the requirements for better performance and security. This script is written to avoid repetitive work and to automate the task. The requirements are as follow:
- Check server name and version.
- Hostname should be less than 60 characters.
- Ip address should be 4 octects and valid.
- OS bit version: 64-bit. if so, display architecture.
- Memory should be at least 2 GB.
- cpu should be at least 2 GHz.
- Hard drive should be at least 40 GB.
- the server should contains these files: /etc/protocols, /etc/csh.login and /usr/sbin/ifconfig.
Description

# Defining colors for results output. RED for failure and GREEN for success!

RED="\e[31m"
GREEN="\e[32m"
CLOSE="\e[0m"

# Welcome message

echo""
echo " Welcome! Let's check a few system parameters!"

sleep 4
echo ""

echo "1- Checking server name and version:"
sleep 4
echo "" 

# Pulling server name and version from /etc/os-release
nv=`cat /etc/os-release | grep -i pretty | awk -F'"' '{print $2}'`

echo -e "${GREEN} This is a ${nv} server.${CLOSE}"
sleep 4
echo ""

# Checking Hostname and IP address Requirements

echo "2- Checking Hostname and IP Address:"
sleep 4
echo""

echo " Checking Hostname..."
sleep 4

hn=`hostname` 
hnc=`hostname | wc -c`  

# Hostname should have less than 60 characters. Checking condition.

if [[ $hnc -lt 60 ]]; then
echo " Server hostname \" ${hn} \" has less than 60 characters."
sleep 4
echo -e "${GREEN} Hostname check succeded!${CLOSE}" 
else
echo " Server hostname \" ${hn} \"  has more than 60 characters. Please change your hostname name."
echo -e "${RED} Hostname Check Failed!${CLOSE}"
fi
sleep 4
echo ""

echo " Checking IP address..."
ipa=`ip a | grep inet | grep enp0s3 | awk '{print $2}' | awk -F"/" '{print $1}'`

sleep 4

echo " IP address : ${ipa} "

sleep 4

echo " checking validity ..."

sleep 4

# ip address should follow format a.b.c.d. if statement is to verify that

if [[ $ipa =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
echo -e "${GREEN} Valid IP address!${CLOSE}"
else
echo -e "${RED} Invalid IP address!${CLOSE}"
fi
sleep 4
echo ""

echo "3- Checking system requirements:"
echo""
sleep 4

# Checking windowns bit and architecture
arc=`arch`
bit=`arch | awk -F"_" '{print $2}'`

echo "- Checking system bit and architecture:"
sleep 4

if [[ $bit -eq 64 ]]; then
echo -e "${GREEN} Great! You are running a ${bit}-bit operating system!${CLOSE}"
sleep 4
echo -e "${GREEN} Your system architecture is ${arc}.${CLOSE}"
else
echo -e "${RED} You are running a ${bit}-bit operating system. Please upgrade your system!${CLOSE}"
fi
echo""
sleep 4

# checking Memory size
mem=`free -g | grep -i mem | awk '{print $2}'`
echo "- RAM : ${mem} GB"
sleep 4
if [[ $mem -lt 2 ]]; then
echo -e "${RED} Memory check Failed! Should be at least 2 GB.${CLOSE}"
else 
echo -e "${GREEN} Memory check succeded!${CLOSE}"
fi
echo ""
sleep 4

# checking cpu speed. The below value is in Mgh. Divide by 1000 to find value in Ghz

cpu=`lscpu | grep -i mhz | awk '{print $3}'`
div=1000
cpug=`echo "scale=2;$cpu / $div" | bc -l`

echo "- CPU : ${cpug} GHz"
sleep 4
if (( $(echo "$cpug < 2" | bc -l) )); then
echo -e "${RED} CPU check Failed! Should be at least 2 GHz.${CLOSE}"
else
echo -e "${GREEN} CPU check succeded!${CLOSE} "
fi 
echo ""
sleep 4

# checking hard drive size
hd=`lsblk | grep -w sda | awk '{print $4}' | awk -F'G' '{print $1}'`
echo "- Hard drive size : ${hd} GB"
sleep 4
if [[ $hd -lt 40 ]]; then
echo -e "${RED} Hard Drive check Failed! Should be at least 40 GB.${CLOSE}"
else
echo -e "${GREEN} Hard drive check succeded!${CLOSE}"
fi
echo ""
sleep 4

# checking if files exist

echo "4- Checking files:"
sleep 4
echo""

# First lets see if you are login as root.
echo " Verifying root user privileges..."
echo ""
sleep 4

user=`whoami`
if [[ $user != "root" ]]; then
echo -e "${RED} You are not a root user. You need additional privileges to for this operation. Please login as root to continue.${CLOSE}"
else
echo -e "${GREEN} You are a root user.${CLOSE}"
fi
echo""
sleep 4

echo " Checking files existence..."
echo""
sleep 4

FILE1=/etc/protocols
FILE2=/etc/csh.login
FILE3=/usr/sbin/ifconfig

if [ -f "/etc/protocols" ]; then
echo -e "${GREEN}- File $FILE1 exists.${CLOSE}"
else
echo -e  "${RED}- File $FILE1 does not exist.${CLOSE}"
fi
echo ""
sleep 4

if [ -f "/etc/csh.login" ]; then
echo -e "${GREEN}- File $FILE2 exists.${CLOSE}"  
else
echo -e "${RED}- File $FILE2 does not exist.${CLOSE}"
fi
echo ""
sleep 4

# Trying a different wway to do it!
# Open the file without displaying the content.If it is  positive, file exists.

cat /usr/sbin/ifconfig >/dev/null

if [ $? == 0 ]; then
echo -e "${GREEN}- File $FILE3 exists.${CLOSE}"  
else
echo -e "${RED}- File $FILE3 does not exist.${CLOSE}"
fi
echo ""
sleep 5

echo " System check Completed! Good bye!"
echo""
