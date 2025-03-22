fun main(){
    println(abs(readln().toInt()))
}

fun abs(number:Int): Int = if (number < 0)  -number else number