package com.example.labwork18

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.labwork18.screens.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val current = mutableStateOf(Screen.Authorization)

        setContent {
            Column(Modifier.padding(10.dp, 50.dp)) {
                when (current.value) {
                    Screen.Authorization -> AuthorizationScreen(
                        onNavigateToProduct = { current.value = Screen.Product }
                    )

                    Screen.Product -> ProductScreen(
                        onNavigateToProductWithCart = { current.value = Screen.ProductWithCart },
                        onNavigateToOrder = { current.value = Screen.Order },
                        onNavigateToAppInfo = { current.value = Screen.AppInfo }
                    )

                    Screen.ProductWithCart -> ProductWithCartScreen(
                        onNavigateToOrder = { current.value = Screen.Order },
                    )

                    Screen.Order -> OrderScreen(
                        onNavigateToProduct = { current.value = Screen.Product }
                    )

                    Screen.AppInfo -> AppInfoScreen(
                        onNavigateToProduct = { current.value = Screen.Product }
                    )
                }
            }
        }
    }
}
enum class Screen {
    Authorization,
    Product,
    ProductWithCart,
    Order,
    AppInfo,
}