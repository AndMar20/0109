import kotlin.random.Random

fun main() {
    val startPoint = 1
    val endPoint = 10
    val range = startPoint..endPoint
    val randomNumber = Random.nextInt(startPoint, endPoint)
    var number = 0

    do {
        print("Угадайте загаданное число от $startPoint до $endPoint: ")
        try {
            number = readln().toInt()
            if (number in range) {
                if (number > randomNumber)
                    println("Введите число меньше)")
                else if (number < randomNumber)
                    println("Введите число больше)")
            } else
                println("Введите число в диапазоне от $startPoint до $endPoint)")
        } catch (e: NumberFormatException) {
            println("Некорректно введено число, введите целое число)")
        }
    } while (randomNumber != number)
    println("Поздравляем, Вы молодец!!! 0_0")
}