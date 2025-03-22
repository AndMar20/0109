fun main() {
    val numbers = arrayListOf(1)
    print("Сколько добавить элементов: ")

    val count = readln().toInt()
    for (i in 2..100) {
        numbers.addLast(i)
    }

    for (i in 1..count) {
        numbers.addLast(readln().toInt())
    }

    println(numbers[100])
    var summ = 0
    for (i in 0..<numbers.count())
        summ += numbers[i]
    println("Сумма коллекции: $summ")

    println("Среднее значение коллекции: ${summ / numbers.count()}")
    val neg = numbers.filterNot { it > 0 }.count()
    if (neg == 0){
        println("Все числа больше нуля")
    }

    println(numbers.filter { it % 2 == 0 })
}
