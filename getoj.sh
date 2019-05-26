#!/bin/bash

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Grey_font_preffix="\e[37m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
column_size=${COLUMNS}
length_size=${LINES}
debug_mode=false

check_root(){
  [[ $EUID != 0 ]] && echo -e "Please use root account or use command 'sudo' to get root access." && exit 1
}

print_info(){
  echo -e "${Green_font_prefix}[INFO]$1${Font_color_suffix}"
}

print_err(){
  echo -e "${Red_font_prefix}[ERR]$1${Font_color_suffix}"
}

print_center(){
  len1=${#1}
  spaces=`expr 38 - $len1 / 2 `
  cnt=0
  while (($cnt<=$spaces))
  do
    if [ ! $2 == ' ' ]; then
       echo -n $2
    else
       echo -n ' '
    fi
    let "cnt++"
  done
  echo -n -e "$1"
  cnt=0
  while (($cnt<=$spaces))
  do
    if [ ! $2 == ' ' ]; then
       echo -n $2
    else
       echo -n ' '
    fi
    let "cnt++"  
  done
  printf '\n'
}

print_grey(){
  echo -n -e "${Grey_font_size}:${Font_color_suffix}"
}

get_sysinfo(){
  cnt=0
  while (($cnt<80))
  do
    echo -n '='
    let "cnt++"
  done

  CPU=$(grep 'model name' /proc/cpuinfo |uniq |awk -F : '{print $2}' |sed 's/^[ \t]*//g' |sed 's/ \+/ /g') 
  printf "%-30s" "CPU Model"
  print_grey
  echo -e " ${Green_font_prefix}${CPU}${Font_color_suffix}"

  cpu_num=`cat /proc/cpuinfo|grep 'processor'|sort|uniq|wc -l`
  printf "%-30s" "CPU Numbers"
  print_grey
  echo -e " ${Green_font_prefix}$cpu_num${Font_color_suffix}"

  PROCESSOR=$(grep 'processor' /proc/cpuinfo |sort |uniq |wc -l)
  printf "%-30s" "Logical CPU Number"
  print_grey
  echo -e " ${Green_font_prefix}${PROCESSOR}${Font_color_suffix}"

  Mode=$(getconf LONG_BIT) 
  printf "%-30s" "CPU Running Mode"
  print_grey
  echo -e " ${Green_font_prefix}${Mode}Bits${Font_color_suffix}"
  
  Cores=$(grep 'cpu cores' /proc/cpuinfo |uniq |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
  printf "%-30s" "CPU Cores"
  print_grey
  echo -e " ${Green_font_prefix}${Cores}${Font_color_suffix}"

  Total=$(cat /proc/meminfo |grep 'MemTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
  printf "%-30s" "Memory in Total"
  print_grey
  echo -e " ${Green_font_prefix}${Total}${Font_color_suffix}"

  Available=$(free -m |grep - |awk -F : '{print $2}' |awk '{print $2}')
  printf "%-30s" "Memory Free"
  print_grey
  echo -e " ${Green_font_prefix}${Available}${Font_color_suffix}"

  SwapTotal=$(cat /proc/meminfo |grep 'SwapTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
  printf "%-30s" "Swap in Total"
  print_grey
  echo -e " ${Green_font_prefix}${SwapTotal}${Font_color_suffix}"

  disk_size=`df -h / | awk '{print $2}'|grep -E '[0-9]'`
  printf "%-30s" "Disk Size Free"
  print_grey
  echo -e " ${Green_font_prefix}${disk_size}${Font_color_suffix}"

  linux_v=$(cat /etc/os-release|grep 'PRETTY_NAME'|cut -c14-)
  linux_bit=`uname -i`
  printf "%-30s" "System"
  print_grey
  echo -e " ${Green_font_prefix}${linux_v:0:${#linux_v}-1} $linux_bit${Font_color_suffix}"

  process=`ps aux|wc -l`
  let process--
  printf "%-30s" "Running Processes"
  print_grey
  echo -e " ${Green_font_prefix}$process${Font_color_suffix}"

  software_num=`dpkg -l |wc -l`
  printf "%-30s" "Software Installed"
  print_grey
  echo -e " ${Green_font_prefix}$software_num${Font_color_suffix}"

  kernel_version=$(uname -r)
  printf "%-30s" "Kernel Version"
  print_grey
  echo -e " ${Green_font_prefix}$kernel_version${Font_color_suffix}"
  cnt=0

  while (($cnt<80))
  do
    echo -n '='
    let "cnt++"
  done
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
  tar zxvf /usr/apache-tomcat-9.0.19.tar.gz -C /usr/
  rm -f /usr/tomcat.tar.gz
  mv /usr/apache-tomcat-9.0.19/ /usr/tomcat/
  print_info "Tomcat installed successfully"
}

install_webapp(){
  hhsoj_ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/XiaoGeNintendo/HHSOJ-Web-Edition/releases | grep -o '"tag_name": ".*"' |head -n 1| sed 's/"//g;s/v//g' | sed 's/tag_name: //g')
  print_info "Latest WebApp Version:${hhsoj_ver}"
  read -e -p "Install/Update Now?[Y/n]:" ch
  if [[  -z $ch ]]; then
     down_link="https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/v${hhsoj_ver}/HellOJ.war"
     wget -P '/usr/tomcat/webapps/ROOT.war' ${down_link}
     rm -rf '/usr/tomcat/webapps/ROOT/'
     print_info "Please now run tomcat to unpack the file"
  else 
    if [ "${ch}" == 'y' -o "${ch}" == "Y" ]; then
      down_link="https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/v${hhsoj_ver}/HellOJ.war"
      wget -P '/usr/tomcat/webapps/ROOT.war' ${down_link}
      rm -rf '/usr/tomcat/webapps/ROOT/'
      print_info "Please now run tomcat to unpack the file" 
    else
      print_info "Installation/Update Canceled."
    fi
  fi
}

install_folder(){
  down_link=$(wget --no-check-certificate -qO- https://api.github.com/repos/XiaoGeNintendo/HHSOJ-Web-Edition/releases | grep -o 'https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition/releases/download/.*/hhsoj.zip' | head -n 1)
  folder_ver=$(echo ${down_link} | grep -P '\d+\.\d+' -o)
  print_info "Latest HHSOJ Folder Version:${folder_ver}"
  read -e -p "Install/Update Now?[Y/n]:" ch
  if [[  -z $ch ]]; then
    wget -P  ${down_link} /usr/hhsoj.zip
    rm -rf /usr/hhsoj/
    unzip /usr/hhsoj.zip -d /usr/
    rm -f /usr/hhsoj.zip
  else
   if [ "${ch}" == 'y' -o "${ch}" == "Y" ]; then
      wget -P  ${down_link} /usr/hhsoj.zip
      rm -rf /usr/hhsoj/
      unzip /usr/hhsoj.zip -d /usr/
      rm -f /usr/hhsoj.zip
   else
     print_info "Installation/Update Canceled."
   fi
  fi
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
    print_info "HHSOJ Folder Found."
  else
    install_folder
  fi
}

get_port(){
  if [ ! -d "/usr/tomcat/" ]; then
    print_err "Please install tomcat first!" && exit 1
  fi
  port1=$(cat /usr/tomcat/conf/server.xml|grep 'protocol="HTTP/1.1"'|head -n 1|sed  's/"//g'|sed 's/    <Connector port=//g'|sed 's/ protocol=HTTP\/1.1//g')
  port2=$(cat /usr/tomcat/conf/server.xml|grep 'protocol="AJP/1.3"'|sed 's/.*<Connector port=//g'|sed 's/"//g'|sed 's/ protocol=AJP\/1.3.*//g')
  port3=$(cat /usr/tomcat/conf/server.xml|grep 'shutdown="SHUTDOWN"'|sed 's/<Server port="//g'|sed 's/".*//g')
  print_info "HTTP Port:${port1}"
  print_info "AJP Port:${port2}"
  print_info "Shutdown Port:${port3}"
}
if [ "$#" -gt 0 -a "$1" = "--debug" ]; then
  debug_mode=true
  get_sysinfo
else
  echo -e "${Green_font_prefix}==============================HHSOJ Control Shell===============================${Font_color_suffix}"
  echo -e "${Green_font_prefix}|                                  By XIZCM                                    |${Font_color_suffix}"
  echo -e "${Green_font_prefix}|                           HellHoleStudios©, 2019                             |${Font_color_suffix}"
  echo -e "${Green_font_prefix}================================================================================${Font_color_suffix}"
  echo ""
  echo "Operations:"
  echo "[1]Check&Install HHSOJ"
  echo "[2]Update HHSOJ"
  echo "[3]Tomcat config"
  echo "[4]Get System Info"
  read -e -p "Input Your Choice:" ch
  case "$ch" in
    1)
    check_root
    update_com
    check_com
    check_pip
    check_all
    ;;
    2)
    install_webapp
    install_folder
    ;;
    3)
    print_center 'Tomcat Config' '='
    get_port
    print_center '' '='
    ;;
    4)
    get_sysinfo
	;;
    *)
    print_err "Please input the right number"
    ;;
  esac
fi
