<?php
require('./config.secret.inc.php');
/* Ensure we got the environment */
$vars = array(
    'PMA_ARBITRARY',
    'MYSQL_HOST',
    'MYSQL_HOSTS',
    'MYSQL_PORT',
    'MYSQL_USER',
    'MYSQL_PASS',
);
foreach ($vars as $var) {
    if (!isset($_ENV[$var]) && getenv($var)) {
        $_ENV[$var] = getenv($var);
    }
}
/* Arbitrary server connection */
if (isset($_ENV['PMA_ARBITRARY']) && $_ENV['PMA_ARBITRARY'] === '1') {
    $cfg['AllowArbitraryServer'] = true;
}
/* Figure out hosts */
/* Fallback to default linked */
$hosts = array('db');
/* Set by environment */
if (!empty($_ENV['MYSQL_HOST'])) {
    $hosts = array($_ENV['MYSQL_HOST']);
} elseif (!empty($_ENV['MYSQL_HOSTS'])) {
    $hosts = explode(',', $_ENV['MYSQL_HOSTS']);
}
/* Server settings */
for ($i = 1; isset($hosts[$i - 1]); $i++) {
    $cfg['Servers'][$i]['host'] = $hosts[$i - 1];
    if (isset($_ENV['MYSQL_PORT'])) {
        $cfg['Servers'][$i]['port'] = $_ENV['MYSQL_PORT'];
    }
    if (isset($_ENV['MYSQL_USER'])) {
        $cfg['Servers'][$i]['auth_type'] = 'cookie';
        $cfg['Servers'][$i]['user'] = $_ENV['MYSQL_USER'];
        $cfg['Servers'][$i]['password'] = isset($_ENV['MYSQL_PASS']) ? $_ENV['MYSQL_PASS'] : null;
    } else {
        $cfg['Servers'][$i]['auth_type'] = 'cookie';
    }
    $cfg['Servers'][$i]['connect_type'] = 'tcp';
    $cfg['Servers'][$i]['compress'] = false;
    $cfg['Servers'][$i]['AllowNoPassword'] = false;
}
/* Uploads setup */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
/* Include User Defined Settings Hook */
if (file_exists('/config.user.inc.php')) {
    include('/config.user.inc.php');
}
