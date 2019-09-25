# AppGate Helper Script Research

## Background Links
- https://sdphelp.cyxtera.com/adminguide/v4.2/macos-client.html
- https://sdphelp.cyxtera.com/userguide/v4.2/advanced/macos/index.html
- https://sdpdownloads.cyxtera.com/files/download/AppGate-11.3-LTS/doc/manual_chunked_html/
- https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
- https://stackoverflow.com/questions/7568112/split-large-string-into-substrings
- https://ilostmynotes.blogspot.com/2011/09/reading-and-modifying-os-x-plist-files.html

## Files of Interest

### plist files
- `/Users/eharrison/Library/Preferences/`
    - `com.cyxtera.appgate.sdp.plist`
    - `com.cyxtera.appgate.sdp.helper.plist`
    - `com.cyxtera.appgate.sdp.service.plist`
- `/Library/LaunchAgents/`
    - `com.cyxtera.appgate.sdp.client.agent.plist`
    - `com.cyxtera.appgate.sdp.helper.plist`
- `/Library/LaunchDaemons/`
    - `com.cyxtera.appgate.sdp.tun.plist`
    - `com.cyxtera.appgate.sdp.updater.plist`

### plist editors
- `/usr/bin/defaults`
- `/usr/bin/plutil`
- `/usr/libexec/PlistBuddy`

### helper scripts
- `/Library/Application Support/AppGate/`
    - `appgate-helper`
    - `appgate-updater`
    - `bootstrap`
    - `interactive-uninstall`
    - `osx/`
        - `get_dns`
        - `get_routes`
        - `reset_dns`
        - `reset_fw`
        - `set_dns`
        - `set_fw`

### logs
- client: `~/.appgatesdp/log/log.log`
- tunnel: `/var/log/appgate/tun-service.log`

## Interacting with AppGate

### SKIP the Data Usage User Approval screen
```  
$ defaults write com.cyxtera.appgate.sdp.service user_approval -bool YES
```

### SET Controller URL
```  
$ defaults write com.cyxtera.appgate.sdp.service controller_url <your_controller_url>
```
- The controller url has to be prefixed with either "https://" or "appgate://" 
  e.g.: `https://appgate.company.com` or `appgate://appgate.company.com`

### SET Identity Provider
```  
$ defaults write com.cyxtera.appgate.sdp.service preferred_provider “myIdP_name” 
```
- Quotes should be used

### MANUAL UNINSTALL
```
sudo /Library/Application\ Support/AppGate/interactive-uninstall
```

### KILL APPGATE
```
pkill -9 -f 'AppGate SDP'
pkill -9 -f 'AppGate Service'
pkill -9 -f 'AppGate Driver'
```
- See `/Library/Application Support/AppGate/interactive-uninstall`

### START APPGATE
```
/Library/Application Support/AppGate/AppGate Driver -d -l /var/log/appgate/tun-service.log
```
- See `/Library/LaunchDaemons/com.cyxtera.appgate.sdp.tun.plist`

```
/Library/Application Support/AppGate/bootstrap
```
- See `/Library/LaunchAgents/com.cyxtera.appgate.sdp.client.agent.plist`

