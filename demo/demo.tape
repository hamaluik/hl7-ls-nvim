Output demo.gif

Require nvim

Set Shell "bash"
Set FontFamily "FiraCode Nerd Font"
Set FontSize 16
Set Width 848
Set Height 516
Set Margin 0
Set Padding 8
Set Theme "Rose Pine"

Type "nvim ./sample_adt_a08.hl7" Enter
Sleep 5s

Type "]d"
Sleep 2s
Type "]d"
Sleep 2s
Type "]d"
Sleep 5s

Type "  Document" Sleep 2s Enter
Type "MSH.7" Sleep 1s Enter
Sleep 2s

Type "K"
Sleep 5s

Type "  Document" Sleep 2s Enter
Type "MSH.10" Sleep 1s Enter
Sleep 2s

Type "K"
Sleep 5s

Type " vca" Sleep 2s Enter
Sleep 1s

Type "K"
Sleep 3s

Type "gg" Sleep 1s
Type "dw" Sleep 1s
Type "]d"
Sleep 5s
Type "u"
Sleep 1s

Type "  Document" Sleep 2s Enter
Type "EVN.1" Sleep 1s Enter
Sleep 2s

Type "cw" Sleep 1s
Type "A" Sleep 3s
Down 3 Sleep 1s Enter Sleep 100ms Escape Sleep 3s
Type "uu" Sleep 1s

Type "j^dG$a" Enter Sleep 2s
Type "P" Sleep 1s
Type "V" Sleep 1s
Down 1 Sleep 1s
Enter Escape Sleep 1s
Type "uuu" Sleep 5s

