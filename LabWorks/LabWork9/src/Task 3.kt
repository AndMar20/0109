fun main() {
    val dic: MutableMap<String, String> = mutableMapOf("RU" to "Россия", "UK" to "Великобритания", "US" to "Америка")

    print("Сколько добавить элементов: ")
    val count = readln().toInt()
    for (i in 1..count) {
        dic[readln()] = readln()
    }

    println("Количество ${dic.count()}")

    for (i in dic)
        println(i)

}
