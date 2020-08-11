#! /bin/sh

currentDirectory=$(pwd)

format_output () {
    local yellow="\033[1;33m"
    local no_color="\033[0m"

    case $1 in
        yellow)
            printf "${yellow}${2}\n"
            ;;
        *)
            printf "Unsupported color.\n"    
            ;;
    esac
}

# input processors
read_command () {
    printf "Which of the following do you want to update, ${USER^}?\n"
    printf "[L]inux [G]lobalNPMPackages [O]hMyZsh [A]ll [E]xit \n\n"

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
            update_linux
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
            update_linux
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
update_linux () {
    printf "==> Updating Linux\n"
    yay -Syu --noconfirm
    format_output "yellow" "The system now up to date!"
}
update_npm_global_packages () {
    printf "==> Updating your NPM global packages...\n"
    npm update -g
    format_output "yellow" "Packages updated!"
}
update_oh_my_zsh () {
    printf "==> Updating Oh My Zsh\n"
    cd ~/.oh-my-zsh
    git pull --ff-only
    cd $currentDirectory
    format_output "yellow" "Oh My Zsh has been fast-forwarded to the latest commit!"
}
update_everything () {
    printf "==> Updating entire system\n"

    update_linux
    update_npm_global_packages
    update_oh_my_zsh
    
    format_output "yellow" "The entire system is up-to-date!"
}
update_nothing () {
    printf "Bye bye!\n"
    exit 1
}
update_not_sure () {
    printf "Ummm... okay, let's do this again.\n"
    read_command
}

# main
read_command
