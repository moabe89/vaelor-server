<?php
$config['installed'] = true;
$config['env'] = 'prod';
// site_url sera o IP/dominio da VPS quando deploy
$config['site_url'] = 'http://31.97.151.29:8081/';
// server_path: caminho do canary dentro do container Docker
$config['server_path'] = '/canary/';
$config['gzip_output'] = false;
$config['cache_engine'] = 'auto';
$config['cache_prefix'] = 'myaac_vaelor';
$config['database_auto_migrate'] = true;
