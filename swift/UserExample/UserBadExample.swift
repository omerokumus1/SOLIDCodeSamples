import Foundation // For String operations like contains

/*
The Bad Way: Violating SRP (Monolithic User Class)
    In this example, a single User class handles its data,
    saving it to a "database," validating itself, and even formatting itself for display.
*/

/*
Explanation of the Violation:

The BadUser class in this "bad" example violates the Single Responsibility Principle
because it has multiple distinct reasons to change:

1. Persistence Logic:
   If the way users are saved (e.g., database type changes, API endpoint updates, file format shifts),
   the saveToDatabase() method within BadUser would need modification.

2. Validation Rules:
   If the business rules defining a valid user change (e.g., new mandatory fields, different email regex,
   password complexity requirements), the isValid() method within BadUser must be updated.

3. Presentation Logic:
   If the requirements for how user data is displayed (e.g., for a web UI, a mobile app, or a different API response format)
   change, the formatForDisplay() method within BadUser must be altered.

Each of these is a separate concern with its own potential for modification.
Tying them all to one class makes the code fragile; a change for one reason could inadvertently introduce bugs
into another unrelated part of the same class. This leads to code that's harder to test, maintain, and understand.

*/


// Bad Example: User class with multiple responsibilities
public class BadUser {
    var id: String
    var name: String
    var email: String
    var isActive: Bool

    init(id: String, name: String, email: String, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.email = email
        self.isActive = isActive
    }

    // --- Responsibility 1: User Persistence ---
    // This method would change if:
    // - The database schema changes (e.g., add a 'phoneNumber' column)
    // - The persistence mechanism changes (e.g., from local storage to a remote API, or Core Data)
    func saveToDatabase() {
        print("User: Saving user \(self.name) (\(self.id)) to database...")
        // Simulate database save operation
        // This is where actual DB logic (e.g., Core Data, Realm, Firebase API calls) would live
        print("User: User saved to DB successfully.")
    }

    // --- Responsibility 2: User Validation ---
    // This method would change if:
    // - Business rules for user validity change (e.g., email must contain '@domain.com')
    // - A new validation rule is added (e.g., password complexity, name cannot be empty)
    func isValid() -> Bool {
        print("User: Validating user \(self.name) (\(self.id))...")
        if self.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("Validation failed: Name cannot be blank.")
            return false
        }
        if !self.email.contains("@") || !self.email.contains(".") {
            print("Validation failed: Invalid email format.")
            return false
        }
        // More complex validation logic would go here
        print("User: Validation successful.")
        return true
    }

    // --- Responsibility 3: User Presentation/Display Formatting ---
    // This method would change if:
    // - The UI requirements change (e.g., display full name instead of just first name)
    // - The output format changes (e.g., from console string to JSON, or HTML)
    func formatForDisplay() -> String {
        print("User: Formatting user \(self.name) (\(self.id)) for display...")
        let status = self.isActive ? "Active" : "Inactive"
        return "User ID: \(self.id)\nName: \(self.name)\nEmail: \(self.email)\nStatus: \(status)"
    }
}
