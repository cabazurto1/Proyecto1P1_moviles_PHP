<?php
// Permitir solicitudes CORS desde cualquier origen
header("Access-Control-Allow-Origin: *"); // O usa un origen específico: "http://localhost:62823"
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE"); // Métodos permitidos
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Cabeceras permitidas

// Manejar la solicitud OPTIONS (preflight request) que hace el navegador
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    // Respondemos a la solicitud OPTIONS con un 200 OK y salimos
    http_response_code(200);
    exit();
}

require '../config/database.php';

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));
$response = [];

if (!empty($data->name) && !empty($data->email) && !empty($data->password) && !empty($data->birth_date)) {
    $query = "INSERT INTO users SET name=:name, email=:email, password=:password, birth_date=:birth_date";

    $stmt = $db->prepare($query);
    $stmt->bindParam(":name", $data->name);
    $stmt->bindParam(":email", $data->email);

    $hashed_password = password_hash($data->password, PASSWORD_BCRYPT);
    $stmt->bindParam(":password", $hashed_password);
    $stmt->bindParam(":birth_date", $data->birth_date);

    if ($stmt->execute()) {
        http_response_code(201);
        $response["message"] = "Usuario creado exitosamente.";
    } else {
        http_response_code(400);
        $response["message"] = "Error al crear el usuario.";
    }
} else {
    http_response_code(400);
    $response["message"] = "Datos incompletos.";
}

echo json_encode($response);
?>
