#!/bin/bash

local_path=$HOME/pet_app/tmp/jobs/
remote_path=/home/deploy/pet_app/current/tmp/
sftp -v -oIdentityFile=~/.ssh/id_rsa deploy@206.189.146.104 <<EOF
put -rf $local_path $remote_path
EOF