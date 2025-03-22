import kotlinx.coroutines.*

suspend fun main(){

    sheep()
    cat()
    println(Thread.currentThread().name)
}
suspend fun sheep() = coroutineScope {
    launch {
        println(Thread.currentThread().name)
        for (i in 1..1000) {
            if(i == 501){
                delay(1000L)}
            println("$i овечка")
        }
    }
}

suspend fun cat() = coroutineScope {
    launch {
        for (i in 1..500) {
            println("$i котик")
            delay(10L)
        }
        println(Thread.currentThread().name)
    }
}