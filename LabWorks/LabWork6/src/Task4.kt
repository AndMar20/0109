import kotlin.math.pow

fun main(){
    val startSum = 1000.0
    val percent = 10.0
    val years = 5


    val simplePercent = percent("simple")
    val simpleResult = simplePercent(startSum, percent, years)
    println("Сумма с простыми процентами: ${"%.2f".format(simpleResult)}")

    val hardPercent = percent("hard")
    val hardResult = hardPercent(startSum, percent, years)
    println("Сумма со сложными процентами: ${"%.2f".format(hardResult)}")
}

fun percent (type: String): (Double, Double, Int) -> Double {
    return when (type.lowercase()) {
        "simple" -> { initialSum, annualRate, years ->
            initialSum * (1 + (annualRate / 100) * years)
        }

        "hard" -> { initialSum, annualRate, years ->
            initialSum * (1 + (annualRate / 100)).pow(years)
        }

        else -> throw IllegalArgumentException("Неверный тип расчета процентов. Доступны 'simple' или 'hard'.")
    }
}