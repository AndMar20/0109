fun main() {
    var dic: MutableMap<String, String>
    mutableMapOf("RU" to "Россия", "UK" to "Великобритания", "US" to "Америка").also { dic = it }

    print("Введите ключ для поиска: ")
    val keyToFind = readln()

    if (dic.containsKey(keyToFind)) {
        println("Ключ '$keyToFind' найден. Значение: ${dic[keyToFind]}")
    } else {
        println("Ключ '$keyToFind' не найден в словаре.")
    }

    print("Введите значение для поиска совпадений: ")
    val valueToFind = readln()
    val count = dic.values.count { it == valueToFind }
    println("Количество совпадений: $count")

    print("Введите ключ для удаления: ")
    val keyToRemove = readln()

    if (dic.containsKey(keyToRemove)) {
        dic.remove(keyToRemove)
        println("Элемент удален.")
    }
    else {
        println("'$keyToRemove' не найден в словаре")
    }

    println("Обновленный словарь: $dic")
}
