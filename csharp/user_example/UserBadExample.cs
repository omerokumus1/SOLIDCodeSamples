using System;
using System.Linq; // For email validation simple check

/*
    The Bad Way: Violating SRP (Monolithic User Class)
        In this example, the User class handles not only its data but also its persistence
        logic (saving to a "database"), validation rules, and even how it formats itself for
        display.
*/

/*
    Explanation of the Violation:

    The User class in this "bad" example violates the Single Responsibility Principle
    because it has multiple distinct reasons to change:

        Persistence Logic: If the way users are saved (e.g., database type changes, API
        endpoint updates, file format shifts), the SaveToDatabase() method within User would
        need modification.

        Validation Rules: If the business rules defining a valid user change (e.g., new
        mandatory fields, different email regex, password complexity requirements), the
        IsValid() method within User must be updated.

        Presentation Logic: If the requirements for how user data is displayed (e.g., for a
        web UI, a mobile app, or a different API response format) change, the
        FormatForDisplay() method within User must be altered.

    Each of these is a separate concern with its own potential for modification. Tying
    them all to one class makes the code fragile; a change for one reason could
    inadvertently introduce bugs into another unrelated part of the same class. This
    leads to code that's harder to test, maintain, and understand.
*/

namespace UserExample.Bad
{
    // Data class representing a User
    public class User
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public bool IsActive { get; set; }

        public User(string id, string name, string email, bool isActive = true)
        {
            Id = id;
            Name = name;
            Email = email;
            IsActive = isActive;
        }

        // --- Responsibility 1: User Persistence ---
        // This method would change if:
        // - The database schema changes (e.g., adding a 'phone' column)
        // - The persistence mechanism changes (e.g., from SQL DB to NoSQL, or a remote API)
        public void SaveToDatabase()
        {
            Console.WriteLine($"User: Saving user {Name} ({Id}) to database...");
            // Simulate database save operation
            // This is where actual DB logic (e.g., ADO.NET, Entity Framework) would live
            Console.WriteLine("User: User saved to DB successfully.");
        }

        // --- Responsibility 2: User Validation ---
        // This method would change if:
        // - Business rules for user validity change (e.g., email must contain '@domain.com')
        // - A new validation rule is added (e.g., password complexity, name cannot be empty)
        public bool IsValid()
        {
            Console.WriteLine($"User: Validating user {Name} ({Id})...");
            if (string.IsNullOrWhiteSpace(Name))
            {
                Console.WriteLine("Validation failed: Name cannot be blank.");
                return false;
            }
            if (!Email.Contains("@") || !Email.Contains("."))
            {
                Console.WriteLine("Validation failed: Invalid email format.");
                return false;
            }
            // More complex validation logic would go here
            Console.WriteLine("User: Validation successful.");
            return true;
        }

        // --- Responsibility 3: User Presentation/Display Formatting ---
        // This method would change if:
        // - The UI requirements change (e.g., display full name instead of just first name)
        // - The output format changes (e.g., from console string to JSON, or HTML)
        public string FormatForDisplay()
        {
            Console.WriteLine($"User: Formatting user {Name} ({Id}) for display...");
            return $"User ID: {Id}\nName: {Name}\nEmail: {Email}\nStatus: {(IsActive ? "Active" : "Inactive")}";
        }
    }

    public class UserBadExample
    {
        public static void Run()
        {
            Console.WriteLine("--- Bad SRP Example ---");
            User badUser = new User("u123", "Alice Smith", "alice@example.com");

            if (badUser.IsValid())
            {
                badUser.SaveToDatabase();
            }
            else
            {
                Console.WriteLine("User is invalid, cannot save.");
            }

            Console.WriteLine($"\nDisplaying user info:\n{badUser.FormatForDisplay()}");

            // Imagine a change: Now emails must end with ".org"
            // -> You change IsValid() directly within the User class.

            // Imagine another change: Store users in a file instead of a DB
            // -> You change SaveToDatabase() directly within the User class.

            // Imagine another change: Display user as a JSON string for a new API
            // -> You change FormatForDisplay() directly within the User class.
            // Notice how the User class changes for multiple unrelated reasons, making it fragile.
        }
    }
}