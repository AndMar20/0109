package com.example.labwork17.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.res.imageResource
import com.example.labwork17.R

@Composable
fun profileScreen(onNavigateToAuthorization: () -> Unit, onNavigateToAboutMe: () -> Unit) {
    Column(
        Modifier.fillMaxSize().background(color = Color(0xfffff0ff)),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Твой профиль")
        Button(onClick = {
            onNavigateToAuthorization()
        }) {
            Text("Выйти")
        }
        Button(onClick = {
            onNavigateToAboutMe()
        }) {
            Text("Обо мне")
        }
    }
}
