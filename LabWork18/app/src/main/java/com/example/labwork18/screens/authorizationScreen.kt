package com.example.labwork18.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun AuthorizationScreen(onNavigateToProduct: () -> Unit) {
    var login by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var message by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        TextField(
            value = login,
            onValueChange = { login = it },
            label = { Text("Логин") },
            singleLine = true
        )
        Spacer(modifier = Modifier.height(8.dp))
        TextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Пароль") },
            singleLine = true
        )
        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                message = "$login, вы авторизованы" },
            shape = RoundedCornerShape(8.dp)
        ) {
            Text("Авторизоваться (Button)")
        }
        OutlinedButton(
            onClick = {
                onNavigateToProduct()
                message = "$login, вы авторизованы" },
            shape = RoundedCornerShape(8.dp)
        ) {
            Text("Авторизоваться (OutlinedButton)")
        }

        TextButton(
            onClick = {
                onNavigateToProduct()
                message = "$login, вы авторизованы" },
            shape = RoundedCornerShape(8.dp)
        ) {
            Text("Авторизоваться (TextButton)")
        }

        Spacer(modifier = Modifier.height(16.dp))
        Text(message)


    }
}

//@Preview(showBackground = true)
//@Composable
//fun DefaultPreview() {
//    authorizationScreen()
//}