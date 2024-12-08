<?php
require '../config/database.php';
header("Access-Control-Allow-Origin: *");  // Permite solicitudes desde cualquier dominio
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$db = (new Database())->getConnection();
$response = [];

$query = "SELECT id, name, email, birth_date, created_at FROM users";
$stmt = $db->prepare($query);
$stmt->execute();

$response = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($response);
?>
