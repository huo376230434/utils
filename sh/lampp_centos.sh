#!/bin/sh

################## 引入 base 函数库 ##################

function init() {
  util_base_url=https://raw.githubusercontent.com/huo376230434/daily-utils/master
  util_url_suffix=./common/base.sh
if [ ! -e  $util_url_suffix ]; then
echo "要请求远程"

    if [ ! -d ./common ] ;then
        mkdir common;
    fi
cd common;
wget ${util_base_url}/sh/${util_url_suffix}
cd ../
fi
}
init;


source common/base.sh;
################## 正文 ##################


# 命令提示
if [ ! $1 ]
then
echo '数据库密码必填 调用格式为  '
success "./lampp_centos.sh  \$1  ";
echo "\$1:数据库密码 )"
exit 0;
fi

#yum update -y
xampp_install_obj=xampp-linux-x64-7.2.21-0-installer.run
if [ ! -e ./$xampp_install_obj ];then
echo '拉取xampp installer'
wget https://liquidtelecom.dl.sourceforge.net/project/xampp/XAMPP%20Linux/7.2.21/$xampp_install_obj
else
echo 'xampp installer 已经存在，直接用'
fi

chmod -R 777 ./xampp-linux-x64-7.2.21-0-installer.run

echo '安装xampp';
./xampp-linux-x64-7.2.21-0-installer.run
success '安装xampp完成';

echo "开机自启动";
init_d_soft_link=/etc/rc.d/init.d/xampp

if [ -e $init_d_soft_link ]
then
ln -s /opt/lampp/xampp  $init_d_soft_link
fi

chkconfig --add xampp
chkconfig xampp on

echo "添加进环境变量(如果没添加过的话)";

str="export PATH=\"/opt/lampp/bin:\$PATH\""
file=/etc/profile
append_file_if_not_exists "$str" $file
source /etc/profile;

echo "root 密码为 $1 ";
mysqladmin -uroot password $1;
warn "还需要在phpadmin 的config.ini.php 中将密码改成现在的!";
warn "重启";