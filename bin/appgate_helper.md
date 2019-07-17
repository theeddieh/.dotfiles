# APPGATE HELPER RESEARCH

## Background Links
    * https://sdphelp.cyxtera.com/adminguide/v4.2/macos-client.html
    * https://sdphelp.cyxtera.com/userguide/v4.2/advanced/macos/index.html
    * https://sdpdownloads.cyxtera.com/files/download/AppGate-11.3-LTS/doc/manual_chunked_html/

    * https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
    * https://stackoverflow.com/questions/7568112/split-large-string-into-substrings
    * https://ilostmynotes.blogspot.com/2011/09/reading-and-modifying-os-x-plist-files.html

## FILES OF INTEREST

### AppGate plist files
    * `/Users/eharrison/Library/Preferences/com.cyxtera.appgate.sdp.helper.plist`
    * `/Users/eharrison/Library/Preferences/com.cyxtera.appgate.sdp.plist`
    * `/Users/eharrison/Library/Preferences/com.cyxtera.appgate.sdp.service.plist`
    * `/Library/LaunchAgents/com.cyxtera.appgate.sdp.client.agent.plist`
    * `/Library/LaunchAgents/com.cyxtera.appgate.sdp.helper.plist`
    * `/Library/LaunchDaemons/com.cyxtera.appgate.sdp.tun.plist@  ->  /Library/Application Support/AppGate/com.cyxtera.appgate.sdp.tun.plist`
    * `/Library/LaunchDaemons/com.cyxtera.appgate.sdp.updater.plist@  ->  /Library/Application Support/AppGate/com.cyxtera.appgate.sdp.updater.plist

### AppGate helper scripts
    * `/Library/Application Support/AppGate/appgate-helper`
    * `/Library/Application Support/AppGate/appgate-updater`
    * `/Library/Application Support/AppGate/bootstrap`
    * `/Library/Application Support/AppGate/interactive-uninstall`

### Logs
    * client: `~/.appgatesdp/log/log.log`
    * tunnel: `/var/log/appgate/tun-service.log`

### plist editors
    * `/usr/bin/defaults`
    * `/usr/bin/plutil`
    * `/usr/libexec/PlistBuddy`

## Interacting with AppGate

SKIP the Data Usage User Approval screen:
```  
$ defaults write com.cyxtera.appgate.sdp.service user_approval -bool YES
```

SET the Controller URL: 
```  
$ defaults write com.cyxtera.appgate.sdp.service controller_url <your_controller_url>
```
Note: the controller url has to be prefixed with either "https://" or "appgate://" 
e.g.:
https://appgate.company.com appgate://appgate.company.com

SET the Identity Provider: 
```  
$ defaults write com.cyxtera.appgate.sdp.service preferred_provider “myIdP_name” 
```
Note: quotes should be used

MANUAL UNINSTALL
```
sudo /Library/Application\ Support/AppGate/interactive-uninstall
```

CLEAN ALL CLIENT SETTINGS
```
rm -f ~/Library/Preferences/com.cyxtera.appgate.sdp.service.plist
rm -f ~/Library/Preferences/com.cyxtera.appgate.sdp.helper.plist
rm -f ~/Library/Preferences/com.cyxtera.appgate.sdp.plist
```
    * then reboot the computer

KILL PROCS
```
pkill -9 -f 'AppGate SDP'
pkill -9 -f 'AppGate Service'
pkill -9 -f 'AppGate Driver'
```
    * from interactive-uninstall

START PROCS
```
/Library/Application Support/AppGate/AppGate Driver -d -l /var/log/appgate/tun-service.log
```
    * from /Library/LaunchDaemons/com.cyxtera.appgate.sdp.tun.plist

```
/Library/Application Support/AppGate/bootstrap
```
    * from /Library/LaunchAgents/com.cyxtera.appgate.sdp.client.agent.plist

LIST LOCAL FIREWALL RULES
```
sudo pfctl -a com.cyxtera.appgate -sr
```
