#! /bin/sh

format_output () {
    local red="\033[0;31m"
    local yellow="\033[1;33m"
    local no_color="\033[0m"

    case $1 in
        red)
            printf "${red}${2}${no_color}\n"
            ;;
        yellow)
            printf "${yellow}${2}${no_color}\n"
            ;;
        *)
            printf "Unsupported color.\n"    
            ;;
    esac
}

# input processors
print_greeting () {
    printf "Which of the following do you want to update, ${USER^}?\n"
    printf "Hint: Either type the highlighted letters below or the words themselves.\n"
    printf "GNU/[L]inux [N]ode.js [G]lobalNPMPackages [O]hMyZsh [T]KG T[M]ux [A]ll (except TKG) [E]xit\n\n"
}
read_command () {
    read -p "Update: " update_choice
    printf "\n"
    distinguish_command "$update_choice"
}
distinguish_command() {
    local update_choice_length=${#1}

    if [ $update_choice_length == "1" ]; then
        process_short_command "${1,,}"
    else
        process_long_command "${1,,}"
    fi
}
process_short_command () {
    case $1 in
        l)
            update_gnulinux
            ;;
        n)
            update_node
            ;;
        g)
            update_npm_global_packages
            ;;
        o)
            update_oh_my_zsh
            ;;
        t)
            update_tkg
            ;;
        m)
            update_tmux
            ;;
        a)
            update_everything
            ;;
        e)
            update_nothing
            ;;
        *)
            update_not_sure
            ;;
    esac
}
process_long_command () {
    case $1 in
        linux)
            update_gnulinux
            ;;
        node)
            update_node
            ;;
        nodejs)
            update_node
            ;;
        node.js)
            update_node
            ;;
        npmglobalpackages)
            update_npm_global_packages
            ;;
        ohmyzsh)
            update_oh_my_zsh
            ;;
        tkg)
            update_tkg
            ;;
        tmux)
            update_tmux
            ;;
        all)
            update_everything
            ;;
        exit)
            update_nothing
            ;;
        *)
            update_not_sure
            ;;
    esac
}

# updaters
update_gnulinux () {
    printf "==> Updating GNU/Linux and your packages\n"
    
    if [ -n $(where paru) ]; then
	    paru -Syu --noconfirm
    elif [ -n $(where yay) ]; then
	    yay -Syu --noconfirm
    else
	    sudo pacman -Syu --noconfirm
    fi

    printf "==> Attempting to remove unused pacman packages\n"
    if [ -z $(sudo pacman -Qtdq | tail -n 1) ]; then
        format_output "yellow" "No unused packages were found"
    else
        printf "==> Removing unused packages\n"
        sudo pacman -Qtdq | sudo pacman --noconfirm -Rns -
        format_output "yellow" "Unused packages were removed."
    fi
    format_output "yellow" "Your GNU/Linux system and packages are now up to date!"
}
update_node () {
    if [ -d /usr/share/nvm/ ]; then
        printf "==> Updating Node and NPM\n"
        . /usr/share/nvm/nvm.sh
        local old_version=$(nvm current | sed -n -e 's/v//p')
        local versions=$(nvm ls-remote)
        wait
        local latest_version=$(echo $versions | sed  -e 's/\s\+/\n/g' | tail -n 1 | grep -P -o "\d*\.\d*\.\d*")

        if [ $old_version == $latest_version ]; then
            format_output "yellow" "Your local version of Node.js is already up to date!"
        else
            format_output "red" "Your local version of Node.js is outdated."
            printf "==> Installing the latest version of Node.js\n"
            format_output "red" "WARNING: This will uninstall Node ${old_version} but keep your global NPM packages."
            format_output "red" "WARNING: This also installs the a non-LTS version of Node.js.\n"
            nvm install node
            nvm alias default node
            nvm reinstall-packages $old_version
            nvm uninstall $old_version
            nvm use default
            format_output "red" "WARNING: Node.js v${old_version} was uninstalled!"
            format_output "yellow" "The Node.js v${latest_version} was installed!"
        fi
    else
        format_output "red" "Missing package: NVM\n"
        read_command
    fi
}
update_npm_global_packages () {
    printf "==> Updating your NPM global packages\n"
    npm update -g
    format_output "yellow" "Packages updated!"
}
update_oh_my_zsh () {
    local current_directory=$(pwd)
    printf "==> Updating Oh My Zsh\n"
    cd $XDG_DATA_HOME/oh-my-zsh
    git pull --ff-only
    cd $current_directory
    format_output "yellow" "Oh My Zsh has been fast-forwarded to the latest commit!"
}
update_tkg () {
    local current_directory=$(pwd)
    printf "==> Updating/Installing TKG Proton and Wine\n"
    tkg_github_repo="Frogging-Family/wine-tkg-git"
    tkg_proton_download_link=$(curl -s https://api.github.com/repos/${tkg_github_repo}/releases/latest | grep -P -o https\:\/\/.*\.release\.zip | head -n 1)
    tkg_wine_download_link=$(curl -s https://api.github.com/repos/${tkg_github_repo}/releases/latest | grep -P -o https\:\/\/.\*\.zst | head -n 1)

    if [ -d "/tmp/tkg" ]; then
        cd /tmp/tkg
    else
        mkdir /tmp/tkg && cd /tmp/tkg
    fi

    install_tkg_proton $tkg_proton_download_link
    install_tkg_wine $tkg_wine_download_link

    rm -rf /tmp/tkg
    cd $current_directory
}
install_tkg_proton () {
    curl -L -o proton-tkg.zip $1
    mkdir Proton-TKG && mv proton-tkg.zip ./Proton-TKG && cd Proton-TKG
    unzip proton-tkg.zip && rm proton-tkg.zip && cd ../
    rm -rf ~/.steam/root/compatibilitytools.d/Proton-TKG
    mv Proton-TKG ~/.steam/root/compatibilitytools.d/
}
install_tkg_wine () {
    curl -L -o wine-tkg.zst $1
    sudo pacman -U wine-tkg.zst
}
update_tmux () {
    printf "==> Updating Tmux plugins via TPM\n"
    if [ -d ~/.tmux/plugins/tpm/bin/ ]; then
        sh ~/.tmux/plugins/tpm/bin/update_plugins all
        format_output "yellow" "Your Tmux plugins are now up to date!"
    else
        format_output "red" "Tmux Plugin Manager not found\n"
    fi
}
update_everything () {
    format_output "yellow" "==> Updating entire system"

    update_gnulinux
    printf "\n"
    update_node
    printf "\n"
    update_npm_global_packages
    printf "\n"
    update_oh_my_zsh
    printf "\n"
    update_tmux
    
    format_output "yellow" "\nThe entire system is up-to-date!"
}
update_nothing () {
    printf "Cancelling update process.\n"
    printf "No changes to the system was made.\n"
    exit 1
}
update_not_sure () {
    printf "Ummm... okay, let's do this again.\n"
    print_greeting
    read_command
}

# main
print_greeting
read_command
