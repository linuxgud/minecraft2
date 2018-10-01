#!/usr/bin/env python
import sys,json,urllib
url2=''
if len(sys.argv) != 2:
        print('usage: script.py <mcversion>')
        sys.exit(2)

data=json.loads(urllib.urlopen('https://launchermeta.mojang.com/mc/game/version_manifest.json').read())

for i in range (0,len(data['versions'])):
        if data['versions'][i]['id'] == sys.argv[1]:
                url2 = data['versions'][i]['url']
                break

if url2 == '':
        print('Error: verson not found.')
        sys.exit(2)

data=json.loads(urllib.urlopen(url2).read())
print(data['downloads']['server']['url'])

