#!/usr/bin/env bash
su ec2-user

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

sudo apt update
sudo apt upgrade -y
sudo apt install unzip -y

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
