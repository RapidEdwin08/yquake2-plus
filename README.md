# yquake2-plus (yquake2+)  
![yquake2-plus.png](https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2-plus.png)  
[yquake2+] Emulator Entry allows you to add Extra Parameters (+map) to [Quake2.sh] Roms.  
Includes additional [yquake2+deathmatch] and [yquake2+dedicatedserver] Emulator Entries.  
*NOTE: [+map] and [server.cfg] Required for Dedicated Server Mode to load properly.*  

*Also Includes:*  
- Utility to Assist with Make/Install Quake II Capture the Flag [game.so] for Linux.  
- A Mechanism that will Copy/Paste [config.cfg] from Main Quake2 [baseq2] to Current %ROM% [config.cfg] if not found.  
*NOTE: Set your Preferred Control Mappings in Quake2 [baseq2] 1st to be Replicated to 0ther Quake2 %ROM% [config.cfg].*  


**HOW DOES IT WORK?**  
RetroPie passes the "%ROM%" String from a [Quake2.sh] to [yquake2] Emulator with "Double-Quotes".  
Using "Double-Quotes" does NOT Pass the Extra Parameters from a [Quake2.sh] (eg. +map) using Default [yquake2] Emulator.  

This Utility Regurgitates the %ROM% from a [Quake2.sh] ***withOUT "Double-Quotes"*** to an Additional Quake2 Emulator [yquake2+].  
This allows you to add Extra (+map) Parameters in a [Quake2.sh] withOUT needing to Create additional Emulator for each One.  

## INSTALLATION  
***You MUST INSTALL Yamagi Quake II from RetroPie Setup 1st! [yquake2]***  


Can be ran from retropiemenu:  

```bash
wget https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2_plus.sh -P ~/RetroPie/retropiemenu
wget https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2-plus.png -P ~/RetroPie/retropiemenu/icons
```

0R Run Manually from any directory:  
```bash
cd ~
git clone --depth 1 https://github.com/RapidEdwin08/yquake2-plus.git
sudo chmod 755 ~/yquake2-plus/yquake2_plus.sh
cd ~/yquake2-plus && ./yquake2_plus.sh
```

0ptionally you can Add an Entry and Icon to your retropiemenu [gamelist.xml]:  
*Example Entry:*  
```
	<game>
		<path>./yquake2_plus.sh</path>
		<name>[yquake2+] Yamagi Quake II Plus</name>
		<desc>INSTALL/REMOVE [yquake2+] for [RetroPie].</desc>
		<image>./icons/yquake2-plus.png</image>
	</game>
```

## REFERENCES   

***[Quake II Capture the Flag]:***  

1) DOWNLOAD Quake II Capture the Flag [q2ctf150.zip] FILES HERE:  
[www.doomworld.com/idgames/idstuff/quake2/ctf/q2ctf150](https://www.doomworld.com/idgames/idstuff/quake2/ctf/q2ctf150)  

2) EXTRACT CONTENTS OF [q2ctf150.zip] FILES INTO:  
~/RetroPie/roms/ports/quake2/ctf/  

3) MAKE/INSTALL CTF [game.so] FOR LINUX: ***(Or use Utility Script)***  
```bash
cd ~
git clone --depth 1 https://github.com/yquake2/ctf.git
cd ctf
make
mv ~/ctf/release/game.so ~/RetroPie/roms/ports/quake2/ctf/
```

***EXAMPLE [yquake2-plus.sh] ROM SCRIPTs:***  
_PORT_ "quake2" "q2dme1m1 +map q2dme1m1"  
_PORT_ "quake2" "baseq2 +map q2dm1"  
_PORT_ "quake2" "ctf +map q2ctf1"  

***Additional Emulator Entries for RetroPie Yamagi Quake II***  
[yquake2+]: %ROM% with "Double-Quotes" Removed  
[yquake2+deathmatch]: %ROM% +set deathmatch 1  
[yquake2+dedicatedserver]: %ROM% +set dedicated 1 +exec server.cfg  

***SOURCES:***  
[https://github.com/yquake2/ctf](https://github.com/yquake2/ctf)  
[www.doomworld.com/idgames/idstuff/quake2/ctf/q2ctf150](https://www.doomworld.com/idgames/idstuff/quake2/ctf/q2ctf150)  
