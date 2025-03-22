fun main() {
    val fruits = arrayListOf("Banana", "Apple", "Pineapple")
    print("Сколько добавить элементов: ")
    val count = readln().toInt()
    for (i in 1..count) {
        fruits.addLast(readln())
    }

    for (i in 0..<fruits.count())
        println("${i + 1}) ${fruits[i]}")
}