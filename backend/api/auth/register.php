<?php
require '../config/database.php';
require '../config/jwt.php';

header("Access-Control-Allow-Origin: *"); // Permitir cualquier origen
header("Access-Control-Allow-Methods: POST, PUT, OPTIONS, DELETE"); // Permitir PUT y POST
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Encabezados permitidos
header("Access-Control-Allow-Credentials: true"); // Si necesitas enviar cookies o credenciales


$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));
$response = [];

// Validar que los campos requeridos estén presentes
if (!empty($data->name) && !empty($data->email) && !empty($data->password) && !empty($data->birth_date)) {
    // Validar formato de email
    if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400); // Código 400: Bad Request
        echo json_encode(["message" => "El formato del correo electrónico es inválido."]);
        exit;
    }

    // Verificar si el correo ya existe en la base de datos
    $emailQuery = "SELECT id FROM users WHERE email = :email";
    $emailStmt = $db->prepare($emailQuery);
    $emailStmt->bindParam(":email", $data->email);
    $emailStmt->execute();

    if ($emailStmt->rowCount() > 0) {
        http_response_code(409); // Código 409: Conflict
        echo json_encode(["message" => "El correo electrónico ya está registrado."]);
        exit;
    }

    // Intentar registrar el usuario
    $query = "INSERT INTO users SET name=:name, email=:email, password=:password, birth_date=:birth_date";
    $stmt = $db->prepare($query);

    $stmt->bindParam(":name", $data->name);
    $stmt->bindParam(":email", $data->email);

    // Cifrar la contraseña
    $hashed_password = password_hash($data->password, PASSWORD_BCRYPT);
    $stmt->bindParam(":password", $hashed_password);
    $stmt->bindParam(":birth_date", $data->birth_date);

    try {
        if ($stmt->execute()) {
            http_response_code(201); // Código 201: Created
            echo json_encode(["message" => "Usuario registrado con éxito."]);
        } else {
            http_response_code(500); // Código 500: Internal Server Error
            echo json_encode(["message" => "Error desconocido al registrar el usuario."]);
        }
    } catch (PDOException $e) {
        http_response_code(500); // Código 500: Internal Server Error
        echo json_encode(["message" => "Error en la base de datos: " . $e->getMessage()]);
    }
} else {
    http_response_code(400); // Código 400: Bad Request
    echo json_encode(["message" => "Todos los campos son obligatorios."]);
}
?>
