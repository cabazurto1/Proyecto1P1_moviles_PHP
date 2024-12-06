<?php
require '../config/database.php';
require '../config/jwt.php';

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));
$response = [];

if (!empty($data->name) && !empty($data->email) && !empty($data->password) && !empty($data->birth_date)) {
    $query = "INSERT INTO users SET name=:name, email=:email, password=:password, birth_date=:birth_date";

    $stmt = $db->prepare($query);
    $stmt->bindParam(":name", $data->name);
    $stmt->bindParam(":email", $data->email);

    // Cifrar contraseña
    $hashed_password = password_hash($data->password, PASSWORD_BCRYPT);
    $stmt->bindParam(":password", $hashed_password);
    $stmt->bindParam(":birth_date", $data->birth_date);

    if ($stmt->execute()) {
        $response["message"] = "Usuario registrado con éxito.";
    } else {
        $response["message"] = "Error al registrar usuario.";
    }
} else {
    $response["message"] = "Todos los campos son obligatorios.";
}

echo json_encode($response);
?>
