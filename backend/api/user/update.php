<?php
require '../config/database.php';

// Cabeceras CORS para permitir solicitudes desde cualquier dominio
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: Content-Type, Authorization, Origin, X-Requested-With");

// Si la solicitud es un preflight (OPTIONS), respondemos inmediatamente con un código 200
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));
$response = [];

// Verificar si el correo electrónico está presente en los datos
if (!empty($data->email)) {
    // Verificar si al menos uno de los campos a actualizar no está vacío
    if (!empty($data->name) || !empty($data->email) || !empty($data->birth_date)) {
        
        // Verificar que la fecha esté en formato correcto
        if (!empty($data->birth_date)) {
            $date = DateTime::createFromFormat('Y-m-d', $data->birth_date);
            if (!$date) {
                http_response_code(400);
                $response["message"] = "El formato de la fecha de nacimiento es incorrecto. Use DD-MM-YYYY.";
                echo json_encode($response);
                exit;
            }
            $birth_date = $date->format('Y-m-d'); // Convertir la fecha a formato Y-m-d para la base de datos
        } else {
            $birth_date = null; // Si no se envía fecha, se mantendrá como nulo
        }

        // Preparar la consulta de actualización buscando por el correo electrónico
        $query = "UPDATE users SET ";
        $fields = [];

        if (!empty($data->name)) $fields[] = "name = :name";
        if (!empty($data->email)) $fields[] = "email = :email";
        if (!empty($data->birth_date)) $fields[] = "birth_date = :birth_date";

        $query .= implode(", ", $fields) . " WHERE email = :email";  // Cambio aquí, se usa el correo

        $stmt = $db->prepare($query);
        $stmt->bindParam(":email", $data->email); // Usamos el correo como parámetro

        if (!empty($data->name)) $stmt->bindParam(":name", $data->name);
        if (!empty($data->birth_date)) $stmt->bindParam(":birth_date", $birth_date);

        if ($stmt->execute()) {
            http_response_code(200);
            $response["message"] = "Usuario actualizado";
        } else {
            http_response_code(400);
            $response["message"] = "Error al actualizar el usuario.";
        }
    } else {
        http_response_code(400);
        $response["message"] = "Se debe proporcionar al menos un campo para actualizar (nombre, correo o fecha de nacimiento).";
    }
} else {
    http_response_code(400);
    $response["message"] = "El correo electrónico del usuario es necesario para la actualización.";
}

echo json_encode($response);
?>
