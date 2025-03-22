fun main() {
    val failGroup1 = listOf("Кудряшов В.А.", "Маткадов А.П.", "Копосов С.С.", "Герасимов Э.К.", "Плетень П.П.")
    val failGroup2 = listOf("Себастьянов Я.З.", "Баранов Е.А.", "Маткадов А.П.", "Герасимов Э.К.", "Копосов С.С.")

    val all = failGroup1.union(failGroup2)
    println("Всего студентов на пересдачу: ${all.count()}")

    val twoFail = failGroup1.intersect(failGroup2)
    println("Не сдали оба зачета: ${twoFail.count()}")

    val onlyFail1 = failGroup1.subtract(failGroup2)
    val onlyFail2 = failGroup2.subtract(failGroup1)
    println("Не сдали только один зачет: ${onlyFail1.union(onlyFail2).count()}")

}