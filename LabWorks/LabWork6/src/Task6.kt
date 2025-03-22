fun main() {
    val addAppleToCart = cart("Яблоко", 2.5)
    val addMilkToCart = cart("Молоко", 50.0)

    println(addMilkToCart(2))
    println(addAppleToCart(5))
}

fun cart(productName: String, productPrice: Double): (Int) -> String {
    return { quantity ->
        val totalPrice = productPrice * quantity
        "В корзину добавлен $productName на сумму $totalPrice"
    }
}