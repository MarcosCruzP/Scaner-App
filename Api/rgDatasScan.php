<?php

$conn = mysqli_connect("Host", "User", "password", "BD");
if ($conn==false){
    echo "Hubo un problema al conectarse a María DB";
    die();
}


$NOM = $_POST['NOM'] ?? "";
$TEL = $_POST['TEL'] ?? "";
$EML = $_POST['EML'] ?? "";
$ORG = $_POST['ORG'] ?? "";
$DTA = $_POST['DTA'] ?? "";



$result = $conn->query("SELECT * FROM `evos.scandatos` WHERE `Nombre` = '".$NOM."' AND `Cadena` = '".$DTA."' AND `Telefono` = '".$TEL."'  ");
$modulos = $result->fetch_all(MYSQLI_ASSOC);

$count = count($modulos);

if($count == 0){
    $conn->query("INSERT INTO `evos.scandatos` ( `Nombre` ,`Telefono`,`Email`,`Organizacion`,`Cadena` )
    VALUES ('".$NOM."','".$TEL."','".$EML."','".$ORG."','".$DTA."' );");


}else{

}

echo "Guardado";

