Gui, Add, Edit, x5 y1 w250 h21 , Enter fds file folder path here
Gui, Add, Edit, x5 y28 w250 h21 , File name is stored here
Gui, Add, Button, x265 y15 w67 h23 , Browse .fds
Gui, Add, Button, x5 y65 w34 h23 , Start
Gui, Add, Button, x5 y95 w42 h23 , Pause
Gui, Add, Button, x55 y65 w34 h23 , Stop
Gui, Add, Button, x55 y95 w25 h23 , Kill
Gui, Add, Button, x5 y125 w67 h23 , Check FDS
Gui, Add, Button, x112 y69 w80 h20 , Browse fds.exe
Gui, Add, Edit, x202 y69 w130 h20 , fds.exe path here
Gui, Add, Button, x112 y99 w80 h20 , Browse mpi
Gui, Add, Edit, x202 y99 w130 h20 , mpiexec.exe path here
Gui, Show, x783 y426 h153 w341, New GUI Window
Return

GuiClose:
	ExitApp
