#!/usr/bin/env python3

import os
import sys

pkgs = []
for file in os.listdir('.'):
    if os.path.isdir(os.path.join(os.path.abspath('.'), file)):
        pkgs.append(file)

pkgs.remove('out')

if('--chroot' in sys.argv):
    print('only building chroot packages!')
    pkgs = ['bash', 'binutils', 'glibc', 'libcap', 'linux', 'openssl', 'gcc', 'ncurses', 'make']

for built in os.listdir('./out'):
    if(built != '.gitkeep' and built != '.git'):
        print('already built ' + built[:-5] + '. removing from queue!')
        pkgs.remove(built[:-5])

for pkg in pkgs:
    os.chdir(pkg)
    os.system('sh ./build.sh')
    os.chdir('../')