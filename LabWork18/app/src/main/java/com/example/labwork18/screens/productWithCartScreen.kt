package com.example.labwork18.screens
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.labwork18.R

@Composable
fun ProductWithCartScreen(onNavigateToOrder: () -> Unit) {
    var cartCount by remember { mutableStateOf(0) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Товар: Супер гаджет", fontSize = 20.sp)
        Text("Цена: 1500 руб.", fontSize = 18.sp)
        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = { cartCount++ }) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Image(
                    painter = painterResource(id = R.drawable.baseline_add_shopping_cart_24), // Замените на ваш ресурс
                    contentDescription = "Корзина",
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(4.dp))
                Text("Добавить")
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Text("В корзине: $cartCount")
        TextButton(
            onClick = {
                onNavigateToOrder()
            },
            shape = RoundedCornerShape(8.dp)
        ) {
            Text("К товарам")
        }

    }
}
