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
    printf "GNU/[L]inux [N]ode.js [G]lobalNPMPackages [O]hMyZsh [A]ll [E]xit\n\n"
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
    paru -Syu --noconfirm
    format_output "yellow" "Your GNU/Linux system and packages are now up to date!"
}
update_node () {
    if [ -d /usr/share/nvm/ ]; then
        . /usr/share/nvm/nvm.sh
        local old_version=$(nvm current | sed -n -e 's/v//p')

        printf "==> Installing the latest version of Node.js\n"
        format_output "red" "WARNING: This will uninstall Node ${old_version} but keep your global NPM packages."
        format_output "red" "WARNING: This also installs the a non-LTS version of Node.js.\n"

        nvm install node
        nvm alias default node
        nvm reinstall-packages $old_version
        nvm uninstall $old_version
        nvm use default
    else
        format_output "red" "Missing package: NVM\n"
        read_command
    fi
    format_output "red" "WARNING: Node.js version ${old_version} was uninstalled!"
    format_output "yellow" "The latest version of Node.js was installed!"
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
update_everything () {
    format_output "yellow" "==> Updating entire system"

    update_gnulinux
    printf "\n"
    update_node
    printf "\n"
    update_npm_global_packages
    printf "\n"
    update_oh_my_zsh
    
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
