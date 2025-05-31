import 'kitchen_manager/kitchen_manager.dart';
import 'user_example/user_bad_example.dart';
import 'user_example/user_good_example.dart';

void main() {
  // runBadUserExample();
  // runGoodUserExample();

  var kitchenManager = KitchenManager();
  kitchenManager.run();
}

void runBadUserExample() {
  print('--- Bad SRP Example ---');
  BadUser badUser =
      BadUser(id: "u123", name: "Alice Smith", email: "alice@example.com");

  if (badUser.isValid()) {
    badUser.saveToDatabase();
  } else {
    print('User is invalid, cannot save.');
  }

  print('\nDisplaying user info:\n${badUser.formatForDisplay()}');

  // Imagine a change: Now emails must end with ".org"
  // -> You change isValid() directly within the User class.

  // Imagine another change: Store users in a file instead of a DB
  // -> You change saveToDatabase() directly within the User class.

  // Imagine another change: Display user as a JSON string for a new API
  // -> You change formatForDisplay() directly within the User class.
  // Notice how the User class changes for multiple unrelated reasons, making it fragile.
}

void runGoodUserExample() {
  print('\n--- Good SRP Example ---');

  // Instantiate the concrete implementations (dependencies)
  UserRepository userRepository = InMemoryUserRepository();
  UserValidator userValidator = UserValidatorImpl();
  UserPresenter userPresenter = UserPresenterImpl();

  // Inject dependencies into the UserService
  UserService userService =
      UserService(userRepository, userValidator, userPresenter);

  try {
    GoodUser alice =
        userService.createUser("u123", "Alice Wonderland", "alice@example.com");
    print('Created: ${alice.name}');

    GoodUser bob =
        userService.createUser("u124", "Bob The Builder", "bob@example.net");
    print('Created: ${bob.name}');

    print(
        '\nFormatted for console:\n${userService.getFormattedUserDetails("u123")}');
    print(
        '\nFormatted for JSON:\n${userService.getFormattedUserDetails("u124", format: "json")}');

    // Demonstrating a validation failure
    try {
      userService.createUser("u125", "", "invalid");
    } on ArgumentError catch (e) {
      print('\nError creating user: ${e.message}');
    }

    // Demonstrating an update and re-saving
    GoodUser updatedBob = userService.activateUser("u124");
    print('\nUpdated Bob: ${updatedBob.name} (Active: ${updatedBob.isActive})');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}
