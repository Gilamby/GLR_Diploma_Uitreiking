<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/response.php';
require_once __DIR__ . '/lib/db.php';
require_once __DIR__ . '/lib/auth.php';

require_auth();

$pdo = db();
$rows = $pdo->query('SELECT KlasID, Klasnaam FROM KLAS ORDER BY Klasnaam ASC')->fetchAll();

ok_response(['classes' => array_map(function ($r) {
  return [
    'id' => (int)$r['KlasID'],
    'name' => (string)$r['Klasnaam'],
  ];
}, $rows)]);

