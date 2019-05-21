#!/bin/bash

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"

check_root(){
  [[ $EUID != 0 ]] && echo -e "Please use root account or use command 'sudo' to get root access." && exit 1
}

print_info(){
  echo -e "${Green_font_prefix}[INFO]$1${Font_color_suffix}"
}

print_err(){
  echo -e "${Red_font_prefix}[ERR]$1${Font_color_suffix}"
}

update_com(){
  print_info "Will update apt sources."
  apt-get update
  apt-get upgrade
}

install_com(){
  print_err "$1 Not Found."
  print_info "Will Install."
  apt -y install $1
  if [ $? -eq 0 ]; then
    print_info "Installation Succeed for $1."
  else
    print_err "Installation Failed for $1."
  fi
}

check_com(){
  update_com
  for nowc in 'wget' 'tar' 'unzip' 'python3'
  do
    if command -v ${nowc} >/dev/null 2>&1; then
       print_info "${nowc} Found."
    else
       install_com ${nowc}
    fi
  done
  if command -v pip3 >/dev/null 2>&1; then
    print_info "pip3 found."
  else
    install_com python3-pip
  fi
}

install_pip(){
  print_err "$1 Not Found."
  print_info "Will Install."
  pip3 install $1
  if [ $? -eq 0 ]; then
     print_info "Installation Succeed for Module $1."
  else
     print_err "Installation Failed for Module $1."
  fi
}

check_pip(){
  for nowb in 'robobrowser' 'requests' 
  do
    if python3 -c "import ${nowb}" >/dev/null 2>&1 ; then
      print_info "${nowb} Found."
    else
      install_pip ${nowb}
    fi
  done
}

install_tomcat(){
  wget -P /usr/ 'http://apache.01link.hk/tomcat/tomcat-9/v9.0.19/bin/apache-tomcat-9.0.19.tar.gz'
  tar zxvf /usr/tomcat.tar.gz -C /usr/
  rm -f /usr/tomcat.tar.gz
  mv /usr/apache-tomcat-9.0.19/ /usr/tomcat/
  print_info "Tomcat installed successfully"
}

install_webapp(){
  hhsoj_ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/XiaoGeNintendo/HHSOJ-Web-Edition/releases | grep -o '"tag_name": ".*"' |head -n 1| sed 's/"//g;s/v//g' | sed 's/tag_name: //g')
  down_link="https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/${hhsoj_ver}/HellOJ.war"
  wget -P '/usr/tomcat/webapps/ROOT.war' ${down_link}
  rm -rf '/usr/tomcat/webapps/ROOT/'
  print_info "Please now run tomcat to unpack the file" 
}

install_folder(){
  down_link=$(wget --no-check-certificate -qO- https://api.github.com/repos/XiaoGeNintendo/HHSOJ-Web-Edition/releases | grep -o 'https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/.*/hhsoj.zip' | head -n 1)
  wget -P  ${down_link} /usr/hhsoj.zip
  rm -rf /usr/hhsoj/
  unzip /usr/hhsoj.zip -d /usr/
  rm -f /usr/hhsoj.zip
}


check_all(){
  if javac >/dev/null 2>&1; then
    install_com 'openjdk-8-jdk'
  else
    print_info 'JDK Found.'
  fi

  if java >/dev/null 2>&1; then
    install_com 'openjdk-8-jdk'
  else
    print_info 'Java Found.'
  fi
  
  if g++ >/dev/null 2>&1; then
    install_com 'gcc-g++'
  else
    print_info 'G++ Found.'
  fi

  if [ -d "/usr/tomcat/" ]; then
    print_info "Tomcat Found."
  else
    install_tomcat
  fi	
  
  if [ ! -f  "/usr/tomcat/webapps/ROOT/index.jsp" -o -f "/usr/tomcat/webapps/ROOT.war" ]; then
    print_info "HHSOJ Webapp Found."
  else 
    install_webapp
  fi
  
  if [ ! -f "/usr/hhsoj" ]; then
    print_info "[INFO]HHSOJ Folder Found."
  else
    install_folder
  fi
}

if [ "$#" -gt 0 -a "$1" = "--debug" ]; then
  if [ ! -f '/usr/tomcat/webapps/ROOT.war/' ]; then
     print_info 'Found.'
  else
     print_err 'Not Found'
  fi
else
  check_root
  check_com
  check_pip
  check_all
fi
