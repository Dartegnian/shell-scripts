# Other functions
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

# Text echoers
echo_starting_text () {
    echo "
██████╗  ██████╗
██╔══██╗██╔════╝
██████╔╝██║     
██╔══██╗██║     
██║  ██║╚██████╗
╚═╝  ╚═╝ ╚═════╝
███╗   ███╗██╗███╗   ██╗███████╗ ██████╗██████╗  █████╗ ███████╗████████╗
████╗ ████║██║████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
██╔████╔██║██║██╔██╗ ██║█████╗  ██║     ██████╔╝███████║█████╗     ██║   
██║╚██╔╝██║██║██║╚██╗██║██╔══╝  ██║     ██╔══██╗██╔══██║██╔══╝     ██║   
██║ ╚═╝ ██║██║██║ ╚████║███████╗╚██████╗██║  ██║██║  ██║██║        ██║   
╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝"
}
echo_ending_text () {
    sleep 3
	format_output "yellow" "==> Stopped RC Real Creative Minecraft server"
    echo "
███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ 
██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
                                                 
██╗  ██╗ █████╗ ██╗  ████████╗███████╗██████╗ 
██║  ██║██╔══██╗██║  ╚══██╔══╝██╔════╝██╔══██╗
███████║███████║██║     ██║   █████╗  ██║  ██║
██╔══██║██╔══██║██║     ██║   ██╔══╝  ██║  ██║
██║  ██║██║  ██║███████╗██║   ███████╗██████╔╝
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝   ╚══════╝╚═════╝"
}


start_server () {
    sleep 1
	format_output "yellow" "==> Starting RC Real Creative Minecraft server"
    echo "Changing directory to /srv/rc-minecraft"
	start_mc_server
}
start_mc_server () {
    cd /srv/rc-minecraft
    local init_memory_size="1024M"
    local max_memory_size="1792M"
    local minecraft_jar_name="rc-server"
    local world_size=$(grep max-world-size server.properties | grep -oP "[^max\-world\-size=].*")
    echo "Starting the server with these variables"
    echo "Initial RAM size: $init_memory_size"
    echo "Maximum RAM size: $max_memory_size"
    echo "Minecraft JAR file name: $minecraft_jar_name.jar"
    # echo "World size: $(expr ${world_size} * 2)"
    echo_starting_text
    sleep 3
    java -Xms$init_memory_size -Xmx$max_memory_size -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar /srv/rc-minecraft/rc-server.jar nogui
}
start_server_loopback () {
    start_server
    echo "Minecraft has finished saving the server data"
    echo_ending_text
    start_server_loopback
}

format_output "yellow" "==> Checking if user 'rc' is being used..."
echo "Note: Do NOT run the server as root or as another user"
echo "Note: Also make sure that no other instances are running"
sleep 3
if [ $USER == "rc" ]; then
    echo "User 'rc' is being used! Proceeding to the next steps."
    if [ $1 == "start" ]; then
        start_server_loopback
    else
        killall -q java
        echo_ending_text
    fi
else
	format_output "red" "User 'rc' is NOT being used!"
	format_output "red" "Aborting process"
    format_output "red" "Please retype the command as the user 'rc' next time"
fi
