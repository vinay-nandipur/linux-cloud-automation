#!/usr/bin/env bash

#note: key based ssh authentication should be enabled to avoid entering password repeatedly.
#https://kb.vmware.com/s/article/1002866

#In below example, upgrading ESXI from 6.0 to 6.5.

printf "Enter FQDN or IP of ESXI Host:\t"

read esxi_fqdn_or_ip

printf "Enter offline bundle location:\t"

read offline_bundle_path

printf "Enter private key location:\t"

read private_key_file

ssh -i $private_key_file -l root $esxi_fqdn_or_ip "vim-cmd /hostsvc/maintenance_mode_enter"

ssh -i $private_key_file -l root $esxi_fqdn_or_ip "esxcli software vib update -d $offline_bundle_path"

ssh -i $private_key_file -l root $esxi_fqdn_or_ip "esxcli system shutdown reboot --reason=esxi_upgraded"

sleep 1000

ssh -i $private_key_file -l root $esxi_fqdn_or_ip "vim-cmd /hostsvc/maintenance_mode_exit"
