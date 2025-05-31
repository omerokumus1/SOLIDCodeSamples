package user_example;

public class UserExample {
    public static void runBadUserExample() {
        System.out.println("--- Bad SRP Example ---");
        UserBadExample badUser = new UserBadExample("u123", "Alice Smith", "alice@example.com");

        if (badUser.isValid()) {
            badUser.saveToDatabase();
        } else {
            System.out.println("User is invalid, cannot save.");
        }

        System.out.println("\nDisplaying user info:\n" + badUser.formatForDisplay());

        // Imagine a change: Now emails must end with ".org"
        // -> You change isValid() in BadUser

        // Imagine another change: Store users in a file instead of a DB
        // -> You change saveToDatabase() in BadUser

        // Imagine another change: Display user as a JSON string for a new API
        // -> You change formatForDisplay() in BadUser
        // Notice how BadUser changes for multiple unrelated reasons.
    }

    public static void runGoodUserExample() {
        System.out.println("\n--- Good SRP Example ---");

        UserRepository userRepository = new InMemoryUserRepository();
        UserValidator userValidator = new UserValidatorImpl();
        UserPresenter userPresenter = new UserPresenterImpl();

        UserService userService = new UserService(userRepository, userValidator, userPresenter);

        try {
            UserGoodExample alice = userService.createUser("u123", "Alice Wonderland", "alice@example.com");
            System.out.println("Created: " + alice.getName());

            UserGoodExample bob = userService.createUser("u124", "Bob The Builder", "bob@example.net");
            System.out.println("Created: " + bob.getName());

            System.out.println("\nFormatted for console:\n" + userService.getFormattedUserDetails("u123"));
            System.out.println("\nFormatted for JSON:\n" + userService.getFormattedUserDetails("u124", "json"));

            // Demonstrating a validation failure
            try {
                userService.createUser("u125", "", "invalid");
            } catch (IllegalArgumentException e) {
                System.out.println("\nError creating user: " + e.getMessage());
            }

            // Demonstrating an update and re-saving
            UserGoodExample updatedBob = userService.activateUser("u124");
            System.out.println("\nUpdated Bob: " + updatedBob.getName() + " (Active: " + updatedBob.isActive() + ")");

        } catch (Exception e) {
            System.out.println("An unexpected error occurred: " + e.getMessage());
        }
    }
}
