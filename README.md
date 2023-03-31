# yquake2-plus (yquake2+)  
![yquake2-plus.png](https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2-plus.png)  
[yquake2+] Emulator Entry allows you to add Extra Parameters (+map) to [Quake2.sh] Roms.  
Includes additional [yquake2+deathmatch] and [yquake2+dedicatedserver] Emulator Entries.  
*NOTE: [+map] and [server.cfg] Required for Dedicated Server Mode to load properly.*  
*When Installed this Utility will Auto-Create [server.cfg] when Not found and specify [+map]*  

**HOW DOES IT WORK?**  
By Default RetroPie passes the "%ROM%" String from a [Quake2.sh] to [yquake2] Emulator with "Double-Quotes".  
Using "Double-Quotes" does NOT Pass the Extra Parameters from a [Quake2.sh] (eg. +map) using Default [yquake2] Emulator.  

This Utility Regurgitates the %ROM% from a [Quake2.sh] ***withOUT "Double-Quotes"*** to an Additional Quake2 Emulator [yquake2+].  
This allows you to add Extra (+map) Parameters in a [Quake2.sh] withOUT needing to Create additional Emulator for each One.  

*Also Includes:*  
- Utility to Assist with Make/Install Quake II Capture the Flag [game.so] for Linux.  
- A Mechanism to Mirror Control Bindings from [baseq2/config.cfg] to Current [%ROM%/config.cfg] when NOT found.  
*NOTE: Set your Preferred Control Mappings in Quake2 [baseq2] 1st to have it Auto-Replicated to 0ther Quake2 [%ROM%/config.cfg].*  
*eg. "+moveup" "centerview" "+movedown" "+speed" "weapprev" "weapnext" "cmd help" "inven" "invprev" "invnext" "invdrop" "invuse" "+attack"*  

## INSTALLATION  
***You MUST INSTALL Yamagi Quake II from RetroPie Setup 1st! [yquake2]***  

If you want 1-Run-N-Done:
```bash
curl -sSL https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2_plus.sh  | bash
```

If you want to Put the Install Script in the retropiemenu [+Icon]:  
```bash
wget https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2_plus.sh -P ~/RetroPie/retropiemenu
wget https://raw.githubusercontent.com/RapidEdwin08/yquake2-plus/main/yquake2-plus.png -P ~/RetroPie/retropiemenu/icons
```

0ptionally you can Add an Entry [+Icon] to your retropiemenu [gamelist.xml]:  
*Example Entry:*  
```
	<game>
		<path>./yquake2_plus.sh</path>
		<name>[yquake2+] Yamagi Quake II Plus</name>
		<desc>Configure [yquake2+] for [RetroPie].</desc>
		<image>./icons/yquake2-plus.png</image>
	</game>
```

If you want to GIT it All:  
```bash
cd ~
git clone --depth 1 https://github.com/RapidEdwin08/yquake2-plus.git
sudo chmod 755 ~/yquake2-plus/yquake2_plus.sh
cd ~/yquake2-plus && ./yquake2_plus.sh

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
