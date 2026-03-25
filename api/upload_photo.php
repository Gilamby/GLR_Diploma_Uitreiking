<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/response.php';
require_once __DIR__ . '/lib/db.php';
require_once __DIR__ . '/lib/auth.php';

$claims = require_admin();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  error_response('Method not allowed', 405);
}

$config = require __DIR__ . '/config.php';
$uploadsDir = (string)$config['uploads']['dir'];
$maxBytes = (int)$config['uploads']['max_bytes'];

if (!is_dir($uploadsDir)) {
  if (!mkdir($uploadsDir, 0775, true) && !is_dir($uploadsDir)) {
    error_response('Uploads map kan niet worden aangemaakt.', 500);
  }
}

$titel = trim((string)($_POST['titel'] ?? ''));
$klas = trim((string)($_POST['klas'] ?? ''));
$klasId = (int)($_POST['klasId'] ?? 0);

if ($titel === '') error_response('Titel is verplicht.', 400);
if ($klasId <= 0 && $klas === '') error_response('Klas is verplicht.', 400);
if (!isset($_FILES['file'])) error_response('Bestand ontbreekt.', 400);

$file = $_FILES['file'];
if (!is_array($file) || ($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
  error_response('Upload mislukt.', 400, ['code' => (int)($file['error'] ?? -1)]);
}

$size = (int)($file['size'] ?? 0);
if ($size <= 0 || $size > $maxBytes) error_response('Bestand is te groot.', 413);

$tmp = (string)$file['tmp_name'];
$finfo = new finfo(FILEINFO_MIME_TYPE);
$mime = (string)$finfo->file($tmp);
$allowed = [
  'image/jpeg' => 'jpg',
  'image/png' => 'png',
  'image/webp' => 'webp',
];
if (!isset($allowed[$mime])) error_response('Alleen jpg/png/webp toegestaan.', 415);

$safeTitle = preg_replace('/[^a-zA-Z0-9-_ ]+/', '', $titel);
$safeTitle = trim(preg_replace('/\s+/', ' ', $safeTitle));
$safeTitle = str_replace(' ', '_', $safeTitle);
$safeTitle = $safeTitle !== '' ? $safeTitle : 'foto';

$ext = $allowed[$mime];
$filename = $safeTitle . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
$dest = $uploadsDir . DIRECTORY_SEPARATOR . $filename;

if (!move_uploaded_file($tmp, $dest)) {
  error_response('Bestand opslaan mislukt.', 500);
}

$pdo = db();
if ($klasId <= 0) {
  $stmt = $pdo->prepare('SELECT KlasID FROM KLAS WHERE Klasnaam = :k LIMIT 1');
  $stmt->execute(['k' => $klas]);
  $row = $stmt->fetch();
  if (!$row) error_response('Klas niet gevonden.', 400);
  $klasId = (int)$row['KlasID'];
}

$stmt = $pdo->prepare(
  'INSERT INTO FOTO (Bestandsnaam, UploadDatum, KlasID, UploaderID)
   VALUES (:b, CURRENT_DATE(), :kid, :uid)'
);
$stmt->execute([
  'b' => $filename,
  'kid' => $klasId,
  'uid' => (int)($claims['uid'] ?? 0),
]);

ok_response([
  'photo' => [
    'id' => (int)$pdo->lastInsertId(),
    'titel' => $titel,
    'url' => rtrim((string)$config['uploads']['public_path'], '/') . '/' . rawurlencode($filename),
  ],
], 201);

