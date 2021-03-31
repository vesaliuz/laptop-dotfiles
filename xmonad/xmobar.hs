Config {
    font = "xft:Monofur Nerd Font:size=9:book:antialias=true",
    additionalFonts = [ "-*-*-*-*-*-*-12-*-*-*-*-*-*-*"
                      , "xft:SF Pro Display:size=9:Light:antialias=true"
                      , "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-koi8-*"
                      ],
    textOffset = 12,
    bgColor = "#10101c",
    fgColor = "#bbbbd0"
    position = Static { xpos = 0, ypos = 0, width = 1366, height = 17 },
    border = BottomB,
    borderColor = "#10101c",
    borderWidth = 2,
    lowerOnStart = True,
    commands =
        [Run Date "%a %b %d" "date" 3600
        ,Run Date "<fn=2>%H:%M</fn>" "time" 30
        ,Run Cpu ["--template" , "<fn=2><total></fn>%", "-w", "2"] 10 -- fix %
        ,Run Com "bash" ["-c", "pactl list sinks | grep -oh \"[0-9]*%\" | head -n 1 | tr -d %"] "vol" 10
        ,Run Com "bash" ["-c", ".xmonad/music.sh"] "music" 7
        ,Run Com "bash" ["-c", ".xmonad/network.sh"] "network" 60
        ,Run Kbd [("es", "es"), ("us", "en")]
        ,Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "¯\_(ツ)_/¯"
}
