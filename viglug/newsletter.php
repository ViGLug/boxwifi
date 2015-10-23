<?php
require('3rdparty/smarty/Smarty.class.php');
require('config.inc.php');
$smarty = new Smarty;

$smarty->template_dir = 'templates/';
$smarty->compile_dir = 'templates_c/';

$db=mysql_connect($_CONFIG['db_host'], $_CONFIG['db_user'], $_CONFIG['db_pass']) or die(mysql_error());
mysql_select_db($_CONFIG['db_name']) or die(mysql_error());

if(isset($_POST['nome']) && isset($_POST['cognome']) && isset($_POST['email'])) {
	if($_POST['nome'] != '' && $_POST['cognome'] != '' && $_POST['email'] != '') {
		$query="INSERT INTO newsletter (nome, cognome, email) VALUES ('".mysql_real_escape_string($_POST['nome'])."', '".mysql_real_escape_string($_POST['cognome'])."', '".mysql_real_escape_string($_POST['email'])."')";
		mysql_query($query, $db) or die(mysql_error());
		$smarty->assign('status','OK');
	}
	else {
		$smarty->assign('status','FAIL');
	}
}

$smarty->display('newsletter.tpl');
?>
