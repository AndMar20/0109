<?php
require_once 'connection.php';
$conn = mysqli_connect($host, $user, $password, $database);
if (!$conn) {
    die("Ошибка подключения: " . mysqli_connect_error());
}

$price = $_POST['price'] ?? '';
$name = $_POST['name'] ?? '';
$desc = $_POST['description'] ?? '';
$sortBy = $_POST['sortBy'] ?? '';
$filter = $_POST['filter'] ?? 'yes';

$sql = "SELECT * FROM games WHERE 1";

if ($filter === 'yes') {
    if ($price !== '') {
        $sql .= " AND price <= " . (float)$price;
    }
    if ($name !== '') {
        $sql .= " AND name LIKE '%$name%'";
    }
    if ($desc !== '') {
        $sql .= " AND description LIKE '%$desc%'";
    }
}
else{
	$price = '';
	$name = '';
	$desc = '';
}
	

if ($sortBy === 'name' || $sortBy === 'price') {
    $sql .= " ORDER BY $sortBy";
}

$result = mysqli_query($conn, $sql);
?>

<form method="post" action="showTable.php" style="margin-bottom: 20px;">
    <input type="text" name="price" placeholder="Цена (<=)" value="<?= $price ?>">
    <input type="text" name="name" placeholder="Название содержит" value="<?= $name ?>">
    <input type="text" name="description" placeholder="Описание содержит" value="<?= $desc ?>">

    <label><input type="radio" name="sortBy" value="name" <?= $sortBy === 'name' ? 'checked' : '' ?>> По названию</label>
    <label><input type="radio" name="sortBy" value="price" <?= $sortBy === 'price' ? 'checked' : '' ?>> По цене</label>

    <button type="submit" name="filter" value="yes">Фильтровать</button>
    <button type="submit" name="filter" value="no">Очистить</button>
</form>



<form method="post" action="editTable.php">
    <button type="submit" name="ins">Добавить</button>
</form>

<table border="1" cellpadding="8" cellspacing="0">
    <tr>
        <th>Название</th>
        <th>Описание</th>
        <th>Цена</th>
    </tr>

    <? if (mysqli_num_rows($result) > 0):
         while ($row = mysqli_fetch_assoc($result)): ?>
            <tr>
				<td><?= $row['name'] ?></td>
				<td><?= $row['description'] ?></td>
				<td width=100pt><?= number_format($row['price'], 2, ',', ' ') ?> руб.</td>
				<form method="post" action="editTable.php">
				<input type="hidden" name="id" value="<?= $row['id'] ?>">
                <td>
                    <form method="post" action="editTable.php">
                        <button type="submit" name="upd" value="<?= $row['idGame'] ?>">Редактировать</button>
                    </form>
                    <form method="post" action="editTable.php">
                        <button type="submit" name="del" value="<?= $row['idGame'] ?>">Удалить</button>
                    </form>
                </td>
			</tr>
        <?php endwhile;
		else: ?>
        <tr><td colspan="3">Нет данных</td></tr>
    <?php endif; ?>
</table>

<?php mysqli_close($conn); ?>