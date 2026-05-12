<?php
$config['installed'] = true;
$config['env'] = 'prod';
// site_url vem da env var SERVER_URL (Easypanel/Docker)
// Fallback: detecta protocolo via Traefik X-Forwarded-Proto, depois usa Host
$config['site_url'] = getenv('SERVER_URL') ?: (
    ((($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https' || ($_SERVER['HTTPS'] ?? '') === 'on') ? 'https://' : 'http://')
    . ($_SERVER['HTTP_HOST'] ?? 'localhost') . '/'
);
// server_path: caminho do canary dentro do container Docker
$config['server_path'] = '/canary/';
$config['gzip_output'] = false;
$config['cache_engine'] = 'auto';
$config['cache_prefix'] = 'myaac_vaelor';
$config['database_auto_migrate'] = true;
