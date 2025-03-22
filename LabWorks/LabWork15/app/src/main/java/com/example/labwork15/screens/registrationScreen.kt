package com.example.labwork15.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
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
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.sp
import com.example.labwork15.R

@Composable
fun registrationScreen(onNavigateToAuthorization: () -> Unit) {
    Column(
        Modifier.fillMaxSize().background(color = Color(0xfffff0ff)),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Регистраиця")

        val loginMessage = remember { mutableStateOf("") }
        val passwordMessage = remember { mutableStateOf("") }
        val confirmPasswordMessage = remember { mutableStateOf("") }
        val phoneNumberMessage = remember { mutableStateOf("") }
        val emailMessage = remember { mutableStateOf("") }
        val ageMessage = remember { mutableStateOf("") }
        val countryMessage = remember { mutableStateOf("") }

        Text("Логин", fontSize = 28.sp)
        TextField(
            loginMessage.value,
            onValueChange = { newText -> loginMessage.value = newText },
        )

        Text("Пароль", fontSize = 28.sp)
        TextField(
            passwordMessage.value,
            onValueChange = { newText -> passwordMessage.value = newText },
        )

        Text("Подтверждение пароля", fontSize = 28.sp)
        TextField(
            confirmPasswordMessage.value,
            onValueChange = { newText -> confirmPasswordMessage.value = newText },
        )

        Text("Номер телефона", style = MaterialTheme.typography.bodyLarge, fontSize = 28.sp)
        TextField(

            phoneNumberMessage.value,
            onValueChange = { newText -> phoneNumberMessage.value = newText },
            keyboardOptions = KeyboardOptions(keyboardType =  KeyboardType.Number),
        )

        Text("Почта", fontSize = 28.sp)
        TextField(
            emailMessage.value,
            onValueChange = { newText -> emailMessage.value = newText },
        )

        Text("Возраст", fontSize = 28.sp)
        TextField(
            ageMessage.value,
            onValueChange = { newText -> ageMessage.value = newText },
        )

        Text("Страна", fontSize = 28.sp)
        TextField(
            countryMessage.value,
            onValueChange = { newText -> countryMessage.value = newText },
        )

        Button(onClick = {
            onNavigateToAuthorization()
        }) {
            Image( bitmap = ImageBitmap.imageResource(R.drawable.`ok`), null )
            Text("ОК")
        }
    }
}