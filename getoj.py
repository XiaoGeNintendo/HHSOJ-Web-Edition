#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import sys
import os
import platform
import subprocess as sub
import re
import datetime

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

SHELLW=os.get_terminal_size()[0]
SHELLH=os.get_terminal_size()[1]
CSIZE=min(80,SHELLW)
SEP=os.linesep

ISCENTOS=False
if os.path.exists('/etc/redhat_release'):
    with open('/etc/redhat_release') as f:
        s=f.read()
        if s.lower().count('centos')!=0:
            ISCENTOS=True


if ISCENTOS:
    pyellow('WARNING:This script is not designed for Centos.\n')
    pyellow('Installing may not funciton.\n')

# print in colors
def pred(s):
    exec("print('\033[31m%s\033[0m'%s,end='')")

def pgreen(s):
    exec("print('\033[32m%s\033[0m'%s,end='')")

def pyellow(s):
    exec("print('\033[33m%s\033[0m'%s,end='')")

def debug(s):
    pyellow(s)
    #exec("print('\033[2m%s\033[0m'%s,end='')")


#selector
def Yes(s):
    return s=='' or s=='Y' or s=='y'

def No(s):
    return s=='' or s=='N' or s=='n'


#debug environment
if DEBUG:
    debug('Environment'.center(CSIZE-20,'-')+'\n')
    debug('Linux Distrib: \t'+platform.linux_distribution()[0]+' '+platform.linux_distribution()[1]+'\n')
    debug('Libc Verison:  \t'+platform.libc_ver()[0]+' '+platform.libc_ver()[1]+'\n')
    debug('Python Version:\t'+platform.python_version()+'\n')
    debug('Linux Release: \t'+platform.release()+'\n')
    debug('Machine:       \t'+platform.machine()+'\n')
    debug('End'.center(CSIZE-20,'-')+'\n')


#progress bar
def progress(x,ed=''):
    exec("print('  %.2f%% [%s]  %s'%(100*x,'#'*int(x*60)+'-'*(60-int(x*60)),ed),end='\\r')")

#run linux bash
def cmd(s):
    h=sub.Popen(s,stdout=sub.PIPE,stderr=sub.PIPE,shell=True)
    if DEBUG:
        debug('--- Command: %s '%s)
        debug((CSIZE-len('--- Command: %s '%s))*'-'+'\n')
        sout=''
        serr=''
        while True:
            lo=str(h.stdout.readline(),encoding='utf-8')
            le=str(h.stderr.readline(),encoding='utf-8')
            if lo!='':
                debug(lo)
                sout+=lo
            if le!='':
                debug(le)
                serr+=le
            h.stdout.flush()
            h.stderr.flush()
            if h.poll()!=None and lo=='' and le=='':
                break
        print()
    else:
        h.wait()
        sout=str(h.stdout.read(),encoding='utf-8')
        serr=str(h.stderr.read(),encoding='utf-8')
    return h.returncode,sout,serr

#apt/yum install
def aptInstall(s,chk):
    if ISCENTOS:
        print('Installing %s with yum'%s)
        cmd('yum install '+s)
    else:
        print('Installing %s with apt'%s)
        cmd('apt-get install '+s)
    if cmd(chk)[0]!=0:
        pred('[ER]%s install failed\n'%s)

def utilCheck(chk):
    res=cmd(chk)
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
    cmd('python3 -m pip install '+s)
    if pipCheck(s):
        return True
    pred('[ER]Module %s install failed\n'%s)
    return False





#download
def wgetDownload(url,d):
    print('downloading from: %s'%url)
    res=cmd('wget %s'%url)
    name=res[2].split('\u2019')
    name=name[len(name)-2]
    name=name.split('\u2018')
    name=name[len(name)-1]
    cmd('mv %s %s'%(name,d))
    print('%s downloaded to %s'%(name,d))
    return name

def download(url,d,buf=1024):
    if os.path.exists(d):
        cmd('rm -f '+d)
    
    pipInstall('requests')
    import requests
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
    cmd('tar zxvf /usr/tomcat.tar.gz -C /usr/')
    cmd('rm -f /usr/tomcat.tar.gz')
    cmd('mv /usr/apache-tomcat-9.0.19/ /usr/tomcat/')

#version fetcher
def getWarURL():
    pipInstall('requests')
    import requests
    
    t=requests.get('https://api.github.com/repos/XiaoGeNintendo/HHSOJ-Web-Edition/releases').text
    url=re.search('"https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/.{1,10}/.{1,20}.war"',t).group(0)[1:-1]
    ver=url.split('/')
    ver=ver[len(ver)-2]
    return ver,url

def getFolderURL():
    pipInstall('requests')
    import requests
    
    t=requests.get('https://api.github.com/repos/XiaoGeNintendo/HHSOJ-Web-Edition/releases').text
    url=re.search('"https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/.{1,10}/hhsoj.zip"',t).group(0)[1:-1]
    ver=url.split('/')
    ver=ver[len(ver)-2]
    return ver,url


#install HHSOJ webapp
def installWebapp():
    pipInstall('requests')
    import requests
    
    res=getWarURL()
    print('Installing HHSOJ web app version %s'%res[0])
    download(res[1],'/usr/tomcat/webapps/ROOT.war')
    cmd('rm -rf /usr/tomcat/webapps/ROOT/')
    pyellow('Note: Need to run tomcat to unpack the file.\n')

#install hhsoj folder
def installFolder():
    pipInstall('requests')
    import requests
    
    res=getFolderURL()
    print('Installing HHSOJ data folder version %s'%res[0])
    download(res[1],'/usr/hhsoj.zip')

def coverFolder():
    cmd('rm -rf /usr/hhsoj/')
    cmd('unzip /usr/hhsoj.zip -d /usr/')
    cmd('rm -f /usr/hhsoj.zip')
    
def mergeFolder():
    if not os.path.exists('/usr/hhsoj/'):
        coverFolder()
        return
    cmd('rm -rf /usr/hhsoj_merge/')
    cmd('mv /usr/hhsoj /usr/hhsoj_merge')
    cmd('unzip /usr/hhsoj.zip -d /usr/')
    cmd('rm -f /usr/hhsoj.zip')
    
    cmd('rm -rf /usr/hhsoj/users/')
    cmd('rm -rf /usr/hhsoj/submission/')
    cmd('rm -rf /usr/hhsoj/blog/')
    cmd('rm -f /usr/hhsoj/announcement.txt')
    cmd('rm -f /usr/hhsoj/config.json')
    
    cmd('cp -rf /usr/hhsoj_merge/users/ /usr/hhsoj/users/')
    cmd('cp -rf /usr/hhsoj_merge/submission/ /usr/hhsoj/submission/')
    cmd('cp -rf /usr/hhsoj_merge/blog/ /usr/hhsoj/blog/')
    cmd('cp -f /usr/hhsoj_merge/announcement.txt /usr/hhsoj/announcement.txt')
    cmd('cp -f /usr/hhsoj_merge/config.json /usr/hhsoj/config.json')
    
    cmd('rm -rf /usr/hhsoj_merge')

#backup
def backupFolder():
    if not os.path.exists('/usr/hhsoj'):
        return False
    from datetime import datetime
    s='/usr/hhsoj_backup_'+datetime.now().strftime('%F')
    if os.path.exists(s+'.tar.gz'):
        i=1
        while os.path.exists(s+'_'+str(i)+'.tar.gz'):
            i+=1
        s=s+'_'+str(i)
    cmd('tar czf %s.tar.gz hhsoj/'%s)
    return s+'.tar.gz'


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
    res=cmd('java -version')
    if res[0]!=0:
        return -1
    else:
        return res[2].split('"')[1]
#javac
def checkJavac():
    res=cmd('javac -version')
    if res[0]!=0:
        return -1
    else:
        return res[2].split(' ')[1].replace('\n','')
#pip
def checkPip():
    res=cmd('python3 -m pip -V')
    if res[0]!=0:
        return -1
    else:
        return res[1].split(' ')[1]
#g++
def checkGpp():
    res=cmd('g++ --version')
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

#XML
def XMLgetPorts():
    if checkTomcat()==-1:
        return -1,-1,-1
    
    import xml.dom as dom
    import xml.dom.minidom as minidom
    
    p1=''
    p2=''
    p3=''
    
    server=minidom.parse('/usr/tomcat/conf/server.xml').documentElement
    if server.hasAttribute('port'):
        p3=server.getAttribute('port')
    
    service=server.getElementsByTagName('Service')
    catalina=None
    for i in service:
        if i.hasAttribute('name') and i.getAttribute('name')=='Catalina':
            catalina=i
            break
    if catalina==None:
        return -1,-1,-1
    for i in catalina.childNodes:
        if i.nodeType==dom.Node.ELEMENT_NODE and i.nodeName=='Connector':
            if not i.hasAttribute('protocol'):
                continue
            if not i.hasAttribute('port'):
                continue
            tmp=i.getAttribute('protocol')
            port=i.getAttribute('port')
            if tmp=='HTTP/1.1':
                p1=port
            elif tmp=='AJP/1.3':
                p2=port
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

def XMLsetPorts(p1,p2,p3):
    if checkTomcat()==-1:
        return False
    
    import xml.dom as dom
    import xml.dom.minidom as minidom

    r1=False
    r2=False
    r3=False

    rot=minidom.parse('/usr/tomcat/conf/server.xml')
    server=rot.documentElement
    if server.hasAttribute('port'):
        if p3!=-1:
            server.setAttribute('port',str(p3))
            r3=True
    
    service=server.getElementsByTagName('Service')
    catalina=None
    for i in service:
        if i.hasAttribute('name') and i.getAttribute('name')=='Catalina':
            catalina=i
            break
        
    if catalina==None:
        return r1,False,False
    
    for i in catalina.childNodes:
        if i.nodeType==dom.Node.ELEMENT_NODE and i.nodeName=='Connector':
            if not i.hasAttribute('protocol'):
                continue
            if not i.hasAttribute('port'):
                continue
            tmp=i.getAttribute('protocol')
            if tmp=='HTTP/1.1':
                if p1!=-1:
                    i.setAttribute('port',str(p1))
                    r1=True
            elif tmp=='AJP/1.3':
                if p2!=-1:
                    i.setAttribute('port',str(p2))
                    r2=True
    f=open('/usr/tomcat/conf/server.xml','w')
    f.write(rot.toxml())
    f.close()
    return r1,r2,r3


#check all parts!
def checkAll():  
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
        r1=input('[Y/n]')
        if Yes(r1):
            for i in unin:
                install(i[0])
        else:
            print('Install one by one?')
            r2=input('[y/N]')
            if No(r2):
                return
            for i in unin:
                print('Install %s?'%i[1])
                r3=input('[Y/n]')
                if Yes(r3):
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
        r1=input('[Y/n]')
        if Yes(r1):
            for i in unin:
                pipInstall(i)
        else:
            print('Install one by one?')
            r2=input('[y/N]')
            if No(r2):
                return
            for i in unin:
                print('Install %s?'%i)
                r3=input('[Y/n]')
                if Yes(r3):
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
        r1=input('[Y/n]')
        if Yes(r1):
            for i in unin:
                aptInstall(i[0],i[1])
        else:
            print('Install one by one?')
            r2=input('[y/N]')
            if No(r2):
                return
            for i in unin:
                print('Install %s?'%i[0])
                r3=input('[Y/n]')
                if Yes(r3):
                    aptInstall(i[0],i[1])
    else:
        print('All required utils installed!')





# Main Entrance
def main():
    pgreen('----====HHSOJ Control Script====----'.center(CSIZE))
    print()
    print('by Zzzyt,'.center(CSIZE))
    print('HellHole Studios 2019'.center(CSIZE))
    print()
    print('Operations:')

    ol=['Check','Upgrade OJ','Tomcat Config','Run Status','Data Backup']
    for i in range(len(ol)):
        pgreen('[%d]'%(i+1))
        print(ol[i])
    o=input('Operation Nubmer:')

    if o=='1':
        #Check Parts
        utilInstallAll()
        print()
        pipInstallAll()
        print()
        checkAll()
    elif o=='2':
        #Upgrade OJ
        v1=getWarURL()
        v2=getFolderURL()
        print('Latest HHSOJ web app version: '+v1[0])
        print('Latest HHSOJ data folder version: '+v2[0])
        r1=input('Install web app?[Y/n]')
        if Yes(r1):
            installWebapp()
        
        r2=input('Install data folder?[Y/n]')
        if Yes(r2):
            installFolder()
            if not os.path.exists('/usr/hhsoj.zip'):
                pred('[ER]Download Failed: hhsoj.zip not found.\n')
            else:
                r3=input('Merge with original folder?[Y/n]')
                if Yes(r3):
                    mergeFolder()
                else:
                    r4=input('Cover original folder?[Y/n]')
                    if Yes(r4):
                        coverFolder()

    elif o=='3':
        #Configs
        tp=XMLgetPorts()
        print('Tomcat Configs'.center(CSIZE-20,'-'))
        if tp[0]!=-1:
            print('HTTP Port:\t%d'%tp[0])
        else:
            pred('HTTP Port not found\n')
        if tp[1]!=-1:
            print('AJP Port:\t%d'%tp[1])
        else:
            pred('AJP Port not found\n')
        if tp[1]!=-1:
            print('Shutdown Port:\t%d'%tp[2])
        else:
            pred('Shutdown Port not found\n')
        print('-'*(CSIZE-20))
        
        r1=input('New HTTP Port(nothing for no change):')
        if r1!='':
            if (not isNum(r1)) or int(r1)<0 or int(r1)>65535:
                pred('Invalid Port!\n')
            XMLsetPorts(int(r1),-1,-1)
        
        r2=input('New AJP Port(nothing for no change):')
        if r2!='':
            if (not isNum(r2)) or int(r2)<0 or int(r2)>65535:
                pred('Invalid Port!\n')
            XMLsetPorts(-1,int(r2),-1)

        r3=input('New Shutdown Port(nothing for no change):')
        if r3!='':
            if (not isNum(r3)) or int(r3)<0 or int(r3)>65535:
                pred('Invalid Port!\n')
            XMLsetPorts(-1,-1,int(r3))
    elif o=='4':
        #Server Status
        pred('UNDER CONSTRUCTION\n')
    elif o=='5':
        #Data Backup
        nm=backupFolder()
        pgreen('Folder backup complete. Saved to %s\n'%nm)
    else:
        print('Exit...')
        return




# RUN HERE!!!!
if __name__=='__main__':
    main()