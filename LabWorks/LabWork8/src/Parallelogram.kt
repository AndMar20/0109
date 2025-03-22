class Parallelogram (val base: Double, val height: Double, val side:Double) : IFigure, IPrinter{
    override val title: String = "Параллелограмм"
    override fun square(): Double {
        return base * height
    }
    override fun perimeter() : Double{
        return 2*(base +side)
    }
    override fun info(){
        println("Название: $title")
        println("Основание: $base")
        println("Высота: $height")
        println("Площадь: ${square()}")
        println("Периметр: ${perimeter()}")
    }
    override fun properties() {
        println("Основание: $base")
        println("Высота: $height")
        println("Боковая сторона: $side")
    }
}