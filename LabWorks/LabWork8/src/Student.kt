class Student(_name: String, _age: Int, _group: String) : Human(_name, _age) {
   var group:String = _group
   override var info: String = "${super.info}, Группа: $group"
   override fun toString(): String {
      return ("${super.toString()}, Группа: $group")
   }

   override fun inform(){
      super.inform()
      println("Группа: $group")
   }
}