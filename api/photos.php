<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/response.php';
require_once __DIR__ . '/lib/db.php';
require_once __DIR__ . '/lib/auth.php';

require_auth();

$pdo = db();
$config = require __DIR__ . '/config.php';
$publicBase = rtrim((string)$config['uploads']['public_path'], '/');

$klas = trim((string)($_GET['klas'] ?? ''));

if ($klas !== '') {
  $stmt = $pdo->prepare(
    'SELECT f.FotoID, f.Bestandsnaam, f.UploadDatum, k.Klasnaam
     FROM FOTO f
     JOIN KLAS k ON k.KlasID = f.KlasID
     WHERE k.Klasnaam = :klas
     ORDER BY f.UploadDatum DESC, f.FotoID DESC'
  );
  $stmt->execute(['klas' => $klas]);
  $rows = $stmt->fetchAll();
} else {
  $rows = $pdo->query(
    'SELECT f.FotoID, f.Bestandsnaam, f.UploadDatum, k.Klasnaam
     FROM FOTO f
     JOIN KLAS k ON k.KlasID = f.KlasID
     ORDER BY f.UploadDatum DESC, f.FotoID DESC'
  )->fetchAll();
}

$photos = array_map(function ($r) use ($publicBase) {
  $filename = (string)$r['Bestandsnaam'];
  return [
    'id' => (int)$r['FotoID'],
    'titel' => pathinfo($filename, PATHINFO_FILENAME),
    'url' => $publicBase . '/' . rawurlencode($filename),
    'klas' => (string)$r['Klasnaam'],
    'uploadDatum' => (string)$r['UploadDatum'],
    'geliked' => false,
  ];
}, $rows);

ok_response(['photos' => $photos]);

