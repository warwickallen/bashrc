#!/bin/bash -xe

INSTALL_DIR=/opt/install

if $(sudo -v)
then

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get -y install curl
    
    sudo mkdir -vp $INSTALL_DIR
    pushd $INSTALL_DIR
    
    
    ## KEYS
    
    # Dropbox
    dropbox_key_id=5044912E
    if ! (apt-key list | grep -B1 Dropbox | grep -qP '\b'$dropbox_key_id'\b')
    then
        sudo apt-key adv --keyserver pgp.mit.edu --recv-keys $dropbox_key_id
    fi
    
    # Yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |
    sudo apt-key add -
    
    
    ## REPOS
    
    while read ppa
    do
        sudo add-apt-repository "$ppa"
    done <<REPOS
        deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main
        deb http://ppa.launchpad.net/mmk2410/intellij-idea/ubuntu $(lsb_release -sc) main 
        deb https://dl.yarnpkg.com/debian stable main
        ppa:rael-gc/scudcloud
        ppa:teejee2008/ppa
REPOS
    
    # ScudCloud (Slack client)
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true |
    sudo debconf-set-selections
    
    
    ## UPDATE & INSTALL
    
    sudo apt-get update
    sudo apt dist-upgrade -y
    
    sudo apt-get install -y --allow-unauthenticated \
        build-essential         \
        vim                     \
        tmux                    \
        xterm                   \
        git                     \
        python                  \
        yarn                    \
        firefox                 \
        chromium-browser        \
        keepass2                \
        kpcli                   \
        gpgv2                   \
        kgpg                    \
        signing-party           \
        maven                   \
        dropbox                 \
        intellij-idea-community \
        scudcloud               \
        openssh-server          \
        libpam-google-authenticator \
        ssvnc                   \
        xpra                    \
        clipit                  \
        indicator-diskman       \
        arandr                  \
    ;
    
    
    ## NON-PPA INSTALLS
    
    # Keybase
    if ! [ -e keybase_amd64.deb ]
    then
        (
            sudo curl -O https://prerelease.keybase.io/keybase_amd64.deb |
            sudo dpkg -i keybase_amd64.deb
            sudo apt-get install -yf
            run_keybase
        ) || echo "Could not install Keybase: $!"
    fi
    
    # Update CPAN
    for pkg in Log::Log4perl YAML CPAN
    do
        PERL_MM_USE_DEFAULT=1 sudo cpan $pkg
    done
    
    # Clean up
    sudo apt autoremove -y

    popd
fi


## PERSONALISE

function git-clone-pull
{
    if ! [ -e "$2" ]
    then
        git clone "$1" "$2"
    fi
    cd "$2"
    git checkout master
    git pull
}

pushd ~
if [ -e .bashrc ]
then
    mv .bashrc .bashrc.$(date +%s)
fi
git-clone-pull https://github.com/warwickallen/bashrc.git bashrc
. provision.sh
popd
