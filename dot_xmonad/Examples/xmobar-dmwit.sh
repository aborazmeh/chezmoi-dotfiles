Config {
    font         = "xft:Monospace:pixelsize=14,-*-*-*-r-*-*-16-*-*-*-*-*-*-*",
    bgColor      = "#000040",
    fgColor      = "#80c0ff",
    position     = TopSize C 100 26,
    lowerOnStart = True,
    commands     = [
        Run StdinReader,
        Run Com "date" ["+%H:%M"] "" 30
        ],
    sepChar      = "%",
    alignSep     = "\NUL\NUL",
    template     = "%StdinReader%"
}
