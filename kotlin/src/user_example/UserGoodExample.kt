package user_example

/**
 * The Good Way: Adhering to SRP (Delegated Responsibilities)
 *  Here, we decompose the BadUser class into a simple data holder (User data class) and separate,
 *  specialized classes, each handling a single responsibility: UserRepository for persistence,
 *  UserValidator for validation, and UserPresenter for display formatting. A UserService (or UserManager)
 *  then orchestrates these independent components.
 */

/**
 * Explanation of Adherence to SRP:
 *
 *  Each class in the "Good Way" now has only one reason to change:
 *
 *  User (data class): Changes only if the core attributes of a user (e.g., adding phoneNumber) change.
 *      It holds no logic that would change for external reasons.
 *
 *  UserRepository: Changes only if the underlying data storage mechanism or schema
 *      (e.g., switching from in-memory to a database, or changing table structure) changes.
 *
 *  UserValidator: Changes only if the business rules for what constitutes a valid user
 *      (e.g., adding a new validation for age, changing email format requirements) change.
 *
 *  UserPresenter: Changes only if the way user data is formatted for display
 *      (e.g., creating a new UI component that needs a different JSON structure, or changing how names are
 *      displayed on a report) changes.
 *
 *  UserService: Its single responsibility is orchestration or managing the user lifecycle. It changes only
 *      if the high-level steps involved in creating, retrieving, or updating a user change (e.g., adding a step
 *      to send a welcome email after creation, or integrating with an external payment gateway).
 *      It delegates the specific technical tasks to its collaborators.
 *
 * This separation leads to:
 *
 *  High Cohesion: Each class's internal elements are highly related to its single purpose.
 *
 *  Loose Coupling: Changes in UserRepository (e.g., using a different database) won't require changes
 *      in UserValidator or UserPresenter, only the UserService would need an updated UserRepository dependency
 *      (which is a minor configuration change, not a fundamental logic change).
 *
 *  Easier Testing: Each component can be tested independently without needing to set up the entire system.
 *
 *  Improved Maintainability: Developers can easily find and modify the relevant code for a specific
 *      change without affecting unrelated parts.
 */

// Data class representing a User - now it ONLY holds data.
// It has no behavioral methods related to saving, validating, or formatting for display.
data class User(val id: String, var name: String, var email: String, var isActive: Boolean = true)

// --- Responsibility 1: User Persistence ---
// This interface/class handles saving and retrieving user data.
// It would change only if the persistence mechanism or data schema changes.
interface UserRepository {
    fun save(user: User): User
    fun findById(userId: String): User?
}

// Concrete implementation (e.g., in-memory for demonstration)
class InMemoryUserRepository : UserRepository {
    private val users = mutableMapOf<String, User>()

    override fun save(user: User): User {
        println("UserRepository: Saving user ${user.name} (${user.id}) to in-memory store...")
        users[user.id] = user
        return user
    }

    override fun findById(userId: String): User? {
        println("UserRepository: Finding user by ID: $userId from in-memory store.")
        return users[userId]
    }
}

// --- Responsibility 2: User Validation ---
// This interface/class handles validating user data against business rules.
// It would change only if the validation rules themselves change.
interface UserValidator {
    fun isValid(user: User): Boolean
    fun validate(user: User) // More explicit validation with exceptions
}

class UserValidatorImpl : UserValidator {
    override fun isValid(user: User): Boolean {
        return try {
            validate(user)
            true
        } catch (e: IllegalArgumentException) {
            false
        }
    }

    override fun validate(user: User) {
        println("UserValidator: Validating user ${user.name} (${user.id})...")
        if (user.name.isBlank()) {
            throw IllegalArgumentException("Validation Error: User name cannot be blank.")
        }
        if (!user.email.contains("@") || !user.email.contains(".")) {
            throw IllegalArgumentException("Validation Error: Invalid email format for ${user.email}.")
        }
        // Add more complex validation rules here
        println("UserValidator: Validation successful.")
    }
}

// --- Responsibility 3: User Presentation/Display Formatting ---
// This interface/class handles formatting user data for various display purposes.
// It would change only if the presentation format or UI requirements change.
interface UserPresenter {
    fun formatForConsole(user: User): String
    fun formatForJson(user: User): String // Example for another format
}

class UserPresenterImpl : UserPresenter {
    override fun formatForConsole(user: User): String {
        println("UserPresenter: Formatting user ${user.name} (${user.id}) for console display...")
        return "User ID: ${user.id}\nName: ${user.name}\nEmail: ${user.email}\nStatus: ${if (user.isActive) "Active" else "Inactive"}"
    }

    override fun formatForJson(user: User): String {
        println("UserPresenter: Formatting user ${user.name} (${user.id}) for JSON display...")
        // In a real app, you'd use a JSON library like Gson or kotlinx.serialization
        return """{"id":"${user.id}", "name":"${user.name}", "email":"${user.email}", "active":${user.isActive}}"""
    }
}

// --- The Orchestrator / Manager ---
// This class's single responsibility is to manage the flow of user operations.
// It delegates specific tasks to its collaborators.
class UserService(
    private val userRepository: UserRepository,
    private val userValidator: UserValidator,
    private val userPresenter: UserPresenter
) {

    fun createUser(id: String, name: String, email: String): User {
        val newUser = User(id, name, email)

        // Delegate validation
        userValidator.validate(newUser) // Will throw if invalid

        // Delegate saving
        return userRepository.save(newUser)
    }

    fun getFormattedUserDetails(userId: String, format: String = "console"): String {
        val user = userRepository.findById(userId)
            ?: throw NoSuchElementException("User with ID $userId not found.")

        // Delegate formatting
        return when (format) {
            "console" -> userPresenter.formatForConsole(user)
            "json" -> userPresenter.formatForJson(user)
            else -> throw IllegalArgumentException("Unsupported format: $format")
        }
    }

    fun activateUser(userId: String): User {
        val user = userRepository.findById(userId)
            ?: throw NoSuchElementException("User with ID $userId not found.")
        user.isActive = true
        return userRepository.save(user) // Save the updated status
    }
}
