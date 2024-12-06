<?php
require '../config/database.php';
require '../config/jwt.php';

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));
$response = [];

if (!empty($data->email) && !empty($data->password)) {
    $query = "SELECT id, password FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":email", $data->email);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if (password_verify($data->password, $row['password'])) {
            $jwt = new JWTHandler();
            $response["token"] = $jwt->generateToken($row['id']);
            $response["message"] = "Inicio de sesión exitoso.";
        } else {
            $response["message"] = "Contraseña incorrecta.";
        }
    } else {
        $response["message"] = "Usuario no encontrado.";
    }
} else {
    $response["message"] = "Todos los campos son obligatorios.";
}

echo json_encode($response);
?>
