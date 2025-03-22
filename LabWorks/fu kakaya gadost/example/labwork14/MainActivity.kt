package com.example.labwork14

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.example.labwork14.ui.theme.LabWork14Theme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            LabWork14Theme {
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
/**
 * функция деления.
 *
 * эта функция делит a на b.
 *@param a делимое
 *@param b делитель
 *  @return Возвращает результат деления a/b
 *
 *  @exception IllegalArgumentException если делитель равен 0.0
 */
fun Divide(a: Double, b: Double): Double{
        if (b == 0.0) throw IllegalArgumentException("На ноль делить нельзя!")
        return a/b
}

/**
 * Выводит на экран "Hello {пользовательский текст}" с заданым Modifier
 *
 * @param [name] то, что будет писаться после "Hello"
 * @param [modifier] modifier, который будет применен к тексту
 */
@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
        /**
         * функция отображающая предварительный просмотр.
         *
         * эта функция отображает.
         *
         */
fun GreetingPreview() {
    LabWork14Theme {
        Greeting("Android")
    }
}
