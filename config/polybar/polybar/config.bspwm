[colors]
foreground     = #FFFFFF
foreground-alt = #666666
background         = #88282A36
background-focused = #88666666
background-urgent  = #88FF0000
red    = #FF0000
green  = #00FF00
blue   = #0000FF
yellow = #FFFF00

[bar/topbar]
monitor = HDMI3
monitor-fallback = HDMI1
wm-restack = i3
height = 24
foreground = ${colors.foreground}
background = ${colors.background}

font-0 = Lucida Grande:style=Bold:size=9;2
font-1 = SauceCodePro Nerd Font:style=Regular:size=10;2
font-2 = SauceCodePro Nerd Font:style=Regular:size=10;1
font-3 = "UbuntuMono Nerd Font:size=11;2"
font-4 = "Noto Sans Symbols2:pixelsize=11;4"
font-5 = "Font Awesome 5 Free:style=Regular:pixelsize=8;1"
font-6 = "UbuntuMono Nerd Font:size=10;4"
font-7 = "Font Awesome 5 Brands:pixelsize=8;1"
font-8 = "Noto Sans Symbols2:pixelsize=8;3"

module-margin = 2
padding-right = 2
modules-left   = i3 title
modules-center = date
modules-right  = ethernet wlan memory cpu temperature  alsa
cursor-click = pointer
tray-position = right



[module/bspwm]
type = internal/bspwm
label-focused  = %{T2}%name%
label-occupied = %{T2}%name%
label-urgent   = %{T2}%name%
label-empty    = %{T2}·
label-focused-padding  = 2
label-occupied-padding = 2
label-urgent-padding   = 2
label-empty-padding    = 2
label-focused-background  = ${colors.background-focused}
label-urgent-background   = ${colors.background-urgent}
#; 

[module/i3]
;https://github.com/jaagr/polybar/wiki/Module:-i3
type = internal/i3

; Only show workspaces defined on the same output as the bar
;
; Useful if you want to show monitor specific workspaces
; on different bars 
;
; Default: false
pin-workspaces = true 

; This will split the workspace name on ':'
; Default: false
strip-wsnumbers = false

; Sort the workspaces by index instead of the default
; sorting that groups the workspaces by output
; Default: false
index-sort = false

; Create click handler used to focus workspace
; Default: true 
enable-click = true 

; Create scroll handlers used to cycle workspaces
; Default: true 
enable-scroll = true 

; Wrap around when reaching the first/last workspace
; Default: true 
wrapping-scroll = false

; Set the scroll cycle direction
; Default: true 
reverse-scroll = false

; Use fuzzy (partial) matching on labels when assigning
; icons to workspaces
; Example: code;♚ will apply the icon to all workspaces
; containing 'code' in the label
; Default: false
fuzzy-match = false

;extra icons to choose from 
;http://fontawesome.io/cheatsheet/
;       v     

ws-icon-0 =  1;
ws-icon-1 =  2;
ws-icon-2 =  3;
ws-icon-3 =  4;
ws-icon-4 =  5;
ws-icon-5 =  6;
ws-icon-6 =  7;
ws-icon-7 =  8;
ws-icon-8 =  9;
ws-icon-9 =  10; 
ws-icon-default = " " 

; Available tags:
;   <label-state> (default) - gets replaced with <label-(focused|unfocused|visible|urgent)>
;   <label-mode> (default)
format = <label-state> <label-mode>

label-mode = %mode%
label-mode-padding = 6
label-mode-foreground = #000000
label-mode-background = #FFBB00

; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %output%
; Default: %icon%
; focused = Active workspace on focused monitor
label-focused = %name%
label-focused-background = ${colors.background-focused}
label-focused-foreground = ${colors.foreground}
label-focused-underline = 
label-focused-padding = 4

; Available tokens:
;   %name%
;   %icon%
;   %index%
; Default: %icon%
; unfocused = Inactive workspace on any monitor
label-unfocused = %icon%
label-unfocused-padding = 4
label-unfocused-background = ${colors.background}
label-unfocused-foreground = ${colors.foreground}
label-unfocused-underline =

; visible = Active workspace on unfocused monitor
label-visible = %icon%
label-visible-background = ${self.label-focused-background}
label-visible-underline = ${self.label-focused-underline}
label-visible-padding = 4

; Available tokens:
;   %name%
;   %icon%
;   %index%
; Default: %icon% %name%
; urgent = Workspace with urgency hint set
label-urgent = %icon%
label-urgent-background = ${self.label-focused-background}
label-urgent-foreground = #db104e
label-urgent-padding = 4

format-foreground = ${colors.foreground}
format-background = ${colors.background}


[module/title]
type = internal/xwindow
label-maxlen = 80

[module/date]
type = internal/date
interval = 1
label = %time% - %date%
time     = %R
date     = %a, %b %d
time-alt = %T
date-alt = %A, %B %d, %Y

[module/ethernet]
type = internal/network
interface = ${env:ethernetcard}
format-connected-prefix    = " "
label-connected         = %local_ip%

[module/wlan]
type = internal/network
interface = ${env:wificard}
format-connected    = %{A1:$HOME/.config/dmenu/scripts/dmenu-wifi:}<label-connected>%{A}
format-disconnected = %{A1:$HOME/.config/dmenu/scripts/dmenu-wifi:}<label-disconnected>%{A}
format-connected-prefix    = "直 "
format-disconnected-prefix = "睊 "
format-disconnected-prefix-foreground = ${colors.red}
label-connected         = %essid%
label-disconnected      = Disconnected
label-disconnected-foreground = ${colors.red}

[module/cpu]
type = internal/cpu
format-prefix = " "

[module/temperature]
type = internal/temperature
thermal-zone = ${env:cputhermalzone}
format = <ramp> <label>
format-warn = <ramp> <label-warn>
label-warn-foreground = ${colors.red}
ramp-0 = 
ramp-1 = 
ramp-2 = 
ramp-3 = 
ramp-4 = 

[module/memory]
type = internal/memory
format-prefix = " "
label         = %gb_used% / %gb_free%

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC
format-discharging = <ramp-capacity> <label-discharging>
format-charging    = <animation-charging> <label-charging>
format-full        = <ramp-capacity> <label-full>
format-charging-foreground = ${colors.yellow}
format-full-foreground     = ${colors.green}
ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 
animation-charging-framerate = 1000
animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-3 = 
animation-charging-4 = 

[module/alsa]
type = internal/alsa
format-volume = <ramp-volume> <bar-volume>
format-muted-prefix = "ﱝ "
label-muted = sound muted
ramp-volume-0 = 奄
ramp-volume-1 = 奔
ramp-volume-2 = 墳
bar-volume-width     = 11
bar-volume-indicator =
bar-volume-fill      = ─
bar-volume-empty     = ─
bar-volume-fill-font      = 3
bar-volume-empty-font     = 3
bar-volume-empty-foreground = ${colors.foreground-alt}

[module/xbacklight]
type = internal/xbacklight
format = <ramp>
ramp-0 = 
ramp-1 = 
ramp-2 = 
