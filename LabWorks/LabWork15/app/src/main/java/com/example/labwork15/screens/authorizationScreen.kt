package com.example.labwork15.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.res.imageResource
import androidx.compose.ui.unit.sp
import com.example.labwork15.R

@Composable
fun authorizationScreen(onNavigateToRegister: () -> Unit, onNavigateToProfile: () -> Unit) {
    val loginMessage = remember { mutableStateOf("") }
    val passwordMessage = remember { mutableStateOf("") }

    Column(Modifier.fillMaxSize().background(color = Color(0xfffff0ff)), verticalArrangement = Arrangement.Center, horizontalAlignment = Alignment.CenterHorizontally) {
        Text("Авторизация")

        Text("Логин", fontSize = 28.sp)
        TextField(
            loginMessage.value,
            onValueChange = { newText -> loginMessage.value = newText },
        )

        Text("Пароль", fontSize = 28.sp)
        TextField(
            passwordMessage.value,
            onValueChange = { newText -> passwordMessage.value = newText }
        )

        Row {
            Button(onClick = {
                onNavigateToProfile()
            }) {
                Image(bitmap = ImageBitmap.imageResource(R.drawable.`enter`), null)
            }
        }
        Row{
            Button(onClick = {
                onNavigateToRegister()
            }) {
                Image( bitmap = ImageBitmap.imageResource(R.drawable.`register`), null )
            }
        }
    }
}