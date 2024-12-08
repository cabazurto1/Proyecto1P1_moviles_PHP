<?php
require_once __DIR__ . '/../../vendor/autoload.php';
use Firebase\JWT\JWT;

class JWTHandler {
    private $secret_key = "miClaveSuperSecreta";

    public function generateToken($user_id) {
        $payload = [
            "iss" => "http://localhost",
            "iat" => time(),
            "exp" => time() + 3600, // 1 hora
            "sub" => $user_id
        ];

        return JWT::encode($payload, $this->secret_key, 'HS256');
    }

    public function verifyToken($token) {
        try {
            $decoded = JWT::decode($token, $this->secret_key, ['HS256']);
            return $decoded;
        } catch (Exception $e) {
            return null;
        }
    }
}
?>
