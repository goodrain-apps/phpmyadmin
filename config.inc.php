<?php
require('/app/phpmyadmin/config.secret.inc.php');


$cfg['Servers'][1]['auth_type'] = 'cookie';
$cfg['Servers'][1]['host']      = _MYSQL_HOST_;
$cfg['Servers'][1]['port']      = _MYSQL_PORT_;
$cfg['Servers'][1]['extension'] = 'mysqli';
?>
