package user_example//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
fun main() {
    runBadUserExample()
    runGoodUserExample()
}

fun runBadUserExample() {
    println("--- Bad SRP Example ---")
    val badUser = BadUser("u123", "Alice Smith", "alice@example.com")

    if (badUser.isValid()) {
        badUser.saveToDatabase()
    } else {
        println("User is invalid, cannot save.")
    }

    println("\nDisplaying user info:\n${badUser.formatForDisplay()}")

    // Imagine a change: Now emails must end with ".org"
    // -> You change isValid() in BadUser

    // Imagine another change: Store users in a file instead of a DB
    // -> You change saveToDatabase() in BadUser

    // Imagine another change: Display user as a JSON string for a new API
    // -> You change formatForDisplay() in BadUser
    // Notice how BadUser changes for multiple unrelated reasons.
}

fun runGoodUserExample() {
    println("\n--- Good SRP Example ---")

    val userRepository = InMemoryUserRepository()
    val userValidator = UserValidatorImpl()
    val userPresenter = UserPresenterImpl()

    val userService = UserService(userRepository, userValidator, userPresenter)

    try {
        val alice = userService.createUser("u123", "Alice Wonderland", "alice@example.com")
        println("Created: ${alice.name}")

        val bob = userService.createUser("u124", "Bob The Builder", "bob@example.net")
        println("Created: ${bob.name}")

        println("\nFormatted for console:\n${userService.getFormattedUserDetails("u123")}")
        println("\nFormatted for JSON:\n${userService.getFormattedUserDetails("u124", "json")}")

        // Demonstrating a validation failure
        try {
            userService.createUser("u125", "", "invalid")
        } catch (e: IllegalArgumentException) {
            println("\nError creating user: ${e.message}")
        }

        // Demonstrating an update and re-saving
        val updatedBob = userService.activateUser("u124")
        println("\nUpdated Bob: ${updatedBob.name} (Active: ${updatedBob.isActive})")

    } catch (e: Exception) {
        println("An unexpected error occurred: ${e.message}")
    }
}