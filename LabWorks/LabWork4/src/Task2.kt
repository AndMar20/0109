fun main()
{
    print(message = "Введите год: ")
    var year: Int = readln().toInt();
    print(message = "Введите номер месяца: ")
    var mounth: Int = readln().toInt();
    var isleap: Boolean = year % 4 == 0 && year % 100 > 0 || year % 400 == 0;
    if (!isleap)
        println("${year} - год невисокосный ")
    else
        println("${year} - год високосный ")
    when(mounth)
    {
        1, 3, 5, 7, 8, 10, 12 -> println("31 день в $mounth месяце")
        4, 6, 9, 11 -> println("30 дней в $mounth месяце")
        2 -> if (!isleap)
                println("28 дней во $mounth месяце")
            else
                println("29 дней во $mounth месяце")
    }
}