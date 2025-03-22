import kotlin.math.abs

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
    var x: Double
    while (true)
    {
        print("Введите x: ")
        try
        {
            x = readln().toDouble()
            break
        } catch (e: NumberFormatException)
        {
            println("Некорректно введен x! Пожалуйста, введите число.")
        }
    }
    var func :Double = 0.0;
    if (x<-10)
        func = a * (x * x)
    else if (x < 10)
        func = a* abs(x)
    else
        func = 1/(a-x)
    println("${"%.3f".format(func)}");
}