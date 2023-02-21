#!/bin/bash
# https://github.com/RapidEdwin08/yquake2-plus
version=2023.02

# "Double-Quotes" do NOT Pass the Extra Parameters (eg. +map) using Default [yquake2] String.
# This Script will Remove "Double-Quotes" from %ROM% - To be used as an Additional Quake2 Emulator [yquake2+].

# Install/Copy to [/opt/retropie/configs/ports/quake2/yquake2-plus.sh] - Make Executable
#		cp ~/yquake2-plus.sh /opt/retropie/configs/ports/quake2/yquake2-plus.sh
#		sudo chmod 755 /opt/retropie/configs/ports/quake2/yquake2-plus.sh

# Edit [/opt/retropie/configs/ports/quake2/emulators.cfg], %XRES%/%YRES% Included to Support Multiple vid_renderer modes:
#		yquake2 = "/opt/retropie/ports/yquake2/quake2 ...LEAVE DEFAULT INTACT"
#		yquake2+ = "/opt/retropie/configs/ports/quake2/yquake2-plus.sh %ROM% %XRES% %YRES%"
#		yquake2+deathmatch = "/opt/retropie/configs/ports/quake2/yquake2-plus.sh %ROM% %XRES% %YRES% deathmatch"
#		yquake2+dedicatedserver = "/opt/retropie/configs/ports/quake2/yquake2-plus.sh %ROM% %XRES% %YRES% server"
#		default = "yquake2+"

# Sample [Quake2-M0D-Template.sh] Strings:
#		"/opt/retropie/supplementary/runcommand/runcommand.sh" 0 _PORT_ "quake2" "q2dme1m1 +map q2dme1m1"
#		"/opt/retropie/supplementary/runcommand/runcommand.sh" 0 _PORT_ "quake2" "baseq2 +set deathmatch 1 +map q2dm1"
#		"/opt/retropie/supplementary/runcommand/runcommand.sh" 0 _PORT_ "quake2" "q2ctf150 +set deathmatch 1 +map q2ctf1"

qiiLOGO=$(
echo "
            .               .              $(hostname -I | tr -d ' '):27910
         ..                  .:.           
       .^                      .^.              
      ~~                         ~^        
     ~7                           5^       
    .5:                           ~5       
    ~P.                           :G:      
    ~5^                           ?P^      
    .J5:                         :PP       
     ^Y5.        !~! !~!       ^5B!       
      ~JY~.      ?Y? !J?      :YBB!        
       .~?Y7:    !?~ ~J!   :?GBP5:         
          ^7?YY~~JJ7:?5Y!JPBBG!.           
            .^^5G?!J777JPJJ!:              
                .?7!.777.                  
                 ?7^ !?7                   
                 ?J^ !J!    $(head -3 /dev/shm/runcommand.info | tail -1)            
                 ^J. ^Y:                   
                 .J   ?                    
                  !   !   
")

#=======================================
# For Dedicated Server this script calls itself with no parameters - Displays Dedicated Server Dialog - Kills yquake2 when [QUIT] is pressed
if [ "$1" == "" ]; then
	dialog --no-collapse --ok-label QUIT --title "Quake2 is Running as a Dedicated Server:" --msgbox "$qiiLOGO Press [QUIT] to KILL SERVER and EXIT... "  25 75 </dev/tty > /dev/tty
	# Run RetroPie [runcommand-onend.sh] after Quit
	bash /opt/retropie/configs/all/runcommand-onend.sh > /dev/null 2>&1
	# kill instances of runcommand scripts
	PIDrunncommandSH=$(ps -eaf | grep "quake2" | awk '{print $2}')
	kill $PIDrunncommandSH > /dev/null 2>&1
fi
#=======================================
# Pull Default [yquake2] String - Run String with "Double-Quotes" Removed
yquake2STRING=$(cat /opt/retropie/configs/ports/quake2/emulators.cfg | grep 'yquake2 =' | sed 's/yquake2 = //' | sed "s/%ROM%/\"$1\"/g" | sed "s/%XRES%/"$2"/g" | sed "s/%YRES%/"$3"/g" | sed 's/\"//g')

if [ "$2" == "deathmatch" ] || [ "$4" == "deathmatch" ]; then # Deathmatch
	echo $yquake2STRING +set deathmatch 1 >> /dev/shm/runcommand.log
	$yquake2STRING +set deathmatch 1
elif [ "$2" == "server" ] || [ "$4" == "server" ]; then # Dedicated Server - Uses [server.cfg]
	sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch "/opt/retropie/configs/ports/quake2/yquake2-plus.sh" </dev/tty > /dev/tty &
	echo $yquake2STRING +set dedicated 1 +exec server.cfg >> /dev/shm/runcommand.log
	$yquake2STRING +set dedicated 1 +exec server.cfg
else
	echo $yquake2STRING >> /dev/shm/runcommand.log # Default yquake2+
	$yquake2STRING
fi
