#!/usr/bin/env bash

hosts=(IP1 IP2 IP3)
username='user'for host in${hosts[*]}do
  cat $HOME/.ssh/id_rsa.pub | ssh -o "StrictHostKeyChecking no"${user}@${host}'cat >> ~/.ssh/authorized_keys'done
