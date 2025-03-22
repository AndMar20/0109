class Animal (_type:String) {
    var type: String = _type
        set(value) {
            if (value.isEmpty()) {
                println("err")
            } else {
                field = value
            }
        }
    var age: Int = 1
        set(value) {
            if (value > 0)
                field = value
        }
        get() = field
    var weight: Double = 0.0
        set(value) {
            if (value > 0)
                field = value
        }
        get() = field
    var name: String = ""
        set(value) {
            if (value.length > 1)
                field = value
        }
        get() = field
    val lastParameter: String get() = "Имя: $name"

    constructor(_type: String, _age: Int, _weight: Double, _name: String) : this(_type) {
        age = _age
        weight = _weight
        name = _name
    }

    fun information(): String {
        return ("Тип:${type}, Возраст:${age}, Вес:${weight}, Кличка:${name} ")
    }
}