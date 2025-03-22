package com.example.labwork17.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun pincodeScreen(onNavigateToProfile: () -> Unit) {
    Column(
        Modifier.fillMaxSize().background(color = Color(0xfffff0ff)),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        var f1 by remember { mutableStateOf(true) }
        var f2 by remember { mutableStateOf(true) }
        var isFourNumber by remember { mutableStateOf(false) }
        val pin = "1234"
        val attempts = remember { mutableStateOf(3) }

        val pinCode = remember { mutableStateOf("") }

        val mContext = LocalContext.current


        if (attempts.value < 1) {
            Text(
                text = "Доступ заблокирван",
                style = TextStyle(
                    fontSize = 8.sp,
                    color = Color.Red,
                    textAlign = TextAlign.Center
                ),
                fontSize = 40.sp
            )
        } else {
            TextField(
                value = pinCode.value,
                onValueChange = {
                    if (it.length <= 4) {
                        pinCode.value = it
                    }
                    if (it.length < 4) {
                        f2 = true
                        isFourNumber = false
                    } else {
                        isFourNumber = true
                    }
                },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                label = { Text("Числовой пароль") },
                placeholder = { Text("Введите числовой пароль") },
                modifier = Modifier.padding(bottom = 8.dp),
                singleLine = true,
            )
            if (isFourNumber) {
                if (f2) {
                    f1 = true
                    f2 = false
                }
                if (pin == pinCode.value) {
                    Text(
                        text = "Совпадение",
                        style = TextStyle(color = Color.Green),
                        fontSize = 14.sp
                    )
                } else {
                    if (f1) {
                        attempts.value--
                    }
                    f1 = false
                    Text(
                        text = "Осталось ${attempts.value} попытки",
                        style = TextStyle(color = Color.Red),
                        fontSize = 14.sp
                    )
                }
            }
            Button(onClick = {
                onNavigateToProfile()
            }) {
                Text("Войти")
            }
        }

    }
}


