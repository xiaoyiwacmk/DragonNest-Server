#!/bin/bash

### 运行脚本前，请先修改以下项
MYSQL_HOST=db
MYSQL_USER=root
MYSQL_PASSWORD=123456
MYSQL_PORT=3306
MYSQL_DB_LOGIN=login
MYSQL_DB_WORLD=world

function update_api_php() {
    rm -rf ../www/gm/api.php

    # 生成 PHP 内容
    cat <<EOF > ../www/gm/api.php
<?php
error_reporting(0);
session_start(); 
\$uid = \$_POST['uid'];
\$pwd = \$_POST['pwd'];
\$type = \$_POST['type'];
\$num = \$_POST['num'];
\$item = \$_POST['item'];
\$uid == '' && (die('无UID'));
\$num == '' && (\$num = '1'); 
\$quid = '1';

switch(\$type){
	case 'login':
		\$vipfile=\$vip.\$quid.'.json';
		\$fp = fopen(\$vipfile,"a+");
		if(filesize(\$vipfile)>0){
			\$str = fread(\$fp,filesize(\$vipfile));
			fclose(\$fp);
			\$vipjson=json_decode(\$str,true);
			if(\$vipjson==null){
				\$vipjson=array();
			}
		}else{
			\$vipjson=array();
		}
		if(\$vipjson[\$uid]['pswd'] == \$pwd){
			\$_SESSION['uid']=\$uid;
			\$_SESSION['level']=intval(\$vipjson[\$uid]['level']);
			\$return = array(
					'info' => 0,
					'msg' => '成功'
			);
			exit(json_encode(\$return));
		}else{
			die("登陆失败");
		}
		break;
	case 'charge':
			
			\$level = \$_SESSION['level'];
			
			if(\$level != 0){
				if(\$level == 1){
					
				}else{
					die("暂无权限！");
				}
			}
			\$chargeid = \$_POST['chargeid'];
			if(\$chargeid =='1_99'){
				\$items = 99;
			}
			if(\$chargeid =='1_100'){
				\$items = 100;
			}
			if(\$chargeid =='1_1000'){
				\$items = 1000;
			}
			\$mysql = mysqli_connect('$MYSQL_HOST',"$MYSQL_USER","$MYSQL_PASSWORD","$MYSQL_DB_WORLD","$MYSQL_PORT") or die("数据库连接错误");
			\$query="insert into recharge (userid, goodid, qty) values ('\$uid','\$items','\$num')";
			\$result = mysqli_query(\$mysql,\$query);
			if (\$result){
				die("发送成功");
			}else {
				die("发送失败");	
			}
			break;
		case 'mail':
			\$level = \$_SESSION['level'];
			if(\$level != 1){
				die("暂无权限！");
			}
			\$item == '' && (die('未选择物品')); 
			\$items = 10000 + \$item;
			\$mysql = mysqli_connect('$MYSQL_HOST',"$MYSQL_USER","$MYSQL_PASSWORD","$MYSQL_DB_WORLD","$MYSQL_PORT") or die("数据库连接错误");
			\$query="insert into recharge (userid, goodid, qty) values ('\$uid','\$items','\$num')";
			\$result = mysqli_query(\$mysql,\$query);
			if (\$result){
				die("发送成功");
			}else {
				die("发送失败");	
			}
			break;
		default:
			\$return=array(
				'errcode'=>1,
				'info'=>'数据错误',
			);
			exit(json_encode(\$return));
			break;
}

?>
EOF

    echo "api.php 更新完成"
}

function update_syymwcom_php() {
    rm -rf ../www/gm/syymwcom.php

    # 生成 PHP 内容
    cat <<EOF > ../www/gm/syymwcom.php
<?php
error_reporting(0);
\$sqm = \$_POST['sqm'];
\$uid = \$_POST['uid'];
\$num = \$_POST['num'];
\$item = \$_POST['item'];
\$sqm != 'syymw.com' && (die('授权码错误')); 
\$uid == '' && (die('无UID'));
\$num == '' && (\$num = '1'); 
\$quid = '1';
\$pswd = \$_POST['pswd'];
\$type = \$_POST['type'];
switch(\$type){
		case 'charge':
			\$chargeid = \$_POST['chargeid'];
			if(\$chargeid =='1_99'){
				\$items = 99;
			}
			if(\$chargeid =='1_100'){
				\$items = 100;
			}
			if(\$chargeid =='1_1000'){
				\$items = 1000;
			}
			\$mysql = mysqli_connect('$MYSQL_HOST',"$MYSQL_USER","$MYSQL_PASSWORD","$MYSQL_DB_WORLD","$MYSQL_PORT") or die("数据库连接错误");
			\$query="insert into recharge (userid, goodid, qty) values ('\$uid','\$items','\$num')";
			\$result = mysqli_query(\$mysql,\$query);
			if (\$result){
				die("发送成功");
			}else {
				die("发送失败");	
			}
			break;
		case 'mail':
			\$item == '' && (die('未选择物品')); 
			\$items = 10000 + \$item;
			\$mysql = mysqli_connect('$MYSQL_HOST',"$MYSQL_USER","$MYSQL_PASSWORD","$MYSQL_DB_WORLD","$MYSQL_PORT") or die("数据库连接错误");
			\$query="insert into recharge (userid, goodid, qty) values ('\$uid','\$items','\$num')";
			\$result = mysqli_query(\$mysql,\$query);
			if (\$result){
				die("发送成功");
			}else {
				die("发送失败");	
			}
			break;
		case 'addvip1':
			\$vipfile=\$vip.\$quid.'.json';
			\$fp = fopen(\$vipfile,"a+");
			if(filesize(\$vipfile)>0){
					\$str = fread(\$fp,filesize(\$vipfile));
					fclose(\$fp);
					\$vipjson=json_decode(\$str,true);
					if(\$vipjson==null){
						\$vipjson=array();
					}
			}else{
				\$vipjson=array();
			}
			\$vipjson[\$uid]=array('pswd'=>\$pswd,'level'=>0);
			file_put_contents(\$vipfile,json_encode(\$vipjson));
			die('开通VIP1成功');
			break;
		case 'addvip2':
			\$vipfile=\$vip.\$quid.'.json';
			\$fp = fopen(\$vipfile,"a+");
			if(filesize(\$vipfile)>0){
					\$str = fread(\$fp,filesize(\$vipfile));
					fclose(\$fp);
					\$vipjson=json_decode(\$str,true);
					if(\$vipjson==null){
						\$vipjson=array();
					}
			}else{
				\$vipjson=array();
			}
			\$vipjson[\$uid]=array('pswd'=>\$pswd,'level'=>1);
			file_put_contents(\$vipfile,json_encode(\$vipjson));
			die('开通VIP2成功');
			
			break;
		default:
			\$return=array(
				'errcode'=>1,
				'info'=>'数据错误',
			);
			exit(json_encode(\$return));
			break;
}
?>
EOF
    echo "syymwcom.php 更新完成"
}

function update_config_php() {
    rm -rf ../www/reg/config.php

    # 生成 PHP 内容
    cat <<EOF > ../www/reg/config.php
<?php
error_reporting(0);
\$PZ = array(
	'DB_HOST'=>'$MYSQL_HOST',// 服务器地址
	'DB_NAME'=>'$MYSQL_DB_WORLD',// 游戏角色数据库
	'DB_NAMES'=>'$MYSQL_DB_LOGIN',// 游戏注册数据库
	'DB_USER'=>'$MYSQL_USER',// 用户名
	'DB_PWD'=>'$MYSQL_PASSWORD',// 密码
	'DB_PORT'=>'$MYSQL_PORT',// 端口
	'DB_CHARSET'=>'utf8',// 数据库字符集
);
?>
EOF
    echo "config.php 更新完成"
}

update_api_php
update_syymwcom_php
update_config_php
