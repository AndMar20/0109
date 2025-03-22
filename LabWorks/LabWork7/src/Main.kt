fun main(){
    val zebra: Animal = Animal("Polosaty")
    zebra.name = "Ivan"
    zebra.type = "Polosaty"
    zebra.age = 10
    zebra.weight = 20.1
    println(zebra.name)
    println(zebra.type)
    println(zebra.age)
    println(zebra.weight)
    val bobra: Animal = Animal("bobr", 2, 2.0, "Inocentyi")
    println(bobra.name)
    println(bobra.type)
    println(bobra.age)
    println(bobra.weight)
    println(bobra.information())
    println(zebra.lastParameter)
    val jiraf: Animal = Animal("Jiraf", 5, 202.0, "Dmirty")
    var array = arrayOf(zebra,bobra,jiraf)
    val filter = array.filter { animal -> animal.name.contains("Ivan") }
    filter.forEach {x-> println(x.information()) }
    println(zebra.information())
}