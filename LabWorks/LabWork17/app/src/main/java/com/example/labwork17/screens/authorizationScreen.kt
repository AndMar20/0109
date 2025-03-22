package com.example.labwork17.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.runtime.*
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.TextFieldValue

@Composable
fun authorizationScreen(onNavigateToRegister: () -> Unit, onNavigateToProfile: () -> Unit) {
    var login by remember { mutableStateOf(TextFieldValue("")) }
    var password by remember { mutableStateOf(TextFieldValue("")) }
    var authMessage by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(color = Color(0xfffff0ff)),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        OutlinedTextField(
            value = login,
            onValueChange = { login = it },
            label = { Text("Логин") },
            placeholder = { Text("Введите логин") },
            modifier = Modifier.padding(bottom = 8.dp)
        )


        TextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Пароль") },
            placeholder = { Text("Введите пароль") },
            modifier = Modifier.padding(bottom = 16.dp)
        )

        Column {
            Button(
                onClick = {
                    if (login.text.isNotEmpty() && password.text.isNotEmpty()) {
                        authMessage = "${login.text}, вы авторизованы"
                    } else {
                        authMessage = "Пожалуйста, введите логин и пароль"
                    }
                }
            ) {
                Text("Авторизоваться")
            }
            Text(
                text = authMessage,
                modifier = Modifier.padding(top = 8.dp).padding(bottom = 8.dp)
            )
        }

        Row {
            Button(onClick = {
                onNavigateToRegister()
            }) {
                Text("Зарегистрироваться")
            }
        }
    }
}