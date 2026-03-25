<?php
declare(strict_types=1);

return [
  'db' => [
    'host' => getenv('DB_HOST') ?: 'localhost',
    'port' => (int)(getenv('DB_PORT') ?: '3306'),
    'name' => getenv('DB_NAME') ?: 'diploma_testing',
    'user' => getenv('DB_USER') ?: 'uitreiking_test',
    'pass' => getenv('DB_PASS') ?: 'Nasnas12!',
  ],
  'auth' => [
    'token_secret' => getenv('API_TOKEN_SECRET') ?: 'change-me-in-env',
    'token_ttl_seconds' => (int)(getenv('API_TOKEN_TTL') ?: (60 * 60 * 24 * 7)),
  ],
  'uploads' => [
    'dir' => __DIR__ . DIRECTORY_SEPARATOR . 'uploads',
    'public_path' => '/api/uploads',
    'max_bytes' => (int)(getenv('UPLOAD_MAX_BYTES') ?: (10 * 1024 * 1024)),
  ],
];

