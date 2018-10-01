#!/usr/bin/env python
import os,sys,json,urllib

if os.geteuid()!=0:
        print("Run as root")
        sys.exit(2)

if not os.path.exists('/etc/facter/facts.d'):
        os.makedirs('/etc/facter/facts.d')

data=json.loads(urllib.urlopen('https://launchermeta.mojang.com/mc/game/version_manifest.json').read())

mcfile=open('/etc/facter/facts.d/minecraft.txt','w')
mcfile.write("minecraft_latest_version=%s\r\n" % data['latest']['release'])
mcfile.close()

