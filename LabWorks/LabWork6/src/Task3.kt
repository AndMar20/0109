fun main(){

   scope(42, 100, -42, 12, 10, 50, 500)

}
fun scope (vararg count: Int )
{
    val max = count.max()
    val min = count.min()
    val result = max - min
    println(result)
}