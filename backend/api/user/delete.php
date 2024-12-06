<?php
require '../config/database.php';

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));
$response = [];

if (!empty($data->id)) {
    $query = "DELETE FROM users WHERE id = :id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":id", $data->id);

    if ($stmt->execute()) {
        http_response_code(200);
        $response["message"] = "Usuario eliminado con exito.";
    } else {
        http_response_code(400);
        $response["message"] = "Error al eliminar el usuario.";
    }
} else {
    http_response_code(400);
    $response["message"] = "ID del usuario requerido.";
}

echo json_encode($response);
?>
