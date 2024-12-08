<?php
require '../config/jwt.php';
header("Access-Control-Allow-Origin: *");  // Permite solicitudes desde cualquier dominio
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$headers = getallheaders();
$response = [];

if (isset($headers['Authorization'])) {
    $token = str_replace('Bearer ', '', $headers['Authorization']);
    $jwt = new JWTHandler();

    $decoded = $jwt->verifyToken($token);

    if ($decoded) {
        $response['valid'] = true;
        $response['user_id'] = $decoded->sub;
    } else {
        http_response_code(401);
        $response['message'] = 'Token inválido o expirado.';
    }
} else {
    http_response_code(401);
    $response['message'] = 'Token no proporcionado.';
}

echo json_encode($response);
?>
