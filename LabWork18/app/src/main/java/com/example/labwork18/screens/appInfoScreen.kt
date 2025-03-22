package com.example.labwork18.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.Email
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp


@Composable
fun AppInfoScreen(onNavigateToProduct: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Информация о приложении", fontSize = 24.sp)
        Spacer(modifier = Modifier.height(32.dp))

        FloatingActionButton(
            onClick = {  },
            modifier = Modifier.padding(8.dp)
        ) {
            Icon(Icons.Filled.Call, "Позвонить")
        }

        FloatingActionButton(
            onClick = { },
            modifier = Modifier.padding(8.dp)
        ) {
            Icon(Icons.Filled.Email, "Написать email")
        }

        FloatingActionButton(
            onClick = { onNavigateToProduct() },
            modifier = Modifier.padding(8.dp)
        ) {
            Text("К товарам")
        }
    }
}