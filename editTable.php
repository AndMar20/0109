<?php
require_once 'connection.php';
$conn = mysqli_connect($host, $user, $password, $database);

if (isset($_POST['del'])) {
    $id = $_POST['del'];
    echo "<div align='center'><h3>Вы уверены, что хотите удалить товар с ID = $id?</h3>";
    echo "<form method='post' action='saveTable.php'>
            <input type='hidden' name='id' value='$id'>
            <button type='submit' name='confirmDel'>Да</button>
            <a href='showTable.php'><button type='button'>Нет</button></a>
          </form></div>";
}

elseif (isset($_POST['ins'])) {
    
	echo  "<div align='center'><h3>Добавить товар</h3>
    <form method='post' action='saveTable.php'>
        Название: <input type='text' name='name'><br>
        Описание: <input type='text' name='description'><br>
        Цена: <input type='text' name='price'><br>
        Категория: <input type='text' name='category'><br>
        <button type='submit' name='insert'>Сохранить</button>
    </form></div>";
	
}

elseif (isset($_POST['upd'])) {
    $id = $_POST['upd'];
    $result = mysqli_query($conn, "SELECT * FROM games WHERE idGame = $id");
    $row = mysqli_fetch_assoc($result);

    echo "<div align='center'><h3>Редактировать товар</h3>
    <form method='post' action='saveTable.php'>
        <input type='hidden' name='id' value='$id'>
        Название: <input type='text' name='name' value='{$row['name']}'><br>
        Описание: <input type='text' name='description' value='{$row['description']}'><br>
        Цена: <input type='text' name='price' value='{$row['price']}'><br>
        Категория: <input type='text' name='category' value='{$row['category']}'><br>
        <button type='submit' name='update'>Сохранить</button>
    </form></div>";
}

mysqli_close($conn);
?>