package user_example

/**
 * The Bad Way: Violating SRP (Monolithic User Class)
 *  In this example, the User class itself handles its data,
 *  saving it to a "database," validating itself, and even formatting itself for display.
 */

/**
 * Explanation of the Violation:
 *
 * The BadUser class violates SRP because it has multiple reasons to change:
 *
 * Persistence Logic: If the way users are saved (e.g., database type, API endpoint, file format)
 *      changes, the saveToDatabase() method in BadUser must change.
 *
 * Validation Rules: If the business rules for what constitutes a valid user change
 *      (e.g., new mandatory fields, different email regex), the isValid() method in
 *      BadUser must change.
 *
 * Presentation Logic: If the requirements for how user data is displayed
 *      (e.g., for a web UI, a mobile app, or a different API response format) change,
 *      the formatForDisplay() method in BadUser must change.
 *
 * Each of these represents a distinct concern and a separate axis of change.
 *      Modifying one concern risks inadvertently breaking another within the same class,
 *      making the code fragile, hard to test, and difficult to maintain.
 */

// Bad Example: User class with multiple responsibilities
class BadUser(val id: String, var name: String, var email: String, var isActive: Boolean = true) {

    // --- Responsibility 1: User Persistence ---
    // This method would change if:
    // - The database schema changes (e.g., add a 'phone' column)
    // - The persistence mechanism changes (e.g., from SQL DB to NoSQL, or a remote API)
    fun saveToDatabase() {
        println("User: Saving user ${this.name} (${this.id}) to database...")
        // Simulate database save operation
        // This is where actual DB logic (JDBC, ORM, etc.) would live
        println("User: User saved to DB successfully.")
    }

    // --- Responsibility 2: User Validation ---
    // This method would change if:
    // - Business rules for user validity change (e.g., email must contain '@domain.com')
    // - A new validation rule is added (e.g., password complexity, name cannot be empty)
    fun isValid(): Boolean {
        println("User: Validating user ${this.name} (${this.id})...")
        if (name.isBlank()) {
            println("Validation failed: Name cannot be blank.")
            return false
        }
        if (!email.contains("@")) {
            println("Validation failed: Invalid email format.")
            return false
        }
        // More complex validation logic would go here
        println("User: Validation successful.")
        return true
    }

    // --- Responsibility 3: User Presentation/Display Formatting ---
    // This method would change if:
    // - The UI requirements change (e.g., display full name instead of just first name)
    // - The output format changes (e.g., from console string to JSON, or HTML)
    fun formatForDisplay(): String {
        println("User: Formatting user ${this.name} (${this.id}) for display...")
        return "User ID: ${this.id}\nName: ${this.name}\nEmail: ${this.email}\nStatus: ${if (this.isActive) "Active" else "Inactive"}"
    }

}