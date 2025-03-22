import kotlinx.coroutines.*
import kotlin.random.Random

suspend fun connectToWebServer(): Int {
    println("Подключение к веб-серверу")
    delay(1000)

    val httpStatusCodes = listOf(200, 400, 401, 403, 404, 410, 500)
    return httpStatusCodes[Random.nextInt(httpStatusCodes.size)]
}

fun main(): Unit = runBlocking {
    val deferredResult = GlobalScope.async { // Используем GlobalScope
        connectToWebServer()
    }

    println("Ожидание результата...")
    try {
        val statusCode = deferredResult.await()
        println("Код состояния HTTP: $statusCode")
    } catch (e: Exception) {
        println("Произошла ошибка: ${e.message}")
    }
}