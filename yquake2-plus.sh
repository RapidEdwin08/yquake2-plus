#!/bin/bash
# https://github.com/RapidEdwin08/yquake2-plus

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
#		"/opt/retropie/supplementary/runcommand/runcommand.sh" 0 _PORT_ "quake2" "ctf +set deathmatch 1 +map q2ctf1"
#=======================================
version=2023.02

# Add defaultMAP for [dedicatedserver] if NOT Specified
defaultMAP=q2dm1
currentGAME=$(head -3 /dev/shm/runcommand.info | tail -1 | awk '{print $1}')
# DM Maps
if [ "$currentGAME" == "baseq2" ]; then defaultMAP=q2dm1; fi
if [ "$currentGAME" == "rogue" ]; then defaultMAP=rdm14; fi
if [ "$currentGAME" == "zaero" ]; then defaultMAP=zbase1; fi
if [ "$currentGAME" == "xatrix" ]; then defaultMAP=xdm7; fi
if [ "$currentGAME" == "jugfull" ]; then defaultMAP=jdm1; fi
# Non-DM Maps
if [ "$currentGAME" == "wanted" ]; then defaultMAP=wanted; fi
if [ "$currentGAME" == "oblivion" ]; then defaultMAP=w1; fi
if [ "$currentGAME" == "smd" ]; then defaultMAP=smd4; fi

displayCURRENT="$(head -3 /dev/shm/runcommand.info | tail -1)"
if [ "$(head -3 /dev/shm/runcommand.info | tail -1 | grep '+map')" == '' ]; then
	displayCURRENT="$(head -3 /dev/shm/runcommand.info | tail -1) +map $defaultMAP"
fi

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
                 ?J^ !J!    $displayCURRENT            
                 ^J. ^Y:                   
                 .J   ?                    
                  !   !   
")

serverCFGq2=$(
echo '// Sample server config
//
// dmflags settings: https://github.com/RapidEdwin08/yquake2-plus
//
//        DF_NO_HEALTH            1
//        DF_NO_ITEMS             2
//        DF_WEAPONS_STAY         4
//        DF_NO_FALLING           8
//        DF_INSTANT_ITEMS        16
//        DF_SAME_LEVEL           32
//        DF_SKINTEAMS            64
//        DF_MODELTEAMS           128
//        DF_NO_FRIENDLY_FIRE     256
//        DF_SPAWN_FARTHEST       512
//        DF_FORCE_RESPAWN        1024
//        DF_NO_ARMOR             2048
//        DF_ALLOW_EXIT           4096
//        DF_INFINITE_AMMO        8192
//        DF_QUAD_DROP            16384
//        DF_FIXED_FOV            32768
//
//	Heres how it works:	
//
//   DF_WEAPONS_STAY + DF_INSTANT_ITEMS + DF_SPAWN_FARTHEST + 
//       DF_FORCE_RESPAWN + DF_QUAD_DROP
//
// which works out to:
//
//   4 + 16 + 512 + 1024 + 16384 = 17940
//
// ADD DF_NO_FALLING +8 = 17948
//
// ADD DF_ALLOW_EXIT +4096 = 22044

//set dmflags 17948
set dmflags 22044
set hostname "q2srvdm" //config.cfg may 0verride hostname here
set public 1
set deathmatch 1
set maxclients 16
set fraglimit 100
set timelimit 10
//set sv_maplist "q2dm1 q2dm2 q2dm3 q2dm4 q2dm5 q2dm6 q2dm7 q2dm8"
//map q2dm1
'
)

#=======================================
# For Dedicated Server this script calls itself with no parameters - Displays Dedicated Server Dialog - Kills yquake2 when [QUIT] is pressed
if [ "$1" == "" ] && [ "$0" == "/opt/retropie/configs/ports/quake2/yquake2-plus.sh" ]; then
	dialog --no-collapse --ok-label QUIT --title "Quake2 is Running as a Dedicated Server:" --msgbox "$qiiLOGO Press [QUIT] to KILL SERVER and EXIT... "  25 75 </dev/tty > /dev/tty
	# Run RetroPie [runcommand-onend.sh] after Quit
	bash /opt/retropie/configs/all/runcommand-onend.sh > /dev/null 2>&1
	# kill instances of runcommand scripts
	PIDrunncommandSH=$(ps -eaf | grep "quake2" | awk '{print $2}')
	kill $PIDrunncommandSH > /dev/null 2>&1
	exit 0
fi

#=======================================
# Mechanism will Copy Bindings for Most Common Actions from [baseq2] [config.cfg] to Current [%ROM%/config.cfg] if NOT found
# ***SETUP YOUR PREFERRED JOYPAD CONTROLS IN QUAKE II [baseq2] BEFOREHAND***
currentGAMEcfg=/home/$USER/RetroPie/roms/ports/quake2/$currentGAME/config.cfg
yq2GAMEcfg=/opt/retropie/configs/ports/quake2/yquake2/$currentGAME/config.cfg
qiiBASEcfg=$(cat /opt/retropie/configs/ports/quake2/yquake2/baseq2/config.cfg)

if [ ! -f $yq2GAMEcfg ]; then
	mkdir /opt/retropie/configs/ports/quake2/yquake2 > /dev/null 2>&1
	mkdir /opt/retropie/configs/ports/quake2/yquake2/$currentGAME > /dev/null 2>&1
	
	# M0D may already have a custom [config.cfg] - Use that as a base and Filter Out Common Action Bindings if [baseq2/config.cfg] exists
	if [ -f $currentGAMEcfg ] && [ -f /opt/retropie/configs/ports/quake2/yquake2/baseq2/config.cfg ]; then
		cat $currentGAMEcfg | grep -v "+moveup" | grep -v "centerview" | grep -v "+movedown" | grep -v "+speed" | grep -v "weapprev" | grep -v "weapnext" | grep -v "cmd help" | grep -v "inven" | grep -v "invprev" | grep -v "invnext" | grep -v "invdrop" | grep -v "invuse" | grep -v "+attack" > $yq2GAMEcfg
	fi
	if [ -f /opt/retropie/configs/ports/quake2/yquake2/baseq2/config.cfg ]; then
		# Pull Bindings for Most Common Actions from [baseq2] [config.cfg]
		# "+moveup" "centerview" "+movedown" "+speed" "weapprev" "weapnext" "cmd help" "inven" "invprev" "invnext" "invdrop" "invuse" "+attack"
		echo "// Bindings pulled from [baseq2/config.cfg]" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "+moveup" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "centerview" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "+movedown" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "+speed" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "weapprev" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "weapnext" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "cmd help" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "inven" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "invprev" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "invnext" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "invdrop" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "invuse" >> $yq2GAMEcfg
		echo "$qiiBASEcfg" | grep "+attack" >> $yq2GAMEcfg
		#echo "// Slight Mechanical Destruction Custom Binding [+use]" >> $yq2GAMEcfg
		#echo "$qiiBASEcfg" | grep "+use" >> $yq2GAMEcfg
	fi
fi

#=======================================
# Pull Default [yquake2] String - Run String with "Double-Quotes" Removed
yquake2STRING=$(cat /opt/retropie/configs/ports/quake2/emulators.cfg | grep 'yquake2 =' | sed 's/yquake2 = //' | sed "s/%ROM%/\"$1\"/g" | sed "s/%XRES%/"$2"/g" | sed "s/%YRES%/"$3"/g" | sed 's/\"//g')

if [ "$2" == "deathmatch" ] || [ "$4" == "deathmatch" ]; then # Deathmatch
	echo $yquake2STRING +set deathmatch 1 >> /dev/shm/runcommand.log
	$yquake2STRING +set deathmatch 1
elif [ "$2" == "server" ] || [ "$4" == "server" ]; then # Dedicated Server - Uses [server.cfg]
	sudo /home/$USER/RetroPie-Setup/retropie_packages.sh retropiemenu launch "/opt/retropie/configs/ports/quake2/yquake2-plus.sh" </dev/tty > /dev/tty &
	# Create [server.cfg] if NOT found in Specified Q2-Game Folder
	if [ ! -f ~/RetroPie/roms/ports/quake2/$currentGAME/server.cfg ]; then echo "$serverCFGq2" > ~/RetroPie/roms/ports/quake2/$currentGAME/server.cfg; fi
	# Add [+map $defaultMAP] if NOT SPECIFIED for dedicatedserver
	if [ "$(head -3 /dev/shm/runcommand.info | tail -1 | grep '+map')" == '' ]; then
		echo $yquake2STRING +map $defaultMAP +set dedicated 1 +exec server.cfg >> /dev/shm/runcommand.log
		$yquake2STRING +map $defaultMAP +set dedicated 1 +exec server.cfg
	else
		echo $yquake2STRING +set dedicated 1 +exec server.cfg >> /dev/shm/runcommand.log
		$yquake2STRING +set dedicated 1 +exec server.cfg
	fi
else
	echo $yquake2STRING >> /dev/shm/runcommand.log # Default yquake2+
	$yquake2STRING
fi
