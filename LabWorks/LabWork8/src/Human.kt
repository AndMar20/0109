open class Human (_name: String, _age: Int) {
    var name: String = _name
    var age: Int = _age
    open var info: String = "Имя: $name, Возраст: $age"
    override fun toString(): String {
        return ("Имя: $name, Возраст: $age")
    }
    open fun inform(){
        println("Имя: $name")
        println("Возраст: $age")
    }
}