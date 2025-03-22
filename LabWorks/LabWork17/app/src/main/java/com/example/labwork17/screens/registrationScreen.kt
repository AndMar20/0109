package com.example.labwork17.screens

import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Checkbox
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp

@Composable
fun registrationScreen(onNavigateToPinCode: () -> Unit) {

    Column(
        Modifier
            .fillMaxSize()
            .background(color = Color(0xfffff0ff))
            .verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Регистраиця")

        val login = remember { mutableStateOf("") }
        val password = remember { mutableStateOf("") }
        val confirmPassword = remember { mutableStateOf("") }
        val phoneNumber = remember { mutableStateOf("") }
        val email = remember { mutableStateOf("") }
        val age = remember { mutableStateOf("") }
        val site = remember { mutableStateOf("") }
        val pin = remember { mutableStateOf("") }


        TextField(
            login.value,
            onValueChange = { newText -> login.value = newText },
            label = { Text("Логин") },
            placeholder = { Text("Введите логин") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )

        TextField(
            password.value,
            onValueChange = { newText -> password.value = newText },
            label = { Text("Пароль") },
            placeholder = { Text("Введите пароль") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )

        TextField(
            confirmPassword.value,
            onValueChange = { newText -> confirmPassword.value = newText },
            label = { Text("Подтверждение пароля") },
            placeholder = { Text("Введите подтверждение пароля") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )

        TextField(

            phoneNumber.value,
            onValueChange = { newText -> phoneNumber.value = newText },
            keyboardOptions = KeyboardOptions(keyboardType =  KeyboardType.Number),
            label = { Text("Номер телефона") },
            placeholder = { Text("Введите номер телефона") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )

        TextField(
            email.value,
            onValueChange = { newText -> email.value = newText },
            label = { Text("Почта") },
            placeholder = { Text("Введите почту") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )

        TextField(
            age.value,
            onValueChange = { newText -> age.value = newText },
            keyboardOptions = KeyboardOptions(keyboardType =  KeyboardType.Number),
            label = { Text("Возраст") },
            placeholder = { Text("Введите возраст") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )

        TextField(
            site.value,
            onValueChange = { newText -> site.value = newText },
            label = { Text("Персональный сайт") },
            placeholder = { Text("Введите персональный сайт") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )
        val mContext = LocalContext.current
        TextField(
            pin.value,
            onValueChange = { newText ->
                if(pin.value.length < 4) pin.value = newText
                else Toast.makeText(mContext, "Код должен быть четырехзначным", Toast.LENGTH_SHORT).show()

            }
                   ,
            keyboardOptions = KeyboardOptions(keyboardType =  KeyboardType.Number),
            label = { Text("Числовой пароль") },
            placeholder = { Text("Введите числовой пароль") },
            modifier = Modifier.padding(bottom = 8.dp),
            singleLine = true,
        )

        var isChecked by remember { mutableStateOf(false)}
        Row(modifier = Modifier.fillMaxWidth())
        {
            Checkbox(
                checked = isChecked,
                onCheckedChange = { isChecked = it }
            )
            Text("Я согласен на обработку своих персональных данных и принимаю условия Политики конфиденциальности и Пользовательского соглашения")
        }

        val languages = listOf("English", "Русский")
        val selectedLanguages = remember { mutableStateMapOf<String, Boolean>() }

        Column(modifier = Modifier.padding(16.dp)) {
            Text("Выберите язык интерфейса:", style = MaterialTheme.typography.titleMedium)

            languages.forEach{ language ->
                Row(modifier = Modifier.fillMaxWidth()) {
                    Checkbox(
                        checked = selectedLanguages[language] ?: false,
                        onCheckedChange = {selectedLanguages[language] = it}
                    )
                    Text(text = language, Modifier.padding(16.dp))
                }
            }
        }

        //val options =
        Column() {

        }
        Button(
            enabled = isChecked,
            onClick = {
            onNavigateToPinCode()
        }) {

            Text("Зарегистрироваться")
        }
    }
}

//Row (
//modifier = Modifier
//.fillMaxWidth()
//.selectable(
//selected = (language == selectedLanguage),
//onClick = {selectedLanguage = language}
//).padding(8.dp)
//){
//    RadioButton(
//        selected = (language == selectedLanguage),
//        onClick = {selectedLanguage = language}
//    )
//}