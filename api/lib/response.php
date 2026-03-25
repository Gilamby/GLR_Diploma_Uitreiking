<?php
declare(strict_types=1);

function json_response(array $data, int $status = 200): void {
  http_response_code($status);
  header('Content-Type: application/json; charset=utf-8');
  echo json_encode($data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
  exit;
}

function error_response(string $message, int $status = 400, array $extra = []): void {
  json_response(['ok' => false, 'error' => $message] + $extra, $status);
}

function ok_response(array $data = [], int $status = 200): void {
  json_response(['ok' => true] + $data, $status);
}

function read_json_body(): array {
  $raw = file_get_contents('php://input');
  if ($raw === false || trim($raw) === '') return [];
  $decoded = json_decode($raw, true);
  return is_array($decoded) ? $decoded : [];
}

