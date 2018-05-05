#!/usr/bin/env bash

#============================================================================
# DESCRIPTION
#
# 	This shell script is meant to prepare a fresh Ubuntu Gnome 16.04 desktop 
#	installation for development -- with a focus on python and web 
#	development in general. It is obviously highly opinionated.
#
# METADATA
#
#	- version		0.0.1
#	- author		Victor Miti
#	- licence		MIT
#
# HISTORY
#
#	2018-May-05		Initial Creation Date
#
# TODO
#
#	- Have one script to use either on a headless server or Desktop Setup
#
#============================================================================


## 1. Update and upgrade the system
sudo apt-get update
sudo apt-get -y upgrade

## 2. Customize some things
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
echo -e "\n\nCustomize your Shell: Use Color, Change Color Scheme\n\n"

## 3. Setup Python and other prerequisites
sudo apt-get install git autoconf bison build-essential libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev zlib1g-dev libssl-dev libffi-dev python-dev python3-dev python-software-properties libncurses5-dev libgdbm3 libgdbm-dev python-gi python3-gi python-gi-cairo python3-gi-cairo gir1.2-gtk-3.0 gir1.2-poppler-0.18 tidy shellcheck ffmpeg
sudo apt-get install -y python-pip python3-pip pylint

sudo -H pip2 install --upgrade pip
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv virtualenvwrapper jedi pep8 autopep8 flake8 pycodestyle uwsgi
sudo -H pip2 install virtualenv virtualenvwrapper jedi pep8 autopep8 flake8 pycodestyle

export WORKON_HOME=~/.virtualenvs
mkdir -p $WORKON_HOME

echo -e "\n\n\n# virtualenvwrapper setup" >> $HOME/.bashrc
echo "export WORKON_HOME=~/.virtualenvs" >> $HOME/.bashrc
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> $HOME/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> $HOME/.bashrc
source $HOME/.bashrc

## 4. Text Editors

### sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text
echo -e "\n\n\nLaunch Sublime Text and install the appropriate packages.\n\n"

#### sublime-text essential packages (after installing Package Control)
# anaconda
# alignment
# asciidoctor (after installing ruby)
# Bootstrap 3 Snippets
# Color Highlighter
# ColorPicker
# Djaneiro
# DocBlockr
# DocBlockr Python
# Emmet
# ExportHtml
# Generic Config
# Git
# GitGutter
# HTML Mustache
# HTML-CSS-JS-Prettify
# Jedi - Python autocompletion
# LogView
# Markdown Extended
# Markdown Preview
# Monokai Extended
# nginx
# Nginx Log Highlighter
# Python Improved
# Random Everything
# RegReplace
# requirements.txt
# RestructuredText Improved
# Neon Color Scheme
# Sass
# SidebarEnhancements
# SublimeCodeIntel
# SublimeLinter
# SublimeLinter-csslint
# SublimeLinter-flake8
# SublimeLinter-html-tidy
# SublimeLinter-jshint
# SublimeLinter-json
# SublimeLinter-pep8
# SublimeLinter-pylint
# SublimeLinter-rst
# Trimmer


### vim (Janus Distribution, whose dependency is Ruby)

sudo -H pip2 install powerline-status
sudo -H pip3 install powerline-status

if [ $(dpkg-query -W -f='${Status}' vim 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install vim;
fi

if [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install curl libcurl4-openssl-dev;
fi

sudo apt-get install vim-gnome vim-nox vim-nox-py2

# https://github.com/powerline/fonts
# sudo apt-get install fonts-powerline
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -vrf fonts

# https://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
sudo mv PowerlineSymbols.otf /usr/share/fonts/
sudo fc-cache -vf
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

echo -e "\n\n\nRemember to set your SHELL to use the font *inconsolata for powerline*, the font size must be set to 17.\n\n"

# Janus requires ack, ctags, git, ruby and rake
sudo apt-get install ack-grep exuberant-ctags

cd
git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.5.1
rbenv global 2.5.1

curl -L https://bit.ly/janus-bootstrap | bash

wget -O $HOME/.vimrc.after https://raw.githubusercontent.com/engineervix/vim-configs/master/ubuntu_desktop/.vimrc.after
wget -O $HOME/.gvimrc.after https://raw.githubusercontent.com/engineervix/vim-configs/master/ubuntu_desktop/.gvimrc.after

mkdir $HOME/.janus
git clone https://github.com/zeis/vim-kolor.git $HOME/.janus/vim-kolor
git clone https://github.com/chr4/jellygrass.vim.git $HOME/.janus/jellygrass.vim


## 5. Node JS

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# To install the Yarn package manager, run:
#     curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
#     sudo apt-get update && sudo apt-get install yarn

sudo npm install -g grunt-cli grunt-init bower jshint jsonlint csslint eslint uglify-js yo


## 6. Web Browser -- Google Chrome

sudo cp /etc/apt/sources.list /etc/apt/sources.list_$(date --iso).bak
echo -e "\n\ndeb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list
wget https://dl.google.com/linux/linux_signing_key.pub
sudo apt-key add linux_signing_key.pub
sudo apt update
sudo apt install google-chrome-stable

# You may see the following warning message when issuing sudo apt update command.
# Target Packages (main/binary-amd64/Packages) is configured multiple times
# That’s because the Google Chrome package created an APT line in file /etc/apt/sources.list.d/google-chrome.list. You can remove the warning message by deleting that file.
# sudo rm /etc/apt/sources.list.d/google-chrome.list


## 7. Important CLI Tools

sudo apt-get install pdftk imagemagick


## 8. Postgres / PostGIS

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04
# https://github.com/wanjohikibui/Geodjango-series

sudo apt-get install postgresql postgresql-contrib postgis
sudo -u postgres createuser --interactive
LOCALUSER="$(whoami)"
sudo -u postgres createdb $LOCALUSER

## 9. LEMP

# See https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04 for more details


sudo apt-get install nginx
# sudo ufw allow 'Nginx HTTP'
sudo apt-get install mysql-server
mysql_secure_installation
sudo apt-get install php-fpm php-mysql

echo -e "\n\nFollow the instructions at https://is.gd/odequj to finish the setup...\n\n"


## 10. Important GUI Tools

sudo apt-get install filezilla inkscape gimp scribus pdfsam pdfshuffler pdfmod


## 11. Media Players

sudo apt-get install clementine vlc smplayer

# 12. Others

sudo apt-get install vokoscreen virtualbox audacity zeal

# 13. TeX Live Full

# sudo apt-get install texlive-full
