package com.example.labwork17

import androidx.compose.runtime.mutableStateOf

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.labwork17.screens.*
import com.example.labwork17.ui.theme.LabWork17Theme


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        val current = mutableStateOf(Screen.Authorization)

        setContent {
            Column(Modifier.padding(10.dp, 50.dp)) {
                when (current.value) {
                    Screen.Authorization -> authorizationScreen(
                        onNavigateToProfile = { current.value = Screen.Profile },
                        onNavigateToRegister = { current.value = Screen.Register }

                    )

                    Screen.Register -> registrationScreen(
                        onNavigateToPinCode = { current.value = Screen.PinCode }
                    )

                    Screen.Profile -> profileScreen(
                        onNavigateToAuthorization = { current.value = Screen.Authorization },
                        onNavigateToAboutMe = { current.value = Screen.AboutMe }
                    )

                    Screen.PinCode -> pincodeScreen(
                        onNavigateToProfile = { current.value = Screen.Profile }
                    )

                    Screen.AboutMe -> aboutMeScreen(
                        onNavigateToProfile = { current.value = Screen.Profile }
                    )
                }
            }
        }
    }
}
enum class Screen {
    Authorization,
    Register,
    Profile,
    PinCode,
    AboutMe
}