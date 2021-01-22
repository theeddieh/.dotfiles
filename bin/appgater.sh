#!/usr/bin/env bash

# Binary names
bin_sdp="AppGate SDP"
bin_sdp_helper="AppGate SDP Helper"
bin_service="AppGate Service"
bin_driver="AppGate Driver"

# Helper path fragments
app_base="/Applications/AppGate SDP.app"
app_support_base="/Library/Application Support/AppGate"
lib_preferences="/Users/eharrison/Library/Preferences"
lib_agents="/Library/LaunchAgents"
lib_daemons="/Library/LaunchDaemons"
macos="Contents/MacOS"
frameworks="Contents/Frameworks"

appgate_base="${app_base}/${macos}"
helper_base="${app_base}/${frameworks}/${bin_sdp_helper}.app/${macos}"
service_base="${app_support_base}/${bin_service}.app/${macos}"
driver_base="${app_support_base}"

# Full paths to executables
sdp="${appgate_base}/${bin_sdp}"
hlp="${helper_base}/${bin_sdp_helper}"
srv="${service_base}/${bin_service}"
drv="${driver_base}/${bin_driver}"

binary_paths=(
    "${sdp}"
    "${hlp}"
    "${srv}"
    "${drv}"
)

helper_scripts=(
    "${app_support_base}/appgate-helper"
    "${app_support_base}/appgate-updater"
    "${app_support_base}/bootstrap"
    "${app_support_base}/interactive-uninstall"
    "${app_support_base}/osx/get_dns"
    "${app_support_base}/osx/get_routes"
    "${app_support_base}/osx/reset_dns"
    "${app_support_base}/osx/reset_fw"
    "${app_support_base}/osx/set_dns"
    "${app_support_base}/osx/set_fw"
)

plist_files=(
    "${lib_preferences}/com.cyxtera.appgate.sdp.plist"
    "${lib_preferences}/com.cyxtera.appgate.sdp.helper.plist"
    "${lib_preferences}/com.cyxtera.appgate.sdp.service.plist"
    "${lib_agents}/com.cyxtera.appgate.sdp.client.agent.plist"
    "${lib_agents}/com.cyxtera.appgate.sdp.helper.plist"
    "${lib_daemons}/com.cyxtera.appgate.sdp.tun.plist"
    "${lib_daemons}/com.cyxtera.appgate.sdp.updater.plist"
)

domains=(
    "com.cyxtera.appgate.sdp"
    "com.cyxtera.appgate.sdp.helper"
    "com.cyxtera.appgate.sdp.service"
)

# Must specify these by filename, prefixed by ${driver_base}
driver_domains=(
    "com.cyxtera.appgate.sdp.tun"
    "com.cyxtera.appgate.sdp.updater"
)

client_log="~/.appgatesdp/log/log.log"
tunnel_log="/var/log/appgate/tun-service.log"

log_files=(
    "${client_log}"
    "${tunnel_log}"
)

maxwidth=60

check_appgate_files() {
    (for p in "${binary_paths[@]}" "${helper_scripts[@]}" "${plist_files[@]}" "${log_files[@]}"; do
        file --print0  "${p}"
    done) | cut -d ":" -f 1,2

}

check_appgate_config() {
    echo "[◆] AppGate configuration"
    (   
        echo "DOMAIN KEY VALUE"
        echo "====== === ====="
        for d in "${domains[@]}"; do
            values=$(defaults read "$d" | sed s'/[{="}]/ /g')
            while IFS=';' read -a pairs; do
                for p in "${pairs[@]}"; do
                    if [[ ! -z "${p// /}" ]]; then
                        pair=($p)
                        k=${pair[0]}
                        v=${pair[1]}
                        if [[ ${#v} -gt ${maxwidth} ]]; then
                            vs=($( echo $v \
                                    | base64 -D \
                                    | hexdump -v -e '"%_p"' \
                                    | sed -e "s/ /,/g" \
                                    | fold -w${maxwidth}))
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

        for d in "${driver_domains[@]}"; do
            values=$(defaults read "${driver_base}/$d" | sed s'/[,;="{}]/ /g')
            multivalue=1
            while IFS=';' read -a pairs; do
                for p in "${pairs[@]}"; do
                    if [[ ! -z "${p// /}" ]]; then
                        pair=($p)
                        k=${pair[0]}
                        v=${pair[1]}

                        if [[ ${v} == "(" ]]; then
                            multivalue=0
                            echo $d $k "."
                            continue
                        fi

                        if [[ ${k} == ")" ]]; then
                            multivalue=1
                            echo "." "." "."
                            continue
                        fi

                        if [[ ${multivalue} == 0 ]]; then
                            echo "." "." ${k}${v}
                        else
                            echo $d $k $v
                        fi
                    fi
                done
            done <<< "$values"
        done
    ) | column -t
}

decode_selected_provider() {
    defaults read com.cyxtera.appgate.sdp.service selected_provider \
        | base64 -D \
        | hexdump -v -C
}

# WIP
custom_decode_selected_provider() {
    defaults read com.cyxtera.appgate.sdp.service selected_provider \
        | base64 -D \
        | hexdump -v -e '"%08.8_ax  " 8/1 "%.2x " " " 8/1 " %.2x" "  |" 16/1 "%_p" "|" "\n"'
    # | hexdump -v -e '"%08.8_ax  "  |" 16 "%_p" "|" "\n"'
    # | hexdump -v -e '"%06.4_ad  " 22/1 "%_p" "\n"'
}

# WIP
check_appgate_logs() {
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

check_appgate_processes() {
    echo "[◆] AppGate processes"
    echo && ps -co time,pid,comm -p $(pgrep 'AppGate')
    echo && pstree -w -g 2 -s "AppGate"
}

start_appgate() {
    echo "[◆] Starting AppGate SDP"
    "${driver_base}/bootstrap"
}

stop_appgate() {
    echo "[◆] Stopping AppGate SDP processes"
    pids=$(pgrep -x 'AppGate SDP' 'AppGate SDP Helper' 'AppGate Service')
    for p in ${pids[@]}; do
        target=$(ps -co pid=,comm= -p ${p})
        echo "    sending TERM to process ${target}"
        kill -s TERM ${p}
    done
}

copy_password() {
    domain=${1}
    echo "[◆] Copying AppGate password for ${domain} to clipboard"

    if [[ $(which -s lpass) -ne 0 ]]; then
        echo "[!] You need the LastPass CLI first, try:"
        echo "[!] brew install lastpass-cli"
    elif [[ $(lpass status --quiet) -ne 0 ]]; then
        echo "[!] You nedd to log in to LastPass first, try:"
        echo "[!] lpass login theeddieharrison@gmail.com"
    else
        lpass sync
        lpass show --clip --password ${domain}
    fi
}

set_gov_cloud() {
    set_environment "GovCloud" "https://appgate-controller-0.identity.gov.msap.io/" "GOV2_IPA" "gov.msap.io"
}

set_com_cloud() {
    set_environment "ComCloud" "https://appgate-controller-0.identity.msap.io/" "FED_IPA" "prod.identity.msap.io"
}

# $1: name
# $2: controller_url
# $3: preferred_provider
# $4: lastpass entry name/domain
set_environment() {
    echo "[◆] Setting ${1} environment"
    defaults write com.cyxtera.appgate.sdp.service controller_url ${2}
    defaults write com.cyxtera.appgate.sdp.service preferred_provider ${3}
    copy_password ${4}
}

show_usage() {
    echo "apg: AppGate Assistant script"
    echo
    echo "Usage:"
    echo "  apg [command]"
    echo
    echo "Commands:"
    echo "  gov         switch to GovCloud"
    echo "  com         switch to ComCloud"
    echo "  stop        stop AppGate client"
    echo "  start       start AppGate client"
    echo "  restart     restart AppGate client"
    echo "  procs       show all AppGate processes"
    echo "  config      print current AppGate configuration"
    echo "  tree        check for AppGate binaries"
    echo "  help        print this help message"
}

command=$1
case ${command} in
    'gov')
        stop_appgate
        set_gov_cloud
        start_appgate
        ;;
    'com')
        stop_appgate
        set_com_cloud
        start_appgate
        ;;
    'start')
        start_appgate
        ;;
    'stop')
        stop_appgate
        ;;
    'restart')
        stop_appgate
        start_appgate
        ;;
    'procs')
        check_appgate_processes
        ;;
    'config')
        check_appgate_config
        ;;
    'tree')
        check_appgate_files
        ;;
    'help')
        show_usage
        ;;
    'enable-gov')
        set_gov_cloud
        ;;
    'enable-com')
        set_com_cloud
        ;;
    'logs-wip')
        check_appgate_logs
        ;;
    *)
        show_usage
        ;;
esac
