#!/usr/bin/env bash
# https://github.com/RapidEdwin08/yquake2-plus
version=2023.02

q2plusLOGO=$(
echo "                            :.        .:        
                          :.            .:      
                         =                -     
                        -:                .-    
                        =.                .=    
                        +-                --    
                        :=-    :=  =:    --.    
                         :++-. .+  +. .:-:.     
                           :=+=-+=+==---:       
                              .:++++:.          
                               .+  +.           
                                +  +            
                                =  =            "
)

ctfREFS=$(
echo '
[Quake II Capture the Flag]:

1) GET [ctf] FILES HERE:
www.doomworld.com/idgames/idstuff/quake2/ctf/q2ctf150

2) EXTRACT CONTENTS OF [q2ctf150.zip] FILES INTO:
~/RetroPie/roms/ports/quake2/ctf/

3) MAKE/INSTALL CTF [game.so] FOR LINUX: (Or use Utility Script)
cd ~
git clone --depth 1 https://github.com/yquake2/ctf.git
cd ctf
make
mv ~/ctf/release/game.so ~/RetroPie/roms/ports/quake2/ctf/

EXAMPLE [yquake2-plus.sh] ROM SCRIPTs:
_PORT_ "quake2" "q2dme1m1 +map q2dme1m1"
_PORT_ "quake2" "baseq2 +map q2dm1"
_PORT_ "quake2" "ctf +map q2ctf1"

# Additional Emulator Entries for RetroPie Yamagi Quake II #
[yquake2+]: %ROM% with "Double-Quotes" Removed
[yquake2+deathmatch]: %ROM% +set deathmatch 1
[yquake2+dedicatedserver]: %ROM% +set dedicated 1 +exec server.cfg

======================================================================
CURRENT CONTENT [/opt/retropie/configs/ports/quake2/emulators.cfg]:                   
======================================================================
'
)

mainMENU()
{

# WARN IF [..ports/quake2/emlators.cfg] N0T Found 
if [ ! -f /opt/retropie/configs/ports/quake2/emulators.cfg ]; then
	dialog --no-collapse --title "***N0TICE*** [..ports/quake2/emlators.cfg] NOT FOUND!" --ok-label MENU --msgbox "You MUST INSTALL Yamagi Quake II from RetroPie Setup 1st! [yquake2]"  25 75
fi
# Confirm Configurations
confQ2plus=$(dialog --no-collapse --title " [yquake2-plus] + [Quake II Capture the Flag] by: RapidEdwin08 [v$version]" \
	--ok-label OK --cancel-label EXIT \
	--menu "$q2plusLOGO" 25 75 20 \
	1 "><  INSTALL [yquake2+] for RetroPie Yamagi Quake II  ><" \
	2 "><  REMOVE  [yquake2+] for RetroPie Yamagi Quake II  ><" \
	3 "><  MAKE/INSTALL [Quake II Capture the Flag]  ><" \
	R "><  REFERENCES  ><" 2>&1>/dev/tty)

# INSTALL [yquake2+]
if [ "$confQ2plus" == '1' ]; then
	confINSTALLq2plus=$(dialog --no-collapse --title "               INSTALL [yquake2+] for RetroPie Yamagi Quake II              " \
		--ok-label OK --cancel-label BACK \
		--menu "                          ? ARE YOU SURE ?             \n   [yquake2+]  [yquake2+deathmatch]  [yquake2+dedicatedserver]" 25 75 20 \
		1 "><  YES INSTALL [yquake2+] for RetroPie Yamagi Quake II  ><" \
		2 "><  BACK  ><" 2>&1>/dev/tty)
	# Install Confirmed - Otherwise Back to Main Menu
	if [ "$confINSTALLq2plus" == '1' ]; then
		tput reset
		# WARN IF [..ports/quake2/emlators.cfg] N0T Found
		if [ ! -f /opt/retropie/configs/ports/quake2/emulators.cfg ]; then
			dialog --no-collapse --title "***N0TICE*** [..ports/quake2/emlators.cfg] NOT FOUND!" --ok-label MENU --msgbox "You MUST INSTALL Yamagi Quake II from RetroPie Setup 1st! [yquake2]"  25 75
			mainMENU
		fi
		
		# yquake2 Config
		if [ -f /opt/retropie/configs/ports/quake2/emulators.cfg ]; then
			# Get [yyquake2-plus.sh] - REQUIRES INTERNET
			wget https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2-plus.sh -P /dev/shm
			
			# CHECK for REQUIRED [yquake2-plus.sh] - MAIN MENU IF NOT FOUND
			if [ ! -f /dev/shm/yquake2-plus.sh ]; then
				dialog --no-collapse --title "***N0TICE*** [yquake2-plus.sh] NOT FOUND!" --ok-label MENU --msgbox "CHECK INTERNET CONNECTION AND RETRY INSTALL/DOWNLOAD [yquake2-plus.sh]"  25 75
				mainMENU
			else
				mv /dev/shm/yquake2-plus.sh /opt/retropie/configs/ports/quake2/yquake2-plus.sh 2>/dev/null
				sudo chmod 755 /opt/retropie/configs/ports/quake2/yquake2-plus.sh 2>/dev/null
			fi
			
			# Add [yquake2+] to [emulators.cfg]
			cat /opt/retropie/configs/ports/quake2/emulators.cfg | grep -v 'yquake2-' | grep -v 'yquake2+' > /dev/shm/emulators.cfg
			echo "yquake2+ = \"/opt/retropie/configs/ports/quake2/yquake2-plus.sh %ROM% %XRES% %YRES%\"" >> /dev/shm/emulators.cfg
			echo "yquake2+deathmatch = \"/opt/retropie/configs/ports/quake2/yquake2-plus.sh %ROM% %XRES% %YRES% deathmatch\"" >> /dev/shm/emulators.cfg
			echo "yquake2+dedicatedserver = \"/opt/retropie/configs/ports/quake2/yquake2-plus.sh %ROM% %XRES% %YRES% server\"" >> /dev/shm/emulators.cfg
			if [ "$(cat /dev/shm/emulators.cfg | grep -q 'default =' ; echo $?)" == '1' ]; then echo "default = \"yquake2\"" >> /dev/shm/emulators.cfg; fi
			
			# Replace yquake2 [emulators.cfg]
			mv /dev/shm/emulators.cfg /opt/retropie/configs/ports/quake2/emulators.cfg 2>/dev/null
			
			# Configure [yquake2] as DEFAULT in [emulators.cfg]
			sed -i 's/default\ =.*/default\ =\ \"yquake2+\"/g' /opt/retropie/configs/ports/quake2/emulators.cfg
		fi
		dialog --no-collapse --title " INSTALL [yquake2+] Emulator for Yamagi Quake II FINISHED" --ok-label Back --msgbox "  CURRENT CONTENT [opt/retropie/configs/ports/quake2/emulators.cfg]:  $(cat /opt/retropie/configs/ports/quake2/emulators.cfg)"  25 75
		mainMENU
	fi
	mainMENU
fi

# REMOVE [yquake2+]
if [ "$confQ2plus" == '2' ]; then
	confREMOVEq2plus=$(dialog --no-collapse --title "               REMOVE [yquake2+] for RetroPie Yamagi Quake II              " \
		--ok-label OK --cancel-label BACK \
		--menu "                          ? ARE YOU SURE ?             " 25 75 20 \
		1 "><  YES REMOVE [yquake2+] for RetroPie Yamagi Quake II  ><" \
		2 "><  BACK  ><" 2>&1>/dev/tty)
	# Install Confirmed - Otherwise Back to Main Menu
	if [ "$confREMOVEq2plus" == '1' ]; then
		tput reset
		# yquake2 Config
		if [ -f /opt/retropie/configs/ports/quake2/emulators.cfg ]; then
			# Remove [yquake2-plus.sh]
			rm /opt/retropie/configs/ports/quake2/yquake2-plus.sh 2>/dev/null
			
			# Remove [yquake2+] from [emulators.cfg]
			cat /opt/retropie/configs/ports/quake2/emulators.cfg | grep -v 'yquake2-' | grep -v 'yquake2+' > /dev/shm/emulators.cfg
			if [ "$(cat /dev/shm/emulators.cfg | grep -q 'default =' ; echo $?)" == '1' ]; then echo "default = \"yquake2\"" >> /dev/shm/emulators.cfg; fi
			
			# Replace yquake2 [emulators.cfg]
			mv /dev/shm/emulators.cfg /opt/retropie/configs/ports/quake2/emulators.cfg 2>/dev/null
		fi
		dialog --no-collapse --title " REMOVE [yquake2+] for RetroPie Yamagi Quake II FINISHED" --ok-label Back --msgbox "  CURRENT CONTENT [opt/retropie/configs/ports/quake2/emulators.cfg]:  $(cat /opt/retropie/configs/ports/quake2/emulators.cfg)"  25 75
		mainMENU
	fi
	mainMENU
fi

# INSTALL [q2ctf]
if [ "$confQ2plus" == '3' ]; then
	confINSTALLq2ctf=$(dialog --no-collapse --title "     MAKE/INSTALL [Quake II Capture the Flag]        " \
		--ok-label OK --cancel-label BACK \
		--menu "                          ? ARE YOU SURE ?             \n                   https://github.com/yquake2/ctf          " 25 75 20 \
		1 "><  YES MAKE/INSTALL  [Quake II Capture the Flag]  ><" \
		2 "><  BACK  ><" 2>&1>/dev/tty)
	# Install Confirmed - Otherwise Back to Main Menu
	if [ "$confINSTALLq2ctf" == '1' ]; then
		tput reset
		if [ ! -d ~/RetroPie/roms/ports/quake2/ctf/ ]; then mkdir ~/RetroPie/roms/ports/quake2/ctf; fi
		cd /dev/shm/
		git clone --depth 1 https://github.com/yquake2/ctf.git
		cd ctf
		make
		mv /dev/shm/ctf/release/game.so ~/RetroPie/roms/ports/quake2/ctf/game.so
		cd ~
		rm /dev/shm/ctf/ -R -f
		
		LISTq2ctf150=$(
		echo "{$(ls ~/RetroPie/roms/ports/quake2/ctf/ | grep 'game.so')}"
		echo "$(ls ~/RetroPie/roms/ports/quake2/ctf/ | grep -v 'game.so')"
		)
		dialog --no-collapse --title " MAKE/INSTALL [Quake II Capture the Flag] FINISHED" --ok-label Back --msgbox "         CURRENT CONTENT [~/RetroPie/roms/ports/quake2/ctf/]:      $LISTq2ctf150"  25 75
		mainMENU
	fi
	mainMENU
fi

# REFERENCES
if [ "$confQ2plus" == 'R' ]; then	
	dialog --no-collapse --title " REFERENCES" --ok-label Back --msgbox "$ctfREFS $(cat /opt/retropie/configs/ports/quake2/emulators.cfg)"  25 75
	mainMENU
fi

# QUIT if N0T Confirmed
if [ "$confQ2plus" == '' ]; then
	tput reset
	exit 0
fi

tput reset
exit 0
}

mainMENU

tput reset
exit 0
