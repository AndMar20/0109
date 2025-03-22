package com.example.labwork21

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.labwork21.ui.theme.LabWork21Theme
import androidx.compose.foundation.layout.Row as Row1

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            LabWork21Theme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Greeting(
                        name = "Android",
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
}

@Composable
fun AuthScreen(onAuthorizeClick: (String, String) -> Unit) {
    var phoneNumber by remember { mutableStateOf("") }
    var code by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        OutlinedTextField(
            value = phoneNumber,
            onValueChange = { phoneNumber = it },
            label = { Text("Номер телефона") },
            placeholder = { Text("+7 (XXX) XXX-XX-XX") },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(8.dp))
        OutlinedTextField(
            value = code,
            onValueChange = { code = it },
            label = { Text("Код подтверждения") },
            placeholder = { Text("XXXXXX") },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(16.dp))
        Button(
            onClick = { onAuthorizeClick(phoneNumber, code) },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Авторизоваться")
        }
    }
}

@Composable
fun SearchBar(onSearchTextChanged: (String) -> Unit) {
    var searchText by remember { mutableStateOf("") }

    TextField(
        value = searchText,
        onValueChange = {
            searchText = it
            onSearchTextChanged(it) // Pass the text to the parent composable
        },
        leadingIcon = { Icon(Icons.Default.Search, contentDescription = "Search Icon") },
        placeholder = { Text("Поиск...") },
        modifier = Modifier.fillMaxWidth(),
        singleLine = true // Ensures it only takes up one line
    )
}

// --- Пример использования (Application) ---
@Composable
fun MainScreen() {
    var searchText by remember { mutableStateOf("") }

    Column(modifier = Modifier.fillMaxSize()) {
        SearchBar(onSearchTextChanged = { text -> searchText = text })

        // Example List
        val items = listOf("Item 1", "Item 2", "Item 3", "Item 4", "Item 5").filter { it.contains(searchText, ignoreCase = true) }

        LazyColumn {
            items(items.size) { index ->
                Text(text = items[index], modifier = Modifier.padding(8.dp))
            }
        }

    }
}

// 5.2
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AuthScreenWithDialog() {
    var login by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var showDialog by remember { mutableStateOf(false) }


// --- 5.3 Создание нескольких диалоговых окон AlertDialog ---

    @Composable
    fun AuthScreenWithMultipleDialogs() {
        var login by remember { mutableStateOf("") }
        var password by remember { mutableStateOf("") }
        var showWelcomeDialog by remember { mutableStateOf(false) }
        var showErrorDialog by remember { mutableStateOf(false) }

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            OutlinedTextField(
                value = login,
                onValueChange = { login = it },
                label = { Text("Логин") },
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(
                value = password,
                onValueChange = { password = it },
                label = { Text("Пароль") },
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(16.dp))
            Button(
                onClick = {
                    if (login.isNotEmpty() && password.isNotEmpty()) {
                        showWelcomeDialog = true
                    } else {
                        showErrorDialog = true
                    }
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Авторизоваться")
            }
        }

        if (showWelcomeDialog) {
            AlertDialog(
                onDismissRequest = { showWelcomeDialog = false },
                title = { Text("Авторизация") },
                text = { Text("Добро пожаловать, $login") },
                confirmButton = {
                    Button(onClick = { showWelcomeDialog = false }) {
                        Text("OK")
                    }
                }
            )
        }

        if (showErrorDialog) {
            AlertDialog(
                onDismissRequest = { showErrorDialog = false },
                title = { Text("Ошибка") },
                text = { Text("Пожалуйста, заполните все поля.") },
                confirmButton = {
                    Button(onClick = { showErrorDialog = false }) {
                        Text("OK")
                    }
                },
                dismissButton = {
                    Button(onClick = { showErrorDialog = false }) {
                        Text("Отмена")
                    }
                }
            )
        }
    }


// --- 5.4 Настройка внешнего вида диалогового окна ---

    @Composable
    fun AuthScreenWithStyledDialogs() {
        var login by remember { mutableStateOf("") }
        var password by remember { mutableStateOf("") }
        var showWelcomeDialog by remember { mutableStateOf(false) }
        var showErrorDialog by remember { mutableStateOf(false) }

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            OutlinedTextField(
                value = login,
                onValueChange = { login = it },
                label = { Text("Логин") },
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(
                value = password,
                onValueChange = { password = it },
                label = { Text("Пароль") },
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(16.dp))
            Button(
                onClick = {
                    if (login.isNotEmpty() && password.isNotEmpty()) {
                        showWelcomeDialog = true
                    } else {
                        showErrorDialog = true
                    }
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Авторизоваться")
            }
        }

        if (showWelcomeDialog) {
            AlertDialog(
                onDismissRequest = { showWelcomeDialog = false },
                title = { Text("Авторизация") },
                text = { Text("Добро пожаловать, $login") },
                confirmButton = {
                    Button(onClick = { showWelcomeDialog = false }) {
                        Text("OK")
                    }
                },
                buttons = {
                    Row(
                        modifier = Modifier.padding(all = 8.dp),
                        horizontalArrangement = Arrangement.End
                    ) {
                        Spacer(Modifier.weight(1f)) // Pushes buttons to the right
                        TextButton(
                            onClick = { showWelcomeDialog = false },
                            colors = ButtonDefaults.textButtonColors(contentColor = Color.Green) // Customize color
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Check,
                                contentDescription = "OK",
                                modifier = Modifier.size(ButtonDefaults.IconSize)
                            )
                            Spacer(Modifier.size(ButtonDefaults.IconSpacing))
                            Text("OK")
                        }
                    }
                }

            )
        }

        if (showErrorDialog) {
            Row {
                AlertDialog(
                    { showErrorDialog = false },
                    { Text("Ошибка") },
                    text = { Text("Пожалуйста, заполните все поля.") },
                    buttons = {
                        Row(
                            modifier = Modifier.padding(all = 8.dp),
                            horizontalArrangement = Arrangement.End
                        ) {
                            TextButton(
                                onClick = { showErrorDialog = false },
                                colors = ButtonDefaults.textButtonColors(contentColor = Color.Red)
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.Close,
                                    contentDescription = "Cancel",
                                    modifier = Modifier.size(ButtonDefaults.IconSize)
                                )
                                Spacer(Modifier.size(ButtonDefaults.IconSpacing))
                                Text("Отмена")
                            }
                            Button(
                                onClick = { showErrorDialog = false },
                                colors = ButtonDefaults.buttonColors(backgroundColor = Color.LightGray)
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.Check,
                                    contentDescription = "OK",
                                    modifier = Modifier.size(ButtonDefaults.IconSize)
                                )
                                Spacer(Modifier.size(ButtonDefaults.IconSpacing))
                                Text("OK")
                            }
                        }
                    })
            }
        }
    }


    @Composable
    fun Greeting(name: String, modifier: Modifier = Modifier) {
        Text(
            text = "Hello $name!",
            modifier = modifier
        )
    }

    @Preview(showBackground = true)
    @Composable
    fun GreetingPreview() {
        LabWork21Theme {
            Greeting("Android")
        }
    }
}