/**
 *  The Bad Way: Violating SRP (Monolithic User Class)
 *    In this example, the User class itself handles its data, saving it to a "database,"
 *    validating itself, and even formatting itself for display.
 *
 */

/**
 * Explanation of the Violation:
    The User class in this "bad" example violates the Single Responsibility Principle because
    it has multiple distinct reasons to change:

      Persistence Logic: If the way users are saved (e.g., database type changes, API endpoint updates,
        file format shifts), the saveToDatabase() method within User would need modification.

      Validation Rules: If the business rules defining a valid user change (e.g., new mandatory fields,
        different email regex, password complexity requirements), the isValid() method within User must be updated.

      Presentation Logic: If the requirements for how user data is displayed (e.g., for a web UI, a mobile app,
        or a different API response format) change, the formatForDisplay() method within User must be altered.

    Each of these is a separate concern with its own potential for modification. Tying them all to one class makes
    the code fragile; a change for one reason could inadvertently introduce bugs into another unrelated part of
    the same class. This leads to code that's harder to test, maintain, and understand.
 */

// User Data Class - represents a User.
// For the 'bad' example, we make its fields mutable to allow direct modification.
class BadUser {
  String id;
  String name;
  String email;
  bool isActive;

  BadUser(
      {required this.id,
      required this.name,
      required this.email,
      this.isActive = true});

  // --- Responsibility 1: User Persistence ---
  // This method would change if:
  // - The database schema changes (e.g., adding a 'phone' column)
  // - The persistence mechanism changes (e.g., from SQL DB to NoSQL, or a remote API)
  void saveToDatabase() {
    print('User: Saving user $name ($id) to database...');
    // Simulate database save operation
    // This is where actual DB logic (e.g., SQLite, Firebase, REST API calls) would live
    print('User: User saved to DB successfully.');
  }

  // --- Responsibility 2: User Validation ---
  // This method would change if:
  // - Business rules for user validity change (e.g., email must contain '@domain.com')
  // - A new validation rule is added (e.g., password complexity, name cannot be empty)
  bool isValid() {
    print('User: Validating user $name ($id)...');
    if (name.trim().isEmpty) {
      print('Validation failed: Name cannot be blank.');
      return false;
    }
    if (!email.contains('@') || !email.contains('.')) {
      print('Validation failed: Invalid email format.');
      return false;
    }
    // More complex validation logic would go here
    print('User: Validation successful.');
    return true;
  }

  // --- Responsibility 3: User Presentation/Display Formatting ---
  // This method would change if:
  // - The UI requirements change (e.g., display full name instead of just first name)
  // - The output format changes (e.g., from console string to JSON, or HTML)
  String formatForDisplay() {
    print('User: Formatting user $name ($id) for display...');
    return 'User ID: $id\nName: $name\nEmail: $email\nStatus: ${isActive ? "Active" : "Inactive"}';
  }
}
