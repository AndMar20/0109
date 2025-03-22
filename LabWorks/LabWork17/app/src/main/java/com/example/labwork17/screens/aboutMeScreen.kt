package com.example.labwork17.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.TextFieldValue

@Composable
fun aboutMeScreen(onNavigateToProfile: () -> Unit){
    var text by remember { mutableStateOf(TextFieldValue("")) }
    val maxChars = 50

    Column (

    )
    {
        OutlinedTextField(
            value = text,
            onValueChange = {
                if (it.text.length <= maxChars) text = it
            },
            label = { Text("О себе")},
            modifier = Modifier.fillMaxWidth()
        )

        Text(text = "Осталось символов: ${(maxChars - text.text.length)}")
        Button(onClick = {
            onNavigateToProfile()
        }) {
            Text("Назад")
        }
    }
}