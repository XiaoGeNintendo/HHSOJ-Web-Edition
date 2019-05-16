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
    print('Environment'.center(60,'-'))
    print('Linux Distrib: \t',platform.linux_distribution()[0],platform.linux_distribution()[1])
    print('Libc Verison:  \t',platform.libc_ver()[0],platform.libc_ver()[1])
    print('Python Version:\t',platform.python_version())
    print('Linux Release: \t',platform.release())
    print('Machine:       \t',platform.machine())
    print('End'.center(60,'-'))



# print in colors
def pred(s):
    exec("print('\033[31m%s\033[0m'%s,end='')")

def pgreen(s):
    exec("print('\033[32m%s\033[0m'%s,end='')")

def pblue(s):
    exec("print('\033[34m%s\033[0m'%s,end='')")



#progress bar
def progress(x,ed=''):
    exec("print('  %.2f%% [%s]  %s'%(100*x,'#'*int(x*60)+'-'*(60-int(x*60)),ed),end='\\r')")

#run linux bash
def runcmd(s):
    h=sub.Popen(s,stdout=sub.PIPE,stderr=sub.PIPE,shell=True)
    if DEBUG:
        print('START'.center(80,'-'))
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
        print('END'.center(80,'-'))
        print()
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
def wgetDownload(url,d):
    print('downloading from: %s'%url)
    res=runcmd('wget %s'%url)
    name=res[2].split('\u2019')
    name=name[len(name)-2]
    name=name.split('\u2018')
    name=name[len(name)-1]
    runcmd('mv %s %s'%(name,d))
    print('%s downloaded to %s'%(name,d))
    return name

def download(url,d,buf=1024):
    print('downloading: %s'%url)
    r=requests.get(url, stream=True)
    f=open(d, "wb")
    tot=int(r.headers['content-length'])
    cnt=0
    st=datetime.datetime.now()
    pv=[st]
    pvb=[0]
    for chunk in r.iter_content(chunk_size=buf):
        if chunk:
            f.write(chunk)
            cnt+=buf
            progress(cnt/tot,str((datetime.datetime.now()-pv[0])/(cnt-pvb[0])*(tot-cnt))[:-5])
            pv.append(datetime.datetime.now())
            pvb.append(cnt)
            if len(pv)>10: del(pv[0])
            if len(pvb)>10: del(pvb[0])
    
    f.close()
    progress(1,str((datetime.datetime.now()-pv[0])/(cnt-pvb[0])*(tot-cnt))[:-5])
    print()
    print('Time used: ',str(datetime.datetime.now()-st)[:-5])


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
    elif s=='python3-pip':
        aptInstall('python3-pip','python3 -m pip -V')
    else:
        aptInstall(s,s)



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



#tomcat config
def isNum(s):
    if len(s)>1 and s[0]=='0':
        return False
    return s.isnumeric()
    
def getPorts():
    if checkTomcat()==-1:
        return -1,-1,-1
    f=open('/usr/tomcat/conf/server.xml')
    s=f.read()
    f.close()
    i1=s.find('protocol="HTTP/1.1"')
    k1=i1-1
    while(s[k1]!='"'):k1-=1
    j1=k1-1
    while(s[j1]!='"'):j1-=1
    p1=s[j1+1:k1]

    i2=s.find('protocol="AJP/1.3"')
    k2=i2-1
    while(s[k2]!='"'):k2-=1
    j2=k2-1
    while(s[j2]!='"'):j2-=1
    p2=s[j2+1:k2]

    i3=s.find('shutdown="SHUTDOWN"')
    k3=i3-1
    while(s[k3]!='"'):k3-=1
    j3=k3-1
    while(s[j3]!='"'):j3-=1
    p3=s[j3+1:k3]

    n1=-1
    n2=-1
    n3=-1
    if isNum(p1):
       n1=int(p1)
    if isNum(p2):
       n2=int(p2)
    if isNum(p1):
       n3=int(p3) 
    
    return n1,n2,n3


def setPorts(p1,p2,p3):
    if checkTomcat()==-1:
        return False
    chk=getPorts()
    f=open('/usr/tomcat/conf/server.xml')
    s=f.read()
    f.close()

    if chk[0]!=-1:
        i1=s.find('protocol="HTTP/1.1"')
        k1=i1-1
        while(s[k1]!='"'):k1-=1
        j1=k1-1
        while(s[j1]!='"'):j1-=1
        s=s.replace(s[j1:i1]+'protocol="HTTP/1.1"','"%d" protocol="HTTP/1.1"'%p1)

    if chk[1]!=0:
        i2=s.find('protocol="AJP/1.3"')
        k2=i2-1
        while(s[k2]!='"'):k2-=1
        j2=k2-1
        while(s[j2]!='"'):j2-=1
        s=s.replace(s[j2:i2]+'protocol="AJP/1.3"','"%d" protocol="AJP/1.3"'%p2)

    if chk[2]!=0:
        i3=s.find('shutdown="SHUTDOWN"')
        k3=i3-1
        while(s[k3]!='"'):k3-=1
        j3=k3-1
        while(s[j3]!='"'):j3-=1
        s=s.replace(s[j3:i3]+'shutdown="SHUTDOWN"','"%d" shutdown="SHUTDOWN"'%p3)

    f=open('/usr/tomcat/conf/server.xml','w')
    f.write(s)
    f.close()



#check all parts!
def checkAll():
    print('Checking required parts...')
    
    JDK_VER=checkJavac()
    JAVA_VER=checkJava()
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
                    install(i[0])
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
    l=[('wget','wget -V'),
       ('tar','tar --version'),
       ('unzip','unzip -version'),
       ('python3-pip','python3 -m pip -V')]
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
pgreen('----====HHSOJ Control Script====----'.center(80))
print()
print('by Zzzyt,'.center(80))
print('HellHole Studios 2019'.center(80))
print()
print('Operations:')

ol=['Check','Upgrade OJ','Config','Run Status']
for i in range(len(ol)):
    pgreen('[%d]'%(i+1))
    print(ol[i])
o=input('Operation Nubmer:')
if o=='1':
    #Check Parts
    utilInstallAll()
    pipInstallAll()
    checkAll()
elif o=='2':
    #Upgrade OJ
    pipInstall('requests')
    import requests
    import datetime
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
    #Configs
    pred('UNDER CONSTRUCTION\n')
    tp=getPorts()
    print('Tomcat Configs'.center(50,'-'))
    if tp[0]!=-1:
        print('HTTP Port:%d'%tp[0])
    else:
        pred('HTTP Port not found\n')
    if tp[1]!=-1:
        print('AJP Port:%d'%tp[1])
    else:
        pred('AJP Port not found\n')
    if tp[1]!=-1:
        print('Shutdown Port:%d'%tp[1])
    else:
        pred('Shutdown Port not found\n')
    print('-'*50)
elif o=='4':
    #Server Status
    pred('UNDER CONSTRUCTION\n')
else:
    print('Exit...')
    exit(0)


