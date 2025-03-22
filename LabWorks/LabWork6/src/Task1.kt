fun main() {
//    print("Введите начальное значение прогрессии: ")
//    val startMember:Int = readln().toInt()
//    print("Введите знаменатель прогрессии: ")
//    val denominator:Int = readln().toInt()
//    print("Введите номер прогрессии: ")
//    val number:Int = readln().toInt()
//    progression(startMember, denominator, number)
    progression(1,2,10)
    progression(number = 10)
}

fun  progression(startMember:Int =1 , denominator:Int = 2, number:Int) {
    var progression = startMember
    for (i in 1..number) {
        progression *= denominator
    }
    println("Значение геометрической прогрессии $progression")
}