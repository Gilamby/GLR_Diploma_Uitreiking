<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/response.php';
require_once __DIR__ . '/lib/db.php';
require_once __DIR__ . '/lib/auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  error_response('Method not allowed', 405);
}

$body = read_json_body();
$code = trim((string)($body['code'] ?? ''));
if ($code === '') error_response('Toegangscode is verplicht.', 400);

$pdo = db();
$stmt = $pdo->prepare('SELECT GebruikerID, Rol FROM GEBRUIKER WHERE Inlogcode = :code LIMIT 1');
$stmt->execute(['code' => $code]);
$row = $stmt->fetch();
if (!$row) error_response('Ongeldige toegangscode.', 401);

$userId = (int)$row['GebruikerID'];
$role = (string)$row['Rol'];

$token = make_token(['uid' => $userId, 'role' => $role]);

ok_response([
  'token' => $token,
  'user' => [
    'id' => $userId,
    'role' => $role,
  ],
]);

