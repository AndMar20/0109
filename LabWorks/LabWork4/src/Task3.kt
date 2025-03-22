import java.text.Format

fun main()
{
    val USD:Double = 103.3;
    val EUR:Double = 109.4;
    print("Введите сумму в рублях: ");
    var summ:Double = readln().toDouble();
    print("выберите валюту ('USD', 'EUR'): ");
    var currency = readln();
    if (currency == "USD")
        print("%.2f".format(summ / USD))
    else
        print("%.2f".format(summ / EUR))
}