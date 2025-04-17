<?php
require_once 'connection.php';
$conn = mysqli_connect($host, $user, $password, $database);

if (isset($_POST['confirmDel'])) {
    $id = $_POST['id'];
    $sql = "DELETE FROM games WHERE idGame = $id";
    if (mysqli_query($conn, $sql)) {
        echo "Товар успешно удалён.<br>";
    } else {
        echo "Ошибка: " . mysqli_error($conn);
    }
    echo "<a href='showTable.php'>Назад</a>";
}

elseif (isset($_POST['insert'])) {
    $name = $_POST['name'];
    $desc = $_POST['description'];
    $price = $_POST['price'];
    $cat = $_POST['category'];
    $sql = "INSERT INTO games (name, description, price, category) VALUES ('$name', '$desc', '$price', '$cat')";
    if (mysqli_query($conn, $sql)) {
        echo "Товар добавлен.<br>";
    } else {
        echo "Ошибка: " . mysqli_error($conn);
    }
    echo "<a href='showTable.php'>Назад</a>";
}

elseif (isset($_POST['update'])) {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $desc = $_POST['description'];
    $price = $_POST['price'];
    $cat = $_POST['category'];
    $sql = "UPDATE games SET name='$name', description='$desc', price='$price', category='$cat' WHERE id=$id";
    if (mysqli_query($conn, $sql)) {
        echo "Товар обновлён.<br>";
    } else {
        echo "Ошибка: " . mysqli_error($conn);
    }
    echo "<a href='showTable.php'>Назад</a>";
}

mysqli_close($conn);
?>