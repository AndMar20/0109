import kotlinx.coroutines.*

suspend fun main(): Unit = runBlocking{
    val downloading = launch(Dispatchers.IO) {
        download()
    }

    while (true) {
        println("Введите команду (cancel для отмены): ")
        val command = readln()

        if (command.lowercase() == "cancel") {
            println("Отмена загрузки...")
            downloading.cancelAndJoin()
            break
        }
    }
}

suspend fun download() = coroutineScope {
    try {
        for (i in 1..30) {
            println("Загрузка файла $i")
            delay(3000)
        }
        println("Все файлы загружены")
    } catch (e: CancellationException) {
        println("Загрузка отменена")
    }
}