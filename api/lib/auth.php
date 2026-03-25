<?php
declare(strict_types=1);

require_once __DIR__ . '/response.php';
require_once __DIR__ . '/../config.php';

function b64url_encode(string $data): string {
  return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
}

function b64url_decode(string $data): string {
  $data = strtr($data, '-_', '+/');
  $pad = strlen($data) % 4;
  if ($pad) $data .= str_repeat('=', 4 - $pad);
  $out = base64_decode($data, true);
  return $out === false ? '' : $out;
}

function make_token(array $claims): string {
  $config = require __DIR__ . '/../config.php';
  $secret = (string)$config['auth']['token_secret'];
  $ttl = (int)$config['auth']['token_ttl_seconds'];
  $now = time();

  $payload = $claims + [
    'iat' => $now,
    'exp' => $now + $ttl,
  ];

  $body = b64url_encode(json_encode($payload, JSON_UNESCAPED_SLASHES));
  $sig = b64url_encode(hash_hmac('sha256', $body, $secret, true));
  return $body . '.' . $sig;
}

function verify_token(string $token): ?array {
  $config = require __DIR__ . '/../config.php';
  $secret = (string)$config['auth']['token_secret'];

  $parts = explode('.', $token);
  if (count($parts) !== 2) return null;
  [$body, $sig] = $parts;

  $expected = b64url_encode(hash_hmac('sha256', $body, $secret, true));
  if (!hash_equals($expected, $sig)) return null;

  $json = b64url_decode($body);
  $claims = json_decode($json, true);
  if (!is_array($claims)) return null;
  if (isset($claims['exp']) && time() > (int)$claims['exp']) return null;
  return $claims;
}

function get_bearer_token(): string {
  $hdr = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
  if (!$hdr) return '';
  if (stripos($hdr, 'Bearer ') !== 0) return '';
  return trim(substr($hdr, 7));
}

function require_auth(): array {
  $token = get_bearer_token();
  if (!$token) error_response('Niet ingelogd.', 401);
  $claims = verify_token($token);
  if (!$claims) error_response('Ongeldige of verlopen sessie.', 401);
  return $claims;
}

function require_admin(): array {
  $claims = require_auth();
  if (($claims['role'] ?? '') !== 'admin') error_response('Geen toegang.', 403);
  return $claims;
}

