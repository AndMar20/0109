fun main()
{
    print("Введите номер месяца: ");
    var mounth:Int = readln().toInt();
    when(mounth)
    {
        1, 2, 12 -> println("Зима");
        in 3.. 5 -> println("Весна");
        in 6.. 8-> println("Лето");
        in 9.. 11 -> println("Осень");
        else -> println("Такого месяца нет");
    }
}