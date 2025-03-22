fun main() {
    print("Введите сумму вклада: ")
    var deposit: Double = readln().toDouble()
    print("Введите процент годовых: ")
    val percent: Double = readln().toInt() * 0.01
    var year = 0
    while (deposit < 1000000) {
        year++
        deposit += (deposit * percent)
        println("в $year-й год ваш вклад составит: ${"%.2f".format(deposit)}")
    }
}
