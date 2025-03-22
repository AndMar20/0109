package com.example.labwork20.screens2

import androidx.compose.foundation.layout.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Text

@Composable
fun ProductListScreen() {
    val productNames = listOf(
        "Товар 1", "Товар 2", "Товар 3", "Товар 4", "Товар 5",
        "Товар 6", "Товар 7", "Товар 8", "Товар 9", "Товар 10"
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Список товаров")
        Spacer(modifier = Modifier.height(16.dp))
        LazyColumn {
            items(productNames) { productName ->
                Text(text = productName, modifier = Modifier.padding(8.dp))
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun ProductListScreenPreview() {
    com.example.labwork20.screens1.ProductListScreen()
}