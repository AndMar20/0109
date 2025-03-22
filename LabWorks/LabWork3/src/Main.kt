import java.io.CharArrayWriter
import java.io.Console
import kotlin.math.PI
import kotlin.math.pow
import kotlin.math.round
import kotlin.random.Random

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
fun main()
{
    //Task1
//    print(message = "Введите число a: ");
//    var a: Double = readln().toDouble();
//    print(message ="Введите число b: ");
//    var b: Double = readln().toDouble();
//    print(message ="Введите действие: ");
//    val sign = readln();
//    when(sign)
//    {
//        "+" -> println( "$a + $b = ${a + b}" );
//        "-" -> println( "$a - $b = ${a - b}" );
//        "*" -> println( "$a * $b = ${a * b}" );
//        "/" -> println( "$a / $b = ${a / b}" );
//        "%" -> println( "$a % $b = ${a % b}" );
//        else -> println(message = "Неверный выбор")
//    }

    //Task2
//    print(message = "Введите имя: ");
//    var name: String = readln();
//    print(message = "Введите рост(в метрах): ");
//    var height: Double = readln().toDouble();
//    print(message = "Введите массу тела(целое число в килограммах): ");
//    var mass: Int = readln().toInt();
//    var imt: Double = mass.toDouble()/(height*height);
//    println(message = "${name}, ваш ИМТ =${imt}");

    //Task3
//    print(message = "Введите целое число n: ");
//    var secg: Int = readln().toInt();
//    var hour: String = String.format("%02d" , secg / 3600);
//    var min: String = String.format("%02d" , secg % 3600 / 60);
//    var sec: String = String.format("%02d" , secg % 3600 % 60 % 60);
//
//    print(message = "${hour}:${min}:${sec}")

    //Task4
//    print(message = "Введите год: ")
//    var year: Int = readln().toInt();
//    var isleap: Boolean = false;
//    if (year % 4 == 0 && year % 100 > 0 || year % 400 == 0)
//        isleap = true;
//    else
//        isleap = false;
//    if (!isleap)
//        print(message = "${year} - год невисокосный")
//    else
//        print(message = "${year} - год високосный")

    //Task5
//    print(message = "Введите число a: ");
//    var a: Int = readln().toInt();
//    print(message = "Введите число b: ");
//    var b: Int = readln().toInt();
//    var random = Random.nextInt(a, b+1);
//    var randomDouble = Random.nextDouble(a.toDouble(), b.toDouble());
//
//    println(message = "Случайное целое число в диапазоне ${a} - ${b} : ${random}")
//    println(message = "Случайное вещественное число в диапазоне ${a} - ${b} : ${randomDouble}")

    //Task6
//    print(message = "Введите внешний радиус: ");
//    var outR: Double = readln().toDouble();
//    print(message = "Введите внутренний радиус: ");
//    var innR: Double = readln().toDouble();
//
//    var outRS: Double = PI * outR.pow(2);
//    var innRS: Double = PI * innR.pow(2);
//    var ringS: Double = outRS - innRS;
//    var roundS: Double = round(ringS*1000)/1000
//
//    println(message = "S = ${roundS}");


}

//    val name = "Kotlin"
//    //TIP Press <shortcut actionId="ShowIntentionActions"/> with your caret at the highlighted text
//    // to see how IntelliJ IDEA suggests fixing it.
//    println("Hello, " + name + "!")
//
//    for (i in 1..5) {
//        //TIP Press <shortcut actionId="Debug"/> to start debugging your code. We have set one <icon src="AllIcons.Debugger.Db_set_breakpoint"/> breakpoint
//        // for you, but you can always add more by pressing <shortcut actionId="ToggleLineBreakpoint"/>.
//        println("i = $i")
//    }


