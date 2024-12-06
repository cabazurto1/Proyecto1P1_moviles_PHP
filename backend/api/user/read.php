<?php
require '../config/database.php';

$db = (new Database())->getConnection();
$response = [];

$query = "SELECT id, name, email, birth_date, created_at FROM users";
$stmt = $db->prepare($query);
$stmt->execute();

$response = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($response);
?>
