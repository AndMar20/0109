fun main()
{
    var a: Double
    while (true)
    {
        print("Введите a: ")
        try
        {
            a = readln().toDouble()
            break
        } catch (e: NumberFormatException)
        {
            println("Некорректно введен a! Пожалуйста, введите число.")
        }
    }
    var b: Double
    while (true)
    {
        print("Введите b: ")
        try
        {
            b = readln().toDouble()
            break
        } catch (e: NumberFormatException)
        {
            println("Некорректно введен b! Пожалуйста, введите число.")
        }
    }
    var x1: Double
    while (true)
    {
        print("Введите x1: ")
        try
        {
            x1 = readln().toDouble()
            break
        } catch (e: NumberFormatException)
        {
            println("Некорректно введен x1! Пожалуйста, введите число.")
        }
    }
    var x2: Double
    while (true)
    {
        print("Введите x2: ")
        try
        {
            x2 = readln().toDouble()
            break
        } catch (e: NumberFormatException)
        {
            println("Некорректно введен x2! Пожалуйста, введите число.")
        }
    }

    val range = x1.toInt()..x2.toInt()
    for (i in range)
    {
        println("y(x)=$a * $i + $b = ${a * i + b}")
    }

}