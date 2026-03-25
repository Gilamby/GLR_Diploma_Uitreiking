<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/response.php';
require_once __DIR__ . '/lib/db.php';
require_once __DIR__ . '/lib/auth.php';

require_auth();

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) error_response('id is verplicht.', 400);

$pdo = db();
$stmt = $pdo->prepare(
  'SELECT s.StudentID, s.Naam, s.Bio, s.ProfielfotoUrl, k.Klasnaam
   FROM STUDENT s
   LEFT JOIN KLAS k ON k.KlasID = s.KlasID
   WHERE s.StudentID = :id
   LIMIT 1'
);
$stmt->execute(['id' => $id]);
$r = $stmt->fetch();
if (!$r) error_response('Leerling niet gevonden.', 404);

ok_response([
  'student' => [
    'id' => (int)$r['StudentID'],
    'naam' => (string)$r['Naam'],
    'bio' => (string)($r['Bio'] ?? ''),
    'foto' => (string)($r['ProfielfotoUrl'] ?? ''),
    'klas' => (string)($r['Klasnaam'] ?? ''),
  ],
]);

