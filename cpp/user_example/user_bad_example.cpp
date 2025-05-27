#include <iostream>
#include <string>
#include <stdexcept> // For exceptions

/**
 * The Bad Way: Violating SRP (Monolithic User Class)
 *  In this example, the User class itself handles its data, saving it to a "database,"
 *  validating itself, and even formatting itself for display.
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

// Data struct representing a User
struct User {
    std::string id;
    std::string name;
    std::string email;
    bool isActive;

    // Constructor for convenience
    User(const std::string& id, const std::string& name, const std::string& email, bool isActive = true)
        : id(id), name(name), email(email), isActive(isActive) {}
};

// Bad Example: User class with multiple responsibilities
class BadUser {
private:
    std::string id;
    std::string name;
    std::string email;
    bool isActive;

public:
    BadUser(const std::string& id, const std::string& name, const std::string& email, bool isActive = true)
        : id(id), name(name), email(email), isActive(isActive) {}

    // --- Responsibility 1: User Persistence ---
    // This method would change if:
    // - The database schema changes (e.g., add a 'phone' column)
    // - The persistence mechanism changes (e.g., from SQL DB to NoSQL, or a remote API)
    void saveToDatabase() {
        std::cout << "User: Saving user " << this->name << " (" << this->id << ") to database...\n";
        // Simulate database save operation
        // This is where actual DB logic (e.g., SQL queries, ORM calls) would live
        std::cout << "User: User saved to DB successfully.\n";
    }

    // --- Responsibility 2: User Validation ---
    // This method would change if:
    // - Business rules for user validity change (e.g., email must contain '@domain.com')
    // - A new validation rule is added (e.g., password complexity, name cannot be empty)
    bool isValid() const {
        std::cout << "User: Validating user " << this->name << " (" << this->id << ")...\n";
        if (name.empty()) {
            std::cout << "Validation failed: Name cannot be blank.\n";
            return false;
        }
        if (email.find('@') == std::string::npos) {
            std::cout << "Validation failed: Invalid email format.\n";
            return false;
        }
        // More complex validation logic would go here
        std::cout << "User: Validation successful.\n";
        return true;
    }

    // --- Responsibility 3: User Presentation/Display Formatting ---
    // This method would change if:
    // - The UI requirements change (e.g., display full name instead of just first name)
    // - The output format changes (e.g., from console string to JSON, or HTML)
    std::string formatForDisplay() const {
        std::cout << "User: Formatting user " << this->name << " (" << this->id << ") for display...\n";
        std::string status = isActive ? "Active" : "Inactive";
        return "User ID: " + this->id + "\nName: " + this->name + "\nEmail: " + this->email + "\nStatus: " + status;
    }

    // Accessors for user data (necessary for using the user object)
    const std::string& getId() const { return id; }
    const std::string& getName() const { return name; }
    const std::string& getEmail() const { return email; }
    bool getIsActive() const { return isActive; }
    void setIsActive(bool status) { isActive = status; }
};

void runBadSrpExample() {
    std::cout << "--- Bad SRP Example ---\n";
    BadUser badUser("u123", "Alice Smith", "alice@example.com");

    if (badUser.isValid()) {
        badUser.saveToDatabase();
    } else {
        std::cout << "User is invalid, cannot save.\n";
    }

    std::cout << "\nDisplaying user info:\n" << badUser.formatForDisplay() << "\n";

    // Imagine a change: Now emails must end with ".org"
    // -> You change isValid() in BadUser

    // Imagine another change: Store users in a file instead of a DB
    // -> You change saveToDatabase() in BadUser

    // Imagine another change: Display user as a JSON string for a new API
    // -> You change formatForDisplay() in BadUser
    // Notice how BadUser changes for multiple unrelated reasons.
}

int main() {
    runBadSrpExample();
    return 0;
}