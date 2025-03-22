package com.example.labwork19

import android.os.Bundle
import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.activity.ComponentActivity
import androidx.compose.foundation.lazy.grid.items
import kotlin.random.Random
import androidx.compose.ui.res.imageResource
import androidx.activity.compose.setContent
import androidx.annotation.DrawableRes
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Image
import androidx.compose.foundation.ScrollState
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyHorizontalGrid
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.ui.unit.dp
import androidx.compose.ui.graphics.ImageBitmap
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Column(
                ) {
                    //ProductListColumn(products = productList, cardType = { product -> ProductCardLeftImage(product = product) }) // Пример с LeftImage
                    // ProductListColumn(products = productList, cardType = { product -> ProductCardTopImage(product = product) }) // Пример с TopImage
                    // ProductListRow(products = productList, cardType = { product -> ProductCardTopImage(product = product) }) // Пример с TopImage
                    // ProductListColumnWithScroll(products = productList, cardType = { product -> ProductCardLeftImage(product = product) })
                     ProductVerticalGrid(products = productList, cardType = { product -> ProductCardTopImage(product = product) })
                     ProductHorizontalGrid(products = productList, cardType = { product -> ProductCardTopImage(product = product) })
                    // ProductListColumnWithLabel(products = productList, cardType = { product -> ProductCardTopImage(product) })
                }
            }
        }
    }
}

data class Product(
    val id: Int,
    val name: String,
    val price: Double,
    @DrawableRes val imageResId: Int
)

// 5.1.2 Список товаров
val productList = listOf(
    Product(0,"Яблоко", 100.2, R.drawable.apple),
    Product(1,"Банан", 50.2, R.drawable.banana),
    Product(2,"Хлеб", 30.6, R.drawable.bread),
    Product(3,"Капуста", 44.1, R.drawable.cabbage),
    Product(4,"Кофе", 300.7, R.drawable.coffe),
    Product(5,"Печенье", 150.5, R.drawable.cookies),
    Product(6,"Огурец", 21.0, R.drawable.cucumber),
    Product(7,"Яйца", 60.0, R.drawable.eggs),
    Product(8,"Мука", 100.0, R.drawable.flour),
    Product(9,"Пряник", 132.0, R.drawable.gingerbread),
    Product(10,"Сок", 119.0, R.drawable.juice),
    Product(11,"Мясо", 1500.0, R.drawable.meat),
    Product(12,"Молоко", 119.0, R.drawable.milk),
    Product(13,"Масло", 46.0, R.drawable.oil),
    Product(14,"Каша", 90.0, R.drawable.porridge),
    Product(15,"Сосиски", 400.0, R.drawable.sausage),
    Product(16,"Креветки", 2000.0, R.drawable.shrimp),
    Product(17,"Чай", 53.0, R.drawable.tea),
    Product(18,"Помидор", 22.0, R.drawable.tomato),
    Product(19,"Вода", 19.0, R.drawable.water)
)


// 5.1.3 Карточка с изображением слева
@Composable
fun ProductCardLeftImage(product: Product) {
    Card(
        modifier = Modifier
            .padding(8.dp)
            .fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Image(
                painter = painterResource(id = product.imageResId),
                contentDescription = product.name,
                modifier = Modifier
                    .size(80.dp)
                    .padding(end = 16.dp),
                contentScale = ContentScale.Crop
            )
            Column {
                Text(
                    text = product.name,
                    style = TextStyle(fontSize = 18.sp, fontWeight = FontWeight.Bold),
                    color = MaterialTheme.colorScheme.onSurface
                )
                Text(
                    text = "Цена: ${String.format("%.2f", product.price)} руб.",
                    style = TextStyle(fontSize = 16.sp),
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

// 5.1.4 Карточка с круглым изображением сверху
@Composable
fun ProductCardTopImage(product: Product) {
    Card(
        modifier = Modifier
            .padding(8.dp)
            .wrapContentWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)

    ) {
        Column(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally

        ) {
            Image(
                painter = painterResource(id = product.imageResId),
                contentDescription = product.name,
                modifier = Modifier
                    .size(100.dp)
                    .clip(CircleShape)
                    .border(2.dp, Color.Gray, CircleShape),
                contentScale = ContentScale.Crop,
                alignment = Alignment.Center
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = product.name,
                style = TextStyle(fontSize = 18.sp, fontWeight = FontWeight.Bold),
                color = MaterialTheme.colorScheme.onSurface
            )
            Text(
                text = "Цена: ${String.format("%.2f", product.price)} руб.",
                style = TextStyle(fontSize = 16.sp),
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

// 5.1.5 Пример использования с настройками стилей (модифицировано из предыдущих)
@Composable
fun StyledProductCard(product: Product) {
    Card(
        modifier = Modifier
            .padding(16.dp)
            .fillMaxWidth()
            .border(2.dp, Color.LightGray, MaterialTheme.shapes.medium),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
        colors = CardDefaults.cardColors(containerColor = Color(0xFFF0F0F0))
    ) {
        Column(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Image(
                painter = painterResource(id = product.imageResId),
                contentDescription = product.name,
                modifier = Modifier
                    .size(120.dp)
                    .clip(CircleShape),
                contentScale = ContentScale.Crop
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = product.name,
                style = TextStyle(fontSize = 20.sp, fontWeight = FontWeight.Bold),
                color = Color(0x3F3333FF)
            )
            Text(
                text = "Цена: ${String.format("%.2f", product.price)} руб.",
                style = TextStyle(fontSize = 18.sp),
                color = Color(0xFFFF6666)
            )
        }
    }
}

// 5.2.1 ProductListColumn
//@Composable
//fun ProductListColumn(products: List<Product>, cardType: @Composable (Product) -> Unit) {
//    LazyColumn(
//        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp) // Отступы для списка
//    ) {
//        items(products) { product ->
//            cardType(product) // Вызываем функцию, которая отображает карточку
//        }
//    }
//}
//
//// 5.2.2 ProductListColumnWithLabel
//@Composable
//fun ProductListColumnWithLabel(products: List<Product>, cardType: @Composable (Product) -> Unit) {
//    LazyColumn(
//        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
//    ) {
//        items(products) { product ->
//            Text(
//                text = "Товар: ${product.name}", // Метка
//                style = MaterialTheme.typography.bodyMedium, // Исправлено: используем правильный стиль
//                modifier = Modifier.padding(bottom = 4.dp, start = 8.dp)
//            )
//            cardType(product) // Вызываем функцию, которая отображает карточку
//        }
//    }
//}
//
//// 5.3.1 ProductListRow
//@Composable
//fun ProductListRow(products: List<Product>, cardType: @Composable (Product) -> Unit) {
//    LazyRow(
//        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
//    ) {
//        items(products) { product ->
//            cardType(product) // Вызываем функцию, которая отображает карточку
//        }
//    }
//}
//
//// 5.4.1 - 5.4.3 ProductListColumnWithScroll
//@Composable
//fun ProductListColumnWithScroll(products: List<Product>, cardType: @Composable (Product) -> Unit) {
//    val listState = rememberLazyListState()
//    val coroutineScope = rememberCoroutineScope()
//    val showButton = remember { derivedStateOf { listState.firstVisibleItemIndex > 0 } }
//
//    Box(modifier = Modifier.fillMaxSize()) {
//        LazyColumn(
//            state = listState,
//            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
//        ) {
//            items(products) { product ->
//                cardType(product) // Вызываем функцию, которая отображает карточку
//            }
//        }
//
//        AnimatedVisibility(
//            visible = showButton.value,
//            modifier = Modifier
//                .align(Alignment.BottomEnd)
//                .padding(16.dp),
//            enter = fadeIn(),
//            exit = fadeOut()
//        ) {
//            FloatingActionButton(
//                onClick = {
//                    coroutineScope.launch {
//                        listState.scrollToItem(index = 0)
//                    }
//                },
//                containerColor = MaterialTheme.colorScheme.secondary
//            ) {
//                Icon(Icons.Filled.KeyboardArrowUp, "Scroll to top")
//            }
//        }
//    }
//}

// 5.5.1, 5.5.2 ProductVerticalGrid


@Composable
fun ProductVerticalGrid(products: List<Product>, cardType: @Composable (Product) -> Unit) {
    LazyVerticalGrid(
        columns = GridCells.Fixed(2), // Количество столбцов
        contentPadding = PaddingValues(16.dp)
    ) {
        items(products) { product ->
            cardType(product) // Вызываем функцию, которая отображает карточку
        }
    }
}

// 5.6.1, 5.6.2 ProductHorizontalGrid


@Composable
fun ProductHorizontalGrid(products: List<Product>, cardType: @Composable (Product) -> Unit) {
    val lazyGridState = rememberLazyGridState()
    LazyHorizontalGrid(
        rows = GridCells.Fixed(2), // Количество строк
        state = lazyGridState,
        modifier = Modifier.height(400.dp), // Задайте высоту для видимости
        contentPadding = PaddingValues(16.dp)
    ) {
        items(products) { product ->
            cardType(product) // Вызываем функцию, которая отображает карточку
        }
    }
}

@Preview(showBackground = true)
@Composable
fun ProductListPreview() {
    MaterialTheme {
        LazyColumn {
            items(productList.size) { index ->
                //ProductCardLeftImage(product = productList[index])
                //ProductCardTopImage(product = productList[index])
                StyledProductCard(product = productList[index])
            }
        }
    }
}