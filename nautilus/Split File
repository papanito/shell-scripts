#!/usr/bin/python
#Writed by saeed.gnu@gmail.com
#Under the GNU GPL (v2.0 or later)
#This program is a simple GUI for spliting a file into many files (with certain size).

import sys, os

def split(fpath, bytes):
  os.popen('split "%s" -d -b "%s"'%(fpath, bytes))

if len(sys.argv)>1:
  inputFiles = sys.argv[1:]
else:
  inf = os.popen('zenity --title "split file" --entry --text "Path of input file:" --entry-text "" --width 327 --height 112').read()[:-1]
  if inf=='':
    sys.exit(0)
  inputFiles=[inf]



size = os.popen('zenity --title "split file" --entry --text "Size of output files:" --entry-text "1 M" "1 K" "10 K" "100 K" "1 M" "10 M" "100 M" "1 G" "10 G" "100 G" "1 T" --width 327 --height 112').read()[:-1]
print 'size="%s"'%size
if size=='':
  sys.exit(0)

#while size[-1] in (' ','\n'):
#  size=size[:-1]
size = size.replace(' ','').replace('\n','')
unit=1
if len(size)<2:
  sizeNum = size
elif size[-2:] in ('KB'):
  unit = 1024
  sizeNum = size[:-2]
elif size[-2:] in ('MB'):
  unit = 1024**2
  sizeNum = size[:-2]
elif size[-2:] in ('GB'):
  unit = 1024**3
  sizeNum = size[:-2]
elif size[-2:] in ('TB'):
  unit = 1024**4
  sizeNum = size[:-2]
elif size[-1] in ('B'):
  unit = 1
  sizeNum = size[:-1]
elif size[-1] in ('K'):
  unit = 1024
  sizeNum = size[:-1]
elif size[-1] in ('M'):
  unit = 1024**2
  sizeNum = size[:-1]
elif size[-1] in ('G'):
  unit = 1024**3
  sizeNum = size[:-1]
elif size[-1] in ('T'):
  unit = 1024**4
  sizeNum = size[:-1]
else:
  sizeNum = size

try:
  bytes=float(sizeNum)
except:
  os.popen('zenity --error "Invalid size %s"'%size)
bytes = str(int(bytes*unit))

#file('args','w').write(str(sys.argv))
initPwd=os.getcwd()
for arg in inputFiles:
  if not os.path.isfile(arg):
    os.popen('zenity --error "File %s not exists (or is not a file)"'%arg)
    continue
  if arg[0]=='/':
    fpath=arg
  else:
    fpath=os.getcwd()+'/'+arg
  fname = os.path.split(fpath)[-1]
  home=os.getenv('HOME')
  tmpDir=fpath+'-split-'+size
  if os.path.isfile(tmpDir):
    pass
  elif os.path.isdir(tmpDir):
    os.popen('rm -R "%s/*"'%tmpDir)
    if len(os.listdir(tmpDir))>0:
      #could not remove contents of existing directory (tmpDir)
      tmpDir=home+'/'+fname+'-split-'+size
      os.mkdir(tmpDir)
  else:
    try:
      os.mkdir(tmpDir)
    except:
      tmpDir=home+'/'+fname+'-split-'+size
      os.mkdir(tmpDir)
  os.chdir(tmpDir)
  split(fpath, bytes)
  for f in os.listdir(tmpDir):
    os.rename(f, fname+'-'+f[1:])
  os.chdir(initPwd)



