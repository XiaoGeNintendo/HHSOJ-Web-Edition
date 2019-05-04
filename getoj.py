#!/usr/bin/python
# -*- coding: UTF-8 -*-
#import modules
import sys
import os
import platform
import subprocess as sub

if platform.python_version().startswith('2'):
    exec('print "\033[31mDon\'t use Python 2\\nTrying to start Python 3\033[0m"')
    c='python3'
    for i in sys.argv:
        c+=' '+i
    res=os.system(c)
    if res==32512:
        exec('print "\033[31mFailed to start python3.Install One?\\n\033[0m"')
        r=raw_input('[Y/n]')
        if r=='Y' or r=='y' or r=='':
            if platform.dist()[0]=='Centos':
                os.system('yum install python3')
            else:
                os.system('apt-get install python3')
        res2=os.system('python3 '+sys.argv[0])
        if res2==32512:
            exec('print "\033[31mFailed.\n\033[0m"')
            
    exit(0)


DEBUG=False
if len(sys.argv)>1 and sys.argv[1]=='--debug':
    DEBUG=True

# Must be linux!!!
if platform.system()!='Linux':
    print('This script is only designed for Linux!')
    if not DEBUG:
        exit(0)



if DEBUG:
    print('--------------------Environment--------------------')
    print('Linux Distrib: \t',platform.linux_distribution()[0],platform.linux_distribution()[1])
    print('Libc Verison:  \t',platform.libc_ver()[0],platform.libc_ver()[1])
    print('Python Version:\t',platform.python_version())
    print('Linux Release: \t',platform.release())
    print('Machine:       \t',platform.machine())
    print('-------------------------End-----------------------')



# print in colors
def pred(s):
    exec("print('\033[31m%s\033[0m'%s,end='')")

def pgreen(s):
    exec("print('\033[32m%s\033[0m'%s,end='')")

def pblue(s):
    exec("print('\033[34m%s\033[0m'%s,end='')")



#run linux bash
def runcmd(s):
    h=sub.Popen(s,stdout=sub.PIPE,stderr=sub.PIPE,shell=True)
    if DEBUG:
        print('------------------------START------------------------')
        print('Command: '+s)
        sout=''
        serr=''
        while h.poll()==None:
            lo=str(h.stdout.readline(),encoding='utf-8')
            le=str(h.stderr.readline(),encoding='utf-8')
            if lo!='':
                print('\t'+lo)
                sout+=lo+'\n'
            if le!='':
                print('\t'+le)
                serr+=le+'\n'
        print('-------------------------END-------------------------\n')
    else:
        h.wait()
        sout=str(h.stdout.read(),encoding='utf-8')
        serr=str(h.stderr.read(),encoding='utf-8')
    return h.returncode,sout,serr

#apt/yum install
def aptInstall(s,chk):
    if platform.dist()[0]=='Centos':
        print('Installing %s with yum'%s)
        runcmd('yum install '+s)
    else:
        print('Installing %s with apt'%s)
        runcmd('apt-get install '+s)
    if runcmd(chk)[0]!=0:
        pred('[ER]%s install failed\n'%s)

def utilCheck(chk):
    res=runcmd(chk)
    if res[0]!=0:
        return False
    return True



#pip install
def pipCheck(s):
    try:
        exec('import '+s)
    except ModuleNotFoundError:
        return False
    return True
        
def pipInstall(s):
    if pipCheck(s):
        return True
    print('Installing %s with pip'%s)
    runcmd('python3 -m pip install '+s)
    if pipCheck(s):
        return True
    pred('[ER]Module %s install failed\n'%s)
    return False





#download
def download(url,d):
    print('downloading from: %s'%url)
    res=runcmd('wget %s'%url)
    name=res[2].split('\u2019')
    name=name[len(name)-2]
    name=name.split('\u2018')
    name=name[len(name)-1]
    runcmd('mv %s %s'%(name,d))
    print('%s downloaded to %s'%(name,d))
    return name


#install tomcat
def installTomcat():
    download('http://apache.01link.hk/tomcat/tomcat-9/v9.0.19/bin/apache-tomcat-9.0.19.tar.gz','/usr/tomcat.tar.gz')
    runcmd('tar zxvf /usr/tomcat.tar.gz -C /usr/')
    runcmd('rm -f /usr/tomcat.tar.gz')
    runcmd('mv /usr/apache-tomcat-9.0.19/ /usr/tomcat/')

#version fetcher
def getWarURL():
    r=requests.get('https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/latest')
    ver=r.url.split('/')
    ver=ver[len(ver)-1]
    return ver,'https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/%s/HellOJ.war'%ver

def getFolderURL():
    t=requests.get('https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/').text
    i=t.find('hhsoj.zip')
    j=i-2
    while t[j]!='/': j-=1
    ver=t[j+1:i-1]
    return ver,'https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/%s/hhsoj.zip'%ver


#install HHSOJ webapp
def installWebapp():
    res=getWarURL()
    print('Installing HHSOJ web app version %s'%res[0])
    download(res[1],'/usr/tomcat/webapps/ROOT.war')
    runcmd('rm -rf /usr/tomcat/webapps/ROOT/')
    pblue('Note: Need to run tomcat to unpack the file.\n')

#install hhsoj folder
def installFolder():
    res=getFolderURL()
    print('Installing HHSOJ data folder version %s'%res[0])
    download(res[1],'/usr/hhsoj.zip')
    runcmd('rm -rf /usr/hhsoj/')
    runcmd('unzip /usr/hhsoj.zip -d /usr/')
    runcmd('rm -f /usr/hhsoj.zip')

#general install
def install(s):
    if s=='folder':
        installFolder()
    elif s=='hhsoj':
        installWebapp()
    elif s=='tomcat':
        installTomcat()
    else:
        aptInstall(s)



#check requirements
#java
def checkJava():
    res=runcmd('java -version')
    if res[0]!=0:
        return -1
    else:
        return res[2].split('"')[1]
#javac
def checkJavac():
    res=runcmd('javac -version')
    if res[0]!=0:
        return -1
    else:
        return res[2].split(' ')[1].replace('\n','')
#pip
def checkPip():
    res=runcmd('python3 -m pip -V')
    if res[0]!=0:
        return -1
    else:
        return res[1].split(' ')[1]
#g++
def checkGpp():
    res=runcmd('g++ --version')
    if res[0]!=0:
        return -1
    else:
        return res[1].split(')')[1].replace(' ','').split('\n')[0]
#tomcat
def checkTomcat():
    if os.path.exists('/usr/tomcat/RELEASE-NOTES'):
        f=open('/usr/tomcat/RELEASE-NOTES')
        tmp=f.read().split('Apache Tomcat Version ')
        f.close()
        if len(tmp)<2:
            return 'Unknown'
        else:
            return tmp[1].split(' ')[0].replace('\n','')
    else:
        return -1
#HHSOJ webapp
def checkWebapp():
    if checkTomcat()==-1:
        return -1
    if os.path.exists('/usr/tomcat/webapps/ROOT/index.jsp') or os.path.exists('/usr/tomcat/webapps/ROOT.war'):
        return 'Unknown'
    else:
        return -1
#hhsoj folder
def checkFolder():
    if os.path.exists('/usr/hhsoj'):
        return 'Unknown'
    else:
        return -1




#check all parts!
def checkAll():
    print('Checking required parts...')
    
    JDK_VER=checkJavac()
    JAVA_VER=checkJava()
    PIP_VER=checkPip()
    GPP_VER=checkGpp()
    TOMCAT_VER=checkTomcat()
    HHSOJ_VER=checkWebapp()
    FOLDER_VER=checkFolder()
    
    unin=[]
    if JDK_VER==-1:
        pred('[ER]JDK is not installed!\n')
        unin.append(('openjdk-8-jdk','JDK 8'))
    else:   
        pgreen('[OK]')
        print('JDK version='+JDK_VER)
    if JAVA_VER==-1:
        pred('[ER]Java is not installed!\n')
        if unin.count(('openjdk-8-jdk','JDK 8'))==0:
            unin.append(('openjdk-8-jdk','JDK 8'))
    else:
        pgreen('[OK]')
        print('Java version='+JAVA_VER)
    if PIP_VER==-1:
        pred('[ER]Python pip is not installed!\n')
        unin.append(('python3-pip','Python pip'))
    else:
        pgreen('[OK]')
        print('pip version='+PIP_VER)
    if GPP_VER==-1:
        pred('[ER]G++ is not installed!\n')
        unin.append(('gcc-g++','G++'))
    else:
        pgreen('[OK]')
        print('G++ version='+GPP_VER)
    if TOMCAT_VER==-1:
        pred('[ER]Apache Tomcat is not installed!\n')
        unin.append(('tomcat','Apache Tomcat'))
    else:
        pgreen('[OK]')
        print('Tomcat version='+TOMCAT_VER)
    if HHSOJ_VER==-1:
        pred('[ER]HHSOJ web app is not installed!\n')
        unin.append(('hhsoj','HHSOJ web app'))
    else:
        pgreen('[OK]')
        print('HHSOJ web app version='+HHSOJ_VER)
    if FOLDER_VER==-1:
        pred('[ER]HHSOJ data folder is not installed!\n')
        unin.append(('folder','HHSOJ data folder'))
    else:
        pgreen('[OK]')
        print('HHSOJ data folder version='+FOLDER_VER)
    
    if len(unin)>0:
        print('Install all uninstalled parts?')
        res=input('[Y/n]')
        if res=='' or res=='y' or res=='Y':
            for i in unin:
                install(i[0])
        else:
            print('Install one by one?')
            res2=input('[y/N]')
            if res2=='' or res2=='n' or res2=='N':
                return
            for i in unin:
                print('Install %s?'%i[1])
                res3=input('[Y/n]')
                if res3=='' or res3=='y' or res3=='Y':
                    pipInstall(i[0])
    else:
        print('All required parts installed!')



#install all nodules
def pipInstallAll():
    l=['requests','robobrowser']
    unin=[]
    for i in l:
        if not pipCheck(i):
            unin.append(i)
            pred('[ER]Module %s not Installed!\n'%i)
        else:
            pgreen('[OK]')
            print('Module %s installed'%i)
    
    if len(unin)>0:
        print('Install all uninstalled modules?')
        res=input('[Y/n]')
        if res=='' or res=='y' or res=='Y':
            for i in unin:
                pipInstall(i)
        else:
            print('Install one by one?')
            res2=input('[y/N]')
            if res2=='' or res2=='n' or res2=='N':
                return
            for i in unin:
                print('Install %s?'%i)
                res3=input('[Y/n]')
                if res3=='' or res3=='y' or res3=='Y':
                    pipInstall(i)
    else:
        print('All required modules installed!')



#install all utils
def utilInstallAll():
    l=[('wget','wget -V'),('tar','tar --version'),('unzip','unzip -version')]
    unin=[]
    for i in l:
        if not utilCheck(i[1]):
            unin.append(i)
            pred('[ER]Util %s not Installed!\n'%i[0])
        else:
            pgreen('[OK]')
            print('Util %s installed'%i[0])
    
    if len(unin)>0:
        print('Install all uninstalled utils?')
        res=input('[Y/n]')
        if res=='' or res=='y' or res=='Y':
            for i in unin:
                aptInstall(i[0],i[1])
        else:
            print('Install one by one?')
            res2=input('[y/N]')
            if res2=='' or res2=='n' or res2=='N':
                return
            for i in unin:
                print('Install %s?'%i[0])
                res3=input('[Y/n]')
                if res3=='' or res3=='y' or res3=='Y':
                    aptInstall(i[0],i[1])
    else:
        print('All required utils installed!')





# RUN AREA!!
pgreen('    ----====HHSOJ Control Script====----    \n')
print ('                 by Zzzyt,                    ')
print ('            HellHole Studios 2019             ')
print()
print('Operations:')

ol=['Check','Upgrade','Config','Run Status']
for i in range(len(ol)):
    pgreen('[%d]'%(i+1))
    print(ol[i])
o=input('Operation Nubmer:')
if o=='1':
    utilInstallAll()
    pipInstallAll()
    checkAll()
elif o=='2':
    import requests
    v1=getWarURL()
    v2=getFolderURL()
    print('Latest HHSOJ web app version: '+v1[0])
    print('Latest HHSOJ data folder version: '+v2[0])
    r1=input('Install web app?[Y/n]')
    if r1=='' or r1=='Y' or r1=='y':
        installWebapp()
    
    r2=input('Install data folder?[Y/n]')
    if r1=='' or r1=='Y' or r1=='y':
        installFolder()

elif o=='3':
    pred('UNDER CONSTRUCTION\n')
elif o=='4':
    pred('UNDER CONSTRUCTION\n')
    os.system('lsof -i:8005')
else:
    print('Exit...')
    exit(0)


