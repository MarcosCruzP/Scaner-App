<?php

$conn = mysqli_connect("Host", "User", "password", "BD");
if ($conn==false){
    echo "Hubo un problema al conectarse a María DB";
    die();
}



$consulta =   $conn->query("SELECT * FROM `evos.scandatos`  ");
$ver      =   mysqli_num_rows($consulta);
$lista    =   array();

   
while($datos = mysqli_fetch_assoc($consulta)){
    $fila = array('Nombre' => $datos['Nombre'],'Telefono'=> $datos['Telefono'],'Email'=> $datos['Email'],'Org' => $datos['Organizacion']);  
    array_push($lista,$fila);
}





echo json_encode($lista, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
  