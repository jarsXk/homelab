## config.php
```
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'redis' =>
    array (
      'host' => 'redis',
      'port' => 6379,
    ),
  'maintenance_window_start' => 100,
  'localstorage.umask' => 007,
  'trusted_domains' =>
    array (
      0 => '172.16.2.10:51120',
      1 => 'nextcloud.sungate.keenetic.pro',
    ),
  'overwritehost' => 'nextcloud.sungate.keenetic.pro',
  'overwriteprotocol' => 'https',
  'overwrite.cli.url' => 'https://nextcloud.sungate.keenetic.pro',
  'trusted_proxies' =>
    array (
      0 => '172.16.1.1',
      1 => '172.16.2.10',
    ),
  'preview_max_x' => 1000,
  'preview_max_y' => 1000,
  'enable_previews' => true,
  'enabledPreviewProviders' =>
  array (
    0 => 'OC\Preview\PNG',
    1 => 'OC\Preview\JPEG',
    2 => 'OC\Preview\GIF',
    3 => 'OC\Preview\BMP',
    4 => 'OC\Preview\XBitmap',
    5 => 'OC\Preview\HEIC',
    6 => 'OC\Preview\MP3',
    7 => 'OC\Preview\Movie',
    8 => 'OC\Preview\MKV',
    9 => 'OC\Preview\MP4',
    10 => 'OC\Preview\AVI',
    11 => 'OC\Preview\TXT',
    12 => 'OC\Preview\MarkDown',
    13 => 'OC\Preview\OpenDocument',
    14 => 'OC\Preview\Krita',
    15 => 'OC\Preview\PDF',
    16 => 'OC\Preview\MSOfficeDoc',
  ),

```