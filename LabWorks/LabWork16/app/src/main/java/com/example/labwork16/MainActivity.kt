package com.example.labwork16

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringArrayResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import java.util.Calendar
import androidx.compose.foundation.layout.*
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.sp


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
        }
    }
}

@Composable
fun MyButtons() {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Button(onClick = { Enum }, modifier = Modifier.padding(8.dp)) {
            Text(stringResource(id = R.string.ok))
        }

        Button(onClick = { Enum }, modifier = Modifier.padding(8.dp)) {
            Text(stringResource(id = R.string.register))
        }

        Button(onClick = { Enum }, modifier = Modifier.padding(8.dp)) {
            Text(stringResource(id = R.string.enter))
        }
        Button(onClick = { Enum }, modifier = Modifier.padding(8.dp)) {
            Text(stringResource(id = R.string.find))
        }

    }
}

@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    MyButtons()
}

@Composable
fun DisplaySeasons() {
    val context = LocalContext.current
    val seasons = stringArrayResource(id = R.array.seasons)

    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        seasons.forEach { season ->
            Text(text = season, modifier = Modifier.padding(4.dp))
        }
    }
}

@Preview(showBackground = true)
@Composable
fun DisplaySeasonsPreview() {
    DisplaySeasons()
}

@Composable
fun DisplayTimeWithPlurals() {
    val context = LocalContext.current
    val calendar = Calendar.getInstance()
    val hours = calendar.get(Calendar.HOUR_OF_DAY)
    val minutes = calendar.get(Calendar.MINUTE)

    val hoursText = pluralStringResource(id = R.plurals.hours, count = hours, hours)
    val minutesText = pluralStringResource(id = R.plurals.minutes, count = minutes, minutes)

    Text(text = "$hoursText $minutesText")
}

@Preview(showBackground = true)
@Composable
fun DisplayTimeWithPluralsPreview() {
    DisplayTimeWithPlurals()
}

@Composable
fun DisplayFormattedString() {
    val username = "Ispp"
    val currentYear = 2025
    val formattedText = stringResource(id = R.string.user, username, currentYear)

    Text(text = formattedText)
}

@Preview(showBackground = true)
@Composable
fun DisplayFormattedStringPreview() {
    DisplayFormattedString()
}

@Composable
fun CustomButtonsAndRow() {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Row(
            modifier = Modifier.padding(dimensionResource(id = R.dimen.row_padding))
        ) {
            Button(
                onClick = { Enum },
                modifier = Modifier.width(dimensionResource(id = R.dimen.button_width))
                    .height(dimensionResource(id = R.dimen.button_height))
                    .padding(dimensionResource(id = R.dimen.button_padding))
            ) {
                Text("Button 1")
            }

            Button(
                onClick = { Enum },
                modifier = Modifier.width(dimensionResource(id = R.dimen.button_width))
                    .height(dimensionResource(id = R.dimen.button_height))
                    .padding(dimensionResource(id = R.dimen.button_padding))
            ) {
                Text("Button 2")
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun CustomButtonsAndRowPreview() {
    CustomButtonsAndRow()
}

@Composable
fun ImageExamples() {
    Surface() { }
    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Image(
            painter = painterResource(id = R.drawable.ic_android_black_24dp),
            contentDescription = "Векторное изображение",
            modifier = Modifier.size(100.dp)
        )

        Spacer(modifier = Modifier.height(16.dp))

        Surface(shape = CircleShape, modifier = Modifier.size(100.dp)) {
            Image(
                painter = painterResource(id = R.drawable.cat),
                contentDescription = "Растровое изображение (круглым)",
                contentScale = ContentScale.Crop
            )
        }

        Spacer(modifier = Modifier.height(16.dp))
        Image(
            painter = painterResource(id = R.drawable.cat),
            contentDescription = "Растровое изображение",
            contentScale = ContentScale.Fit,
            modifier = Modifier.size(100.dp)
        )
        Spacer(modifier = Modifier.height(16.dp))
        Image(
            painter = painterResource(id = R.drawable.cat),
            contentDescription = "Растровое изображение",
            contentScale = ContentScale.None,
            modifier = Modifier.size(100.dp)
        )
        Spacer(modifier = Modifier.height(16.dp))
        Image(
            painter = painterResource(id = R.drawable.cat   ),
            contentDescription = "Растровое изображение",
            contentScale = ContentScale.Inside,
            modifier = Modifier.size(100.dp)
        )
        Spacer(modifier = Modifier.height(16.dp))
        Image(
            painter = painterResource(id = R.drawable.cat),
            contentDescription = "Растровое изображение",
            contentScale = ContentScale.FillWidth,
            modifier = Modifier.size(100.dp)
        )
        Spacer(modifier = Modifier.height(16.dp))
        Image(
            painter = painterResource(id = R.drawable.cat),
            contentDescription = "Растровое изображение",
            contentScale = ContentScale.FillBounds,
            modifier = Modifier.size(100.dp)
        )
        Spacer(modifier = Modifier.height(16.dp))
        Image(
            painter = painterResource(id = R.drawable.ic_android_black_24dp),
            contentDescription = "Растровое изображение",
            contentScale = ContentScale.FillHeight,
            modifier = Modifier.size(100.dp)
        )
    }
}


@Preview(showBackground = true)
@Composable
fun ImageExamplesPreview() {
    ImageExamples()
}
val customFontFamily = FontFamily(
    Font(R.font.alfa)
)

@Composable
fun MyTextWithCustomFont() {
    val customTextStyle = TextStyle(
        fontFamily = customFontFamily,
        fontSize = 20.sp
    )
    Text(
        text = "abcdf",
        style = customTextStyle
    )
}
@Preview(showBackground = true)
@Composable
fun MyTextWithCustomFontPreview() {
    MyTextWithCustomFont()
}
