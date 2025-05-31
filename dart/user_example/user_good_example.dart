/**
 * The Good Way: Adhering to SRP (Delegated Responsibilities)
 * Here, we decompose the User concept. The User object becomes a simple data holder.
 * We then create specialized interfaces (abstract class in Dart) for persistence, validation,
 * and presentation, with concrete implementations. Finally, a
 * UserService orchestrates these independent components.
 */

/**
 * Explanation of Adherence to SRP:
 * Each class in the "Good Way" now adheres to the Single Responsibility Principle
 * because it has only one reason to change:
 *
 *   User (data class): This class is purely a data holder. It changes only if the
 *     fundamental attributes of a user (e.g., adding a phoneNumber field) change.
 *     It contains no business logic or external operations.
 *
 *   UserRepository / InMemoryUserRepository: This component is solely responsible for
 *     user data persistence. It changes only if the underlying data storage mechanism or
 *     schema (e.g., switching from an in-memory map to a NoSQL database, or altering data structures) changes.
 *
 *   UserValidator / UserValidatorImpl: This component focuses entirely on user data validation.
 *     It changes only if the business rules that define a valid user (e.g., new mandatory fields,
 *     different email format requirements, password complexity updates) change.
 *
 *   UserPresenter / UserPresenterImpl: This component handles user data presentation and formatting.
 *     It changes only if the requirements for how user data is displayed (e.g., rendering on a web UI,
 *     generating a different JSON API response, formatting for a PDF report) change.
 *
 *   UserService: This class's single responsibility is orchestration or managing the user lifecycle.
 *     It acts as a coordinator, knowing which specialized component to use for specific tasks
 *     (like validation, saving, or formatting). It changes only if the high-level workflow or steps
 *     involved in managing a user change (e.g., adding a step to send a welcome email after user creation,
 *     or integrating with an external identity provider). It delegates the specific technical operations
 *     to its collaborators.
 *
 * This robust separation of concerns leads to:
 *
 *   High Cohesion: Each class's internal elements are tightly related and contribute to its single, well-defined purpose.
 *   Loose Coupling: Changes within one component (e.g., the InMemoryUserRepository switching to a different database implementation)
 *     will not directly impact other components like UserValidator or UserPresenter. The UserService would simply be configured
 *     with a different UserRepository implementation, which is a minor configuration change, not a fundamental logic alteration
 *     within the service itself.
 *   Easier Testing: Each component can be unit-tested in isolation, mocking only its immediate dependencies, leading to simpler,
 *     faster, and more reliable tests.
 *   Improved Maintainability: Developers can quickly identify and modify the relevant code for a specific change without fear of
 *     inadvertently breaking unrelated parts of the system.
 */

import 'dart:collection'; // For HashMap
import 'dart:convert'; // For jsonEncode

// User Data Structure - now it ONLY holds data.
// It has no behavioral methods related to saving, validating, or formatting for display.
// For immutable data, a const constructor with final fields would be used,
// potentially with a .copyWith() method.
class GoodUser {
  String id;
  String name;
  String email;
  bool isActive;

  GoodUser(
      {required this.id,
      required this.name,
      required this.email,
      this.isActive = true});
}

// --- Responsibility 1: User Persistence ---
// This abstract class (interface) defines the contract for user data persistence.
// Implementations would change only if the persistence mechanism or data schema changes.
abstract class UserRepository {
  GoodUser save(GoodUser user);
  GoodUser? getById(String userId);
}

// Concrete implementation (e.g., in-memory for demonstration)
class InMemoryUserRepository implements UserRepository {
  final Map<String, GoodUser> _users = HashMap();

  @override
  GoodUser save(GoodUser user) {
    print(
        'UserRepository: Saving user ${user.name} (${user.id}) to in-memory store...');
    _users[user.id] = user; // Store the user (adds or updates if ID exists)
    return user;
  }

  @override
  GoodUser? getById(String userId) {
    print('UserRepository: Getting user by ID: $userId from in-memory store.');
    return _users[userId]; // Returns null if not found
  }
}

// --- Responsibility 2: User Validation ---
// This abstract class (interface) defines the contract for user data validation.
// Implementations would change only if the validation rules themselves change.
abstract class UserValidator {
  void validate(GoodUser user); // Throws an exception if invalid
}

class UserValidatorImpl implements UserValidator {
  @override
  void validate(GoodUser user) {
    print('UserValidator: Validating user ${user.name} (${user.id})...');
    if (user.name.trim().isEmpty) {
      throw ArgumentError('Validation Error: User name cannot be blank.');
    }
    if (!user.email.contains('@') || !user.email.contains('.')) {
      throw ArgumentError(
          'Validation Error: Invalid email format for ${user.email}.');
    }
    // Add more complex validation rules here
    print('UserValidator: Validation successful.');
  }
}

// --- Responsibility 3: User Presentation/Display Formatting ---
// This abstract class (interface) defines the contract for user data presentation.
// Implementations would change only if the presentation format or UI requirements change.
abstract class UserPresenter {
  String formatForConsole(GoodUser user);
  String formatForJson(GoodUser user); // Example for another format
}

class UserPresenterImpl implements UserPresenter {
  @override
  String formatForConsole(GoodUser user) {
    print(
        'UserPresenter: Formatting user ${user.name} (${user.id}) for console display...');
    return 'User ID: ${user.id}\nName: ${user.name}\nEmail: ${user.email}\nStatus: ${user.isActive ? "Active" : "Inactive"}';
  }

  @override
  String formatForJson(GoodUser user) {
    print(
        'UserPresenter: Formatting user ${user.name} (${user.id}) for JSON display...');
    // In a real app, you'd use dart:convert's jsonEncode or a library like json_serializable
    Map<String, dynamic> userData = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'active': user.isActive,
    };
    return jsonEncode(userData);
  }
}

// --- The Orchestrator / Manager ---
// This class's single responsibility is to manage the flow of user operations.
// It delegates specific tasks to its collaborators.
class UserService {
  final UserRepository _userRepository;
  final UserValidator _userValidator;
  final UserPresenter _userPresenter;

  // Dependencies are injected via constructor (Dependency Injection is key for SRP adherence)
  UserService(this._userRepository, this._userValidator, this._userPresenter);

  GoodUser createUser(String id, String name, String email) {
    GoodUser newUser = GoodUser(id: id, name: name, email: email);

    // Delegate validation
    _userValidator.validate(newUser); // Will throw if invalid

    // Delegate saving
    return _userRepository.save(newUser);
  }

  String getFormattedUserDetails(String userId, {String format = 'console'}) {
    GoodUser? user = _userRepository.getById(userId);
    if (user == null) {
      throw StateError('User with ID $userId not found.');
    }

    // Delegate formatting
    switch (format.toLowerCase()) {
      case 'console':
        return _userPresenter.formatForConsole(user);
      case 'json':
        return _userPresenter.formatForJson(user);
      default:
        throw ArgumentError('Unsupported format: $format');
    }
  }

  GoodUser activateUser(String userId) {
    GoodUser? user = _userRepository.getById(userId);
    if (user == null) {
      throw StateError('User with ID $userId not found.');
    }
    user.isActive = true; // Modify the fetched user object
    return _userRepository.save(user); // Save the updated status
  }
}
