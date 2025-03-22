import kotlin.math.PI

fun main(){
    square(2.0)
    square(2.0, 3.0)
}
fun square(r:Double) {
    var square = PI * (r*r)
    println("Площадь круга ${"%.2f".format(square)}")
}
fun square(lB:Double, lS:Double){
    var square = PI * lB * lS
    println("Площадь эллипса ${"%.2f".format(square)}")
}