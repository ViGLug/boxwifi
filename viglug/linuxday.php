<?php
require('3rdparty/smarty/Smarty.class.php');
$smarty = new Smarty;

$smarty->template_dir = 'templates/';
$smarty->compile_dir = 'templates_c/';

//$smarty->assign('name','Ned');

$smarty->display('linuxday.tpl');
?>
