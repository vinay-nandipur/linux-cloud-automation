#!/usr/bin/env bash

Help()
{
   # Display Help
   echo "You can encrypt/decrypt a file using this script."
   echo
   echo "Syntax: sh script_name [-h|-e|-d]"
   echo "options:"
   echo "h     Print this Help."
   echo "e     Encrypt File."
   echo "d     Decrypt File."
   echo
}

Encrypt()
{
  printf "Enter the absolute path of file to encrypt: \t"
  read filename_to_encrypt

  printf "Encrypting File.."
  openssl aes256 -in $filename_to_encrypt -out $filename_to_encrypt-encrypted
}

Decrypt()
{
  printf "Enter the absolute path of file to decrypt: \t"
  read filename_to_decrypt

  openssl aes256 -d -in $filename_to_decrypt -out $filename_to_decrypt-decrypted
}

while getopts ":h|:e|:d" option; do
  case $option in
    h) # display Help
       Help
       exit;;

    e) # encrypt file
       Encrypt
       exit;;

    d) # decrypt file
       Decrypt
       exit;;

    \?) # incorrect option
        echo "Error: Invalid option"
        exit;;
  esac
done
