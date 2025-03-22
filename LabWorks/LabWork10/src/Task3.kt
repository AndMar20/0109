import kotlinx.coroutines.*
import kotlinx.coroutines.time.withTimeout

suspend fun main() = runBlocking{
    connect()
}

suspend fun connect() = coroutineScope {
    try {
        withTimeout(10000) {
            for (i in 1..5) {
                println("Попытка подключения к БД")
                delay(3000)
            }
            println("Подключено к БД")
        }
    } catch (e: TimeoutCancellationException) {
        println("Превышено время ожидания подключения к БД")
    }
}