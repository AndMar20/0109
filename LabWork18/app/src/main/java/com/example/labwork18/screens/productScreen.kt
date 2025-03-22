package com.example.labwork18.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun ProductScreen(onNavigateToProductWithCart: () -> Unit, onNavigateToOrder: () -> Unit, onNavigateToAppInfo: () -> Unit) {
    var buttonText by remember { mutableStateOf("Добавить в корзину") }
    var buttonColor by remember { mutableStateOf(Color.Black) }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Название товара:  Крутая штука", fontSize = 20.sp)
        Text("Цена: 999р", fontSize = 18.sp)
        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                if (buttonText == "Добавить в корзину") {
                    buttonText = "Перейти в корзину"
                    buttonColor = Color.Blue
                } else {
                    onNavigateToProductWithCart()
                    buttonText = "Добавить в корзину"
                    buttonColor = Color.Black
                }
            },
            colors = ButtonDefaults.buttonColors(containerColor = buttonColor)
        ) {
            Text(buttonText)
        }

        val isAdded = remember { mutableStateOf(false) }
        Text("Товар:  Супер товар", fontSize = 20.sp)
        Text("Цена: 2000 руб.", fontSize = 18.sp)
        Spacer(modifier = Modifier.height(16.dp))

        ExtendedFloatingActionButton(
            onClick = { isAdded.value = !isAdded.value },
            icon = {
                Icon(
                    imageVector = if (isAdded.value) Icons.Filled.Delete else Icons.Filled.Add,
                    contentDescription = if (isAdded.value) "Удалить" else "Добавить"
                )
            },
            text = { Text(if (isAdded.value) "Удалить" else "Добавить") }
        )

        Button(
            onClick = { onNavigateToOrder() }
        ) {
            Text("К Заказам")
        }
        Button(
            onClick = { onNavigateToAppInfo() }
        ) {
            Text("О приложении")
        }

    }
}
