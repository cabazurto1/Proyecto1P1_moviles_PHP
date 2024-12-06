<?php
require '../config/database.php';

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));
$response = [];

if (!empty($data->id) && (!empty($data->name) || !empty($data->email) || !empty($data->birth_date))) {
    $query = "UPDATE users SET ";
    $fields = [];

    if (!empty($data->name)) $fields[] = "name = :name";
    if (!empty($data->email)) $fields[] = "email = :email";
    if (!empty($data->birth_date)) $fields[] = "birth_date = :birth_date";

    $query .= implode(", ", $fields) . " WHERE id = :id";

    $stmt = $db->prepare($query);
    $stmt->bindParam(":id", $data->id);

    if (!empty($data->name)) $stmt->bindParam(":name", $data->name);
    if (!empty($data->email)) $stmt->bindParam(":email", $data->email);
    if (!empty($data->birth_date)) $stmt->bindParam(":birth_date", $data->birth_date);

    if ($stmt->execute()) {
        http_response_code(200);
        $response["message"] = "Usuario actualizado exitosamente.";
    } else {
        http_response_code(400);
        $response["message"] = "Error al actualizar el usuario.";
    }
} else {
    http_response_code(400);
    $response["message"] = "Datos incompletos.";
}

echo json_encode($response);
?>
