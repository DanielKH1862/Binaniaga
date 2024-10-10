<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "praktikum";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$sql = "SELECT id, username, email, foto_profile, bio FROM users WHERE id = 5"; // Menambahkan kolom id dan bio
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  $row = $result->fetch_assoc();
  echo json_encode(["success" => true, "data" => $row]);
} else {
  echo json_encode(["success" => false, "message" => "User not found"]);
}
$conn->close();
?>