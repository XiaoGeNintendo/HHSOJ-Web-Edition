#!/usr/bin/python
# -*- coding: UTF-8 -*-
#import modules
import sys
import os
import platform
import subprocess as sub

if platform.python_version().startswith('2'):
    exec('print "\033[31mDon\'t use Python 2\\nTrying to start Python 3\033[0m"')
    os.system('python3 '+sys.argv[0])
    exit()

# Must be linux!!!
if platform.system()!='Linux':
    print('This script is only designed for Linux!')
    if not DEBUG:
        exit()

DEBUG=True;

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

def utilInstall(s,chk):
    res=runcmd(chk)
    if res[0]!=0:
        pred('[ER]%s is not installed\n'%s)
        aptInstall(s,chk)

def utilInstallAll():
    l=[('wget','wget -V'),('tar','tar --version'),('unzip','unzip -version')]
    for i in l:
        utilInstall(i[0],i[1])

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
    runcmd('pip install '+s)
    if pipCheck(s):
        return True
    pred('[ER]Module %s install failed\n'%s)
    return False

def pipInstallAll():
    l=['requests','robobrowser']
    for i in l:
        pipInstall(i)



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
    res=runcmd('pip -V')
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
        unin.append(('python-pip','Python pip'))
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
            for i in unin:
                print('Install %s?'%i[1])
                res2=input('[Y/n]')
                if res=='' or res=='y' or res=='Y':
                    install(i[0])
    else:
        print('All required parts installed!')



# TEST AREA!!!
pipInstallAll()
import requests

utilInstallAll()
checkAll()
