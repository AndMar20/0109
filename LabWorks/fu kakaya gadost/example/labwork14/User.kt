package com.example.labwork14

/**
 * Класс, предаставляющий логин и пароль пользователя
 *
 * @property [login] Логин пользователя
 * @property [password] Пароль пользователя
 */
data class User(val login: String, val password: String){
    /**
     * Проверяет, совпадает ли введенный пароль с паролем пользователя
     *
     * @param [inputPassword] Пароль для проверки
     * @return true, если пароли совпадают, иначе false
     */

    fun isPasswordCorrect(inputPassword: String) : Boolean{
        return password == inputPassword
    }
}