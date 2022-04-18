#!/bin/bash

################# NODE INSTALLATION #############################

node --version
if [ $?==0 ];
  then
          echo node is already installed
 else
     sudo apt install nodejs -y
     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
     export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
     [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
     nvm ls-remote
     echo enter the version to be installed;
     read "version"
     nvm install $version
     node --version
     echo installed node version $version

fi
       
