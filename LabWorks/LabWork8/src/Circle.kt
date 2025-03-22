import kotlin.math.PI

class Circle(val radius:Double) : Figure(){
    override val title: String = "Круг"
    override fun square() {
        println("Площадь круга: ${PI * radius * radius}")
    }
    override fun perimeter(){
        println("Периметр круга: ${2* PI * radius}")
    }
    override fun information(){
        println(title)
        println(radius)
        println(square())
        println(perimeter())
    }
}