
import sys
import os
from layout import *

arguments = sys.argv

for args in arguments:
 if args=="--help" or args== "-h":
  print("""Help box for Idle by\033[34;1;40m Devesh Sharma\nIf you don't pass anything it will automatically run the program\n\033[37;1;40m--start to start the gui version\n--about or -a to get information about the program\n--clear or -c  to clear the screen\n--uninstall or -u to uninstall the module\n-- or -h help shows this manual""")

 elif args=="--about" or args=="-a":
  print("""\033[34;1;40mThis program is made by Devesh Sharma using the tkinter who lives in Panipat , Haryana located in India. He wants to provide a best coding experiences using python modules and makimg efforts to enhance its performance and this program is freely available on github Anybody who want to support is free to support in this program and anybody who wants to use this program can use this program in his programs or project or for anyuses without my permission. Regards to Readers
Thank You
A wish to Readers by Devesh Sharma
""")
 elif args=="--start" or args=="-s":
  gui.mainloop()

 elif args== "--clear" or args=="-c":
  os.system("clear")

 elif args=="--uninstall" or args=="-u":
  os.system("pip uninstall idle")

gui.mainloop()
