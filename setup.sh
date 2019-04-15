#!/bin/sh

GREEN='\033[1;32m'
NC='\033[0m'
USER=$(whoami)

printf "${GREEN}Hello ${USER}! Are you ready to setup this Mac? (y/N): ${NC}"
read MENU_CHOICE

if [ "${MENU_CHOICE}" != "y" ]; then
  echo "Apparently not."
  exit 1
fi

echo "Installing XCode CLI things"
xcode-select --install

echo 'Installing Antigen...'
git clone https://github.com/zsh-users/antigen.git ~/.antigen

# todo: setup dotfiles

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew...\n"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew is already installed\n"
fi

# Install brews
BREWFILEDIR='brew'
BREWFILES=$(ls ${BREWFILEDIR})
for BREWFILE in $BREWFILES; do
  printf "${GREEN}Install brews from ${BREWFILE}? (y/N): ${NC}"
  read MENU_CHOICE

  if [ "${MENU_CHOICE}" == "y" ]; then
    while IFS='' read -r line || [[ -n "${line}" ]]; do
      brew ${line}
    done <"${BREWFILEDIR}/${BREWFILE}"
  else
    echo "Skipping brews from ${BREWFILE}"
  fi
done

echo 'Installing global ruby gems...'
sudo gem install lolcat

echo 'Installing cheat.sh cli client...'
curl https://cht.sh/:cht.sh | tee /usr/local/bin/cht.sh
chmod a+x /usr/local/bin/cht.sh

echo 'Configuring OS X...'
./osx/settings.sh
