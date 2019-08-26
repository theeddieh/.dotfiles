#!/usr/bin/env bash

# Binary names
appgate_sdp="AppGate SDP"
appgate_sdp_helper="AppGate SDP Helper"
appgate_service="AppGate Service"
appgate_driver="AppGate Driver"

# Helper path fragments
applications="/Applications"
library="/Library/Application Support"
macos="Contents/MacOS"
frameworks="Contents/Frameworks"
appgate_base="${applications}/${appgate_sdp}.app"
helper_base="${appgate_base}/${frameworks}/${appgate_sdp_helper}.app"
service_base="${library}/AppGate/${appgate_service}.app"
driver_base="${library}/AppGate"

# Full paths to executables
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

# Must specify these by filename, prefixed by ${driver_base}
driver_domains=(
    "com.cyxtera.appgate.sdp.tun"
    "com.cyxtera.appgate.sdp.updater"
)

maxwidth=60

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
                            # vs=( $(echo $v | fold -w${maxwidth} ))
                            # vs=( $(echo $v | base64 -D | fold -w${maxwidth} ))
                            # vs=( $(echo $v | base64 -D | hexdump -v -e '16/1 "'" "%_p" "'\n"' ))
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
    /Library/Application\ Support/AppGate/bootstrap
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

set_gov_cloud() {
    echo "[◆] Setting GovCloud environment"
    defaults write com.cyxtera.appgate.sdp.service controller_url "https://appgate-controller-0.identity.gov.msap.io/"
    defaults write com.cyxtera.appgate.sdp.service preferred_provider "GOV_IPA"
    lpass show --clip --password gov.msap.io
}

set_com_cloud() {
    echo "[◆] Setting ComCloud environment"
    defaults write com.cyxtera.appgate.sdp.service controller_url "https://appgate-controller-0.identity.msap.io/"
    defaults write com.cyxtera.appgate.sdp.service preferred_provider "FED_IPA"
    lpass show --clip --password prod.identity.msap.io
}

show_usage() {
    echo
    echo "Usage:"
    echo "  appgate [command]"
    echo
    echo "Commands:"
    echo "  gov         switch to GovCloud"
    echo "  com         switch to ComCloud"
    echo "  start       start AppGate client"
    echo "  stop        stop AppGate client"
    echo "  restart     restart AppGate client"
    echo "  enable-gov  set GovCloud environment but do not switch"
    echo "  enable-com  set ComCloud environment but do not switch"
    echo "  procs       show all AppGate processes"
    echo "  logs-wip    tail AppGate logs (WIP)"
    echo "  config      print current AppGate configuration"
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
    'enable-gov')
        set_gov_cloud
        ;;
    'enable-com')
        set_com_cloud
        ;;
    'procs')
        check_appgate_processes
        ;;
    'logs-wip')
        check_appgate_logs
        ;;
    'config')
        check_appgate_config
        ;;
    'help')
        show_usage
        ;;
    *)
        show_usage
        ;;
esac
