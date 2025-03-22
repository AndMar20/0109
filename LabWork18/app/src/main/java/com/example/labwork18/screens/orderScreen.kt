package com.example.labwork18.screens

import androidx.compose.runtime.Composable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun OrderScreen(onNavigateToProduct: () -> Unit){
val productPrice = 50.0
var quantity by remember { mutableStateOf(1) }
var totalPrice by remember { mutableStateOf(productPrice) }
val maxQuantity = 10
val minQuantity = 1

Column(
modifier = Modifier
.fillMaxSize()
.padding(16.dp),
verticalArrangement = Arrangement.Center,
horizontalAlignment = Alignment.CenterHorizontally
) {
    Text("Товар: Отличный продукт", fontSize = 20.sp)
    Text("Цена: $productPrice руб.", fontSize = 18.sp)
    Spacer(modifier = Modifier.height(16.dp))

    Row(verticalAlignment = Alignment.CenterVertically) {
        IconButton(
            onClick = {
                if (quantity > minQuantity) {
                    quantity--
                    totalPrice = productPrice * quantity
                }
            },
            enabled = quantity > minQuantity
        ) {
            Icon(Icons.Filled.Delete, "Уменьшить")
        }

        Text("Количество: $quantity", fontSize = 18.sp)

        IconButton(
            onClick = {
                if (quantity < maxQuantity) {
                    quantity++
                    totalPrice = productPrice * quantity
                }
            },
            enabled = quantity < maxQuantity
        ) {
            Icon(Icons.Filled.Add, "Увеличить")
        }
    }

    Spacer(modifier = Modifier.height(16.dp))
    Text("Итоговая стоимость: $totalPrice руб.", fontSize = 20.sp)

    TextButton(
        onClick = {
            onNavigateToProduct()
           },
        shape = RoundedCornerShape(8.dp)
    ) {
        Text("К товарам")
    }
}
}
