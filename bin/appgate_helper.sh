#!/usr/bin/env bash
#
# other potentials names:
#    - appgated
#    - ag-helper
#    - appgate-mngr
#    - appgate-mgr
#    - appgate-mgmt
#    - appgate-ctl
#    - apgtsdpctl
#    - appctl
#    - appgater

# https://sdphelp.cyxtera.com/adminguide/v4.2/macos-client.html
# https://sdphelp.cyxtera.com/userguide/v4.2/advanced/macos/index.html
# https://sdpdownloads.cyxtera.com/files/download/AppGate-11.3-LTS/doc/manual_chunked_html/

# https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
# https://stackoverflow.com/questions/7568112/split-large-string-into-substrings
# https://ilostmynotes.blogspot.com/2011/09/reading-and-modifying-os-x-plist-files.html

# plist editors:
# - /usr/bin/defaults
# - /usr/bin/plutil
# - /usr/libexec/PlistBuddy

# SKIP the Data Usage User Approval screen:
# ```  
# $ defaults write com.cyxtera.appgate.sdp.service user_approval -bool YES
# ```

# SET the Controller URL: 
# ```  
# $ defaults write com.cyxtera.appgate.sdp.service controller_url <your_controller_url>
# ```
# Note: the controller url has to be prefixed with either "https://" or "appgate://" 
# e.g.:
# https://appgate.company.com appgate://appgate.company.com

# SET the Identity Provider: 
# ```  
# $ defaults write com.cyxtera.appgate.sdp.service preferred_provider “myIdP_name” 
# ```
# Note: quotes should be used

# LOGS
# ~/.appgatesdp/log/log.log
# - client
# /var/log/appgate/tun-service.log
# - tunnel service

# MANUAL UNINSTALL
# ```
# sudo /Library/Application\ Support/AppGate/interactive-uninstall
# ```

# CLEAN ALL CLIENT SETTINGS
# ```
# rm -f ~/Library/Preferences/com.cyxtera.appgate.sdp.service.plist
# rm -f ~/Library/Preferences/com.cyxtera.appgate.sdp.helper.plist
# rm -f ~/Library/Preferences/com.cyxtera.appgate.sdp.plist
# ```
# - then reboot the computer

# KILL PROCS
# ```
# pkill -9 -f 'AppGate SDP'
# pkill -9 -f 'AppGate Service'
# pkill -9 -f 'AppGate Driver'
# ```
# - from interactive-uninstall

# START PROCS
# ```
# /Library/Application Support/AppGate/AppGate Driver -d -l /var/log/appgate/tun-service.log
# ```
# - from /Library/LaunchDaemons/com.cyxtera.appgate.sdp.tun.plist

# ```
# /Library/Application Support/AppGate/bootstrap
# ```
# - from /Library/LaunchAgents/com.cyxtera.appgate.sdp.client.agent.plist

# LIST LOCAL FIREWALL RULES
# ```
# sudo pfctl -a com.cyxtera.appgate -sr
# ```

# FILE OF INTEREST

## plists
# - /Users/eharrison/Library/Preferences/com.cyxtera.appgate.sdp.helper.plist
# - /Users/eharrison/Library/Preferences/com.cyxtera.appgate.sdp.plist
# - /Users/eharrison/Library/Preferences/com.cyxtera.appgate.sdp.service.plist
# - /Library/LaunchAgents/com.cyxtera.appgate.sdp.client.agent.plist
# - /Library/LaunchAgents/com.cyxtera.appgate.sdp.helper.plist
# - /Library/LaunchDaemons/com.cyxtera.appgate.sdp.tun.plist@  ->  /Library/Application Support/AppGate/com.cyxtera.appgate.sdp.tun.plist
# - /Library/LaunchDaemons/com.cyxtera.appgate.sdp.updater.plist@  ->  /Library/Application Support/AppGate/com.cyxtera.appgate.sdp.updater.plist

## helper scripts
# - /Library/Application Support/AppGate/appgate-helper
# - /Library/Application Support/AppGate/appgate-updater
# - /Library/Application Support/AppGate/bootstrap
# - /Library/Application Support/AppGate/interactive-uninstall

# Binary names
appgate_sdp="AppGate SDP"
appgate_sdp_helper="AppGate SDP Helper"
appgate_service="AppGate Service"
appgate_driver="AppGate Driver"

# Helper paths
applications="/Applications"
library="/Library/Application Support"
macos="Contents/MacOS"
frameworks="Contents/Frameworks"
appgate_base="${applications}/${appgate_sdp}.app"
helper_base="${appgate_base}/${frameworks}/${appgate_sdp_helper}.app"
service_base="${library}/AppGate/${appgate_service}.app"
driver_base="${library}/AppGate"

# Full paths
sdp="${appgate_base}/${macos}/${appgate_sdp}"
hlp="${helper_base}/${macos}/${appgate_sdp_helper}"
srv="${service_base}/${macos}/${appgate_service}"
drv="${driver_base}/${appgate_driver}"

binaries=(
    "${appgate_sdp}" 
    "${appgate_sdp_helper}" 
    "${appgate_service}" 
    "${appgate_driver}"
    )

domains=(
    "com.cyxtera.appgate.sdp"
    "com.cyxtera.appgate.sdp.helper"
    "com.cyxtera.appgate.sdp.service"
    )

maxwidth=60

check_appgate_config(){
    echo "[◆] AppGate configuration"
    (
        echo "DOMAIN KEY VALUE"
        echo "====== === ====="
        for d in "${domains[@]}"; 
        do 
            values=$(defaults read $d | sed s'/[{="}]/ /g' )
            while IFS=';' read -a pairs; do
                for p in "${pairs[@]}"; do
                    if [[ ! -z "${p// }" ]]; then
                        pair=($p)
                        k=${pair[0]}
                        v=${pair[1]}
                        if [[ ${#v} -gt ${maxwidth} ]]; then 
                            # vs=( $(echo $v | fold -w${maxwidth} ))
                            # vs=( $(echo $v | base64 -D | fold -w${maxwidth} ))
                            # vs=( $(echo $v | base64 -D | hexdump -v -e '16/1 "'" "%_p" "'\n"' ))
                            vs=( $(echo $v | base64 -D | hexdump -v -e '"%_p"' | sed -e "s/ /,/g" | fold -w${maxwidth} ))
                            echo $d $k ${vs[0]}
                            for s in "${vs[@]:1}"; do
                                echo "." "." $s
                            done
                        else
                            echo $d $k $v
                        fi
                    fi
                done
            done <<< "$values"
        done
    ) | column -t
}

decode_selected_provider(){
    defaults read com.cyxtera.appgate.sdp.service selected_provider \
        | base64 -D \
        | hexdump -v -C
}
custom_decode_selected_provider(){
    defaults read com.cyxtera.appgate.sdp.service selected_provider \
        | base64 -D \
        | hexdump -v -e '"%08.8_ax  " 8/1 "%.2x " " " 8/1 " %.2x" "  |" 16/1 "%_p" "|" "\n"'
        # | hexdump -v -e '"%08.8_ax  "  |" 16 "%_p" "|" "\n"'
        # | hexdump -v -e '"%06.4_ad  " 22/1 "%_p" "\n"'
}

# WIP
check_appgate_logs(){
    drv_log=~/.tun-service.labelled.log
    app_log=~/.log.labelled.log

    tail -f /var/log/appgate/tun-service.log | awk '{print "[AppGate Driver]  " $0}' > ${drv_log} &
    drv_pid=$!
    echo ${drv_pid}
    tail -f ~/.appgatesdp/log/log.log | awk '{print "[AppGate    SDP]  " $0}' > ${app_log} &
    app_pid=$!
    echo ${app_pid}
    ps

    tail -fq ${drv_log} ${app_log}
    # sort -m -k 3 -o ~/.appgate.log ${app_log} ${drv_log}
    # tail -n 40 ~/.appgate.log
}

check_appgate_processes(){
    echo "[◆] AppGate processes"
    echo && ps -co time,pid,comm -p $(pgrep 'AppGate' )
    echo && pstree -w -g 2 -s "AppGate"
}

start_appgate(){
    echo "[◆] Starting AppGate SDP"
    /Library/Application\ Support/AppGate/bootstrap
}

stop_appgate(){
    echo "[◆] Stopping AppGate SDP processes"
    pids=$(pgrep -x 'AppGate SDP' 'AppGate SDP Helper' 'AppGate Service' )
    for p in ${pids[@]}; do
        target=$(ps -co pid=,comm= -p ${p})
        echo "    sending TERM to process ${target}" 
        kill -s TERM ${p}
    done
}

set_gov_cloud(){
    echo "[◆] Setting GovCloud environment"
    defaults write com.cyxtera.appgate.sdp.service controller_url "https://appgate-controller-0.identity.gov.msap.io/"
    defaults write com.cyxtera.appgate.sdp.service preferred_provider "GOV_IPA"
}

set_com_cloud(){
    echo "[◆] Setting ComCloud environment"
    defaults write com.cyxtera.appgate.sdp.service controller_url "https://appgate-controller-0.identity.msap.io/"
    defaults write com.cyxtera.appgate.sdp.service preferred_provider "FED_IPA"
}

command=$1
case ${command} in
    'gov' )
        stop_appgate
        set_gov_cloud
        start_appgate
        ;;
    'com' )
        stop_appgate
        set_com_cloud
        start_appgate
        ;;
    'start' )
        start_appgate
        ;;
    'stop' )
        stop_appgate
        ;;
    'restart' )
        stop_appgate
        start_appgate
        ;;
    'enable-gov' )
        set_gov_cloud
        ;;
    'enable-com' )
        set_com_cloud
        ;;
    'procs' )
        check_appgate_processes
        ;;
    'logs-wip' )
        check_appgate_logs
        ;;
    'config' )
        check_appgate_config
        ;;
    * )
        echo "unknown command ${command}"
        ;;
esac

  

# if [ "$command" == "start" ]; then
#     start_appgate
# elif [ "$command" == "stop" ]; then
#     stop_appgate
# elif [ "$command" == "gov" ]; then
#     stop_appgate
#     set_gov_cloud
#     start_appgate
# elif [ "$command" == "com" ]; then
#     stop_appgate
#     set_com_cloud
#     start_appgate
# elif [ "$command" == "set-gov" ]; then
#     set_gov_cloud
# elif [ "$command" == "set-com" ]; then
#     set_com_cloud
# elif [ "$command" == "procs" ]; then
#     check_appgate_processes
# elif [ "$command" == "logs" ]; then
#     check_appgate_logs
# else
#     check_appgate_config
# fi


