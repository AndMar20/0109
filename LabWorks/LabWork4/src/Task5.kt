import kotlin.math.abs

fun main()
{
    print("Введите сумму покупки: ");
    var sumBuy:Double = readln().toDouble();
    print("Введите внесённую сумму: ");
    var dep:Double = readln().toDouble();
    var discount:Int = 0
    if (sumBuy > 5000)
        discount = 10
    else if (sumBuy > 1000)
        discount = 5
    sumBuy = sumBuy - (sumBuy * (discount * 0.01));
    println("Сумма к оплате с учетом скидки $discount % : $sumBuy");
    var overMoney:Double = dep - sumBuy;
    when
    {
        (overMoney == 0.0) -> println("Спасибо!");
        (overMoney>0) -> println("Возьмите сдачу: ${"%.3f".format(overMoney)}");
        in -100000.0..0.0 -> println("Требуется доплатить ${"%.3f".format(abs(overMoney))}");
    }
}