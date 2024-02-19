Gui, Add, Button, x10 y50 w100 h30 gStart, Start
Gui, Add, Button, x120 y50 w100 h30 gPause, Pause
Gui, Add, Button, x10 y90 w100 h30 gStop, Stop
Gui, Add, Button, x120 y90 w100 h30 gKill, Kill
Gui, Show
return

Start:
    Run, fds run %filepath%
return

Pause:
    Run, fds pause %filepath%
return

Stop:
    Run, fds stop %filepath%
return

Kill:
    Run, fds kill %filepath%
return