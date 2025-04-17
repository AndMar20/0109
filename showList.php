<?php
require_once 'connection.php';
$conn = mysqli_connect($host, $user, $password, $database);
if (!$conn) {
    die("Ошибка подключения: " . mysqli_connect_error());
}

$N = 3; 

$category = $_POST['category'] ?? '';
$page = $_POST['page'] ?? 1;
$offset = ($page - 1) * $N;

if (isset($_POST['reset_category'])) {
    $category = ''; 
}

$cat_result = mysqli_query($conn, "SELECT DISTINCT category FROM games");
$categories = [];
while ($row = mysqli_fetch_assoc($cat_result)) {
    $categories[] = $row['category'];
}

$count_sql = "SELECT COUNT(*) as total FROM games";
if ($category !== '') {
    $count_sql .= " WHERE category = '$category'";
}
$count_result = mysqli_query($conn, $count_sql);
$total = mysqli_fetch_assoc($count_result)['total'];
$totalPages = ceil($total / $N);

$sql = "SELECT * FROM games";
if ($category !== '') {
    $sql .= " WHERE category = '$category'";
}
$sql .= " LIMIT $offset, $N";
$result = mysqli_query($conn, $sql);
?>

<form method="post" style="margin-bottom: 20pt;">
    <strong>Категории:</strong>
    <button type="submit" name="reset_category" value="yes">Все</button>
    <?php foreach ($categories as $cat): ?>
        <?php if ($cat === $category): ?>
            <span style="font-weight: bold;"><?= $cat ?></span>
        <?php else: ?>
            <button type="submit" name="category" value="<?= $cat ?>"><?= $cat ?></button>
        <?php endif; ?>
    <?php endforeach; ?>
</form>

<form method="post" style="margin-top: 20pt;">
    <?php for ($i = 1; $i <= $totalPages; $i++): ?>
        <button type="submit" name="page" value="<?= $i ?>" <?= $i == $page ? 'disabled' : '' ?>><?= $i ?></button>
    <?php endfor; ?>
    <input type="hidden" name="category" value="<?= $category ?>">
</form>

<?php while ($row = mysqli_fetch_assoc($result)): ?>
    <h3><?= $row['name'] ?></h3>
    <p><?= $row['description'] ?></p>
    <p><strong><?= number_format($row['price'], 2, ',', ' ') ?> руб.</strong></p>
	<hr>
<?php endwhile; ?>

<?php mysqli_close($conn); ?>