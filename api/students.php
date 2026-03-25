<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/response.php';
require_once __DIR__ . '/lib/db.php';
require_once __DIR__ . '/lib/auth.php';

require_auth();

$pdo = db();
$q = trim((string)($_GET['q'] ?? ''));

$sql =
  'SELECT s.StudentID, s.Naam, s.Bio, s.ProfielfotoUrl, k.Klasnaam
   FROM STUDENT s
   JOIN GEBRUIKER g ON g.GebruikerID = s.GebruikerID
   LEFT JOIN KLAS k ON k.KlasID = s.KlasID
   WHERE 1=1';
$params = [];
if ($q !== '') {
  $sql .= ' AND (s.Naam LIKE :q OR k.Klasnaam LIKE :q)';
  $params['q'] = '%' . $q . '%';
}
$sql .= ' ORDER BY s.Naam ASC';

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$rows = $stmt->fetchAll();

$students = array_map(function ($r) {
  return [
    'id' => (int)$r['StudentID'],
    'naam' => (string)$r['Naam'],
    'bio' => (string)($r['Bio'] ?? ''),
    'foto' => (string)($r['ProfielfotoUrl'] ?? ''),
    'klas' => (string)($r['Klasnaam'] ?? ''),
  ];
}, $rows);

ok_response(['students' => $students]);

