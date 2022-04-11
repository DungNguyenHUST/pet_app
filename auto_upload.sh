#!/bin/bash

local_path=/home/dungnguyen/pet_app/tmp/jobs/
remote_path=/home/deploy/pet_app/releases/20220330103906/tmp/
sftp -v -oIdentityFile=~/.ssh/id_rsa deploy@206.189.146.104 <<EOF
put -rf $local_path $remote_path
EOF