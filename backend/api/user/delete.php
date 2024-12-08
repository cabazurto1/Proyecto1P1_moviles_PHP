<?php
require '../config/database.php';
header("Access-Control-Allow-Origin: *");  // Permite solicitudes desde cualquier dominio
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$db = (new Database())->getConnection();
$response = [];

if (isset($_GET['email'])) {
    $email = $_GET['email']; // Recuperamos el email desde la URL
    $query = "DELETE FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":email", $email);

    if ($stmt->execute()) {
        http_response_code(200);
        $response["message"] = "Usuario eliminado con éxito.";
    } else {
        http_response_code(400);
        $response["message"] = "Error al eliminar el usuario.";
    }
} else {
    http_response_code(400);
    $response["message"] = "Email del usuario requerido.";
}

echo json_encode($response);

?>
