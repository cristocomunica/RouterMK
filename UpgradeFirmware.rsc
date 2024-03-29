:execute {/system logging disable numbers=0,1}
:execute {/system logging add topics=info action=disk}
:execute {/system logging add topics=error action=disk}
:log info "Checking firmware..."
:log info "$[/system routerboard get current-firmware]"
:log info "Checking Updating firmware..."
:log info "$[/system routerboard get upgrade-firmware]"
/system routerboard
:if ([get current-firmware] != [get upgrade-firmware]) do={
  :log info ("Upgrading RouterOS on router $[/system identity get name] from $[/system package update get installed-version] to $[/system package update get latest-version] (channel:$[/system package update get channel])")    
    :execute {/system routerboard upgrade}
    :delay 3
    :put yes
    # Automatic restart
    :delay 2s
    :execute {/system reboot}
    :delay 3s
    :put yes
} else={
    :log info "No update."
}
