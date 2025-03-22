package com.example.labwork20.screens3

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun ProductScreen(productName: String, productPrice: Double) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Товар")
        Spacer(modifier = Modifier.height(16.dp))
        Text("Название: $productName")
        Spacer(modifier = Modifier.height(8.dp))
        Text("Цена: $productPrice")
    }
}

@Preview(showBackground = true)
@Composable
fun ProductScreenPreview() {
    com.example.labwork20.screens1.ProductScreen(
        productName = "Пример товара",
        productPrice = 99.99
    )
}