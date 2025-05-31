import { BadUser } from './user_example/user_bad_example';
import {
  UserRepository,
  InMemoryUserRepository,
  UserValidator,
  UserValidatorImpl,
  UserPresenter,
  UserPresenterImpl,
  UserService,
} from './user_example/user_good_example';

function runBadUserExample(): void {
  console.log('--- Bad User Example ---');
  const badUser = new BadUser('u123', 'Alice Smith', 'alice@example.com');

  if (badUser.isValid()) {
    badUser.saveToDatabase();
  } else {
    console.log('User is invalid, cannot save.');
  }

  console.log(`\nDisplaying user info:\n${badUser.formatForDisplay()}`);

  // Imagine a change: Now emails must end with ".org"
  // -> You change isValid() directly within the BadUser class.

  // Imagine another change: Store users in a file instead of a DB
  // -> You change saveToDatabase() directly within the BadUser class.

  // Imagine another change: Display user as a JSON string for a new API
  // -> You change formatForDisplay() directly within the BadUser class.
  // Notice how BadUser changes for multiple unrelated reasons, making it fragile.
}

function runGoodUserExample(): void {
  console.log('\n--- Good User Example ---');

  // Instantiate the concrete implementations (dependencies)
  const userRepository: UserRepository = new InMemoryUserRepository();
  const userValidator: UserValidator = new UserValidatorImpl();
  const userPresenter: UserPresenter = new UserPresenterImpl();

  // Inject dependencies into the UserService
  const userService = new UserService(
    userRepository,
    userValidator,
    userPresenter
  );

  try {
    const alice = userService.createUser(
      'u123',
      'Alice Wonderland',
      'alice@example.com'
    );
    console.log(`Created: ${alice.name}`);

    const bob = userService.createUser(
      'u124',
      'Bob The Builder',
      'bob@example.net'
    );
    console.log(`Created: ${bob.name}`);

    console.log(
      `\nFormatted for console:\n${userService.getFormattedUserDetails('u123')}`
    );
    console.log(
      `\nFormatted for JSON:\n${userService.getFormattedUserDetails(
        'u124',
        'json'
      )}`
    );

    // Demonstrating a validation failure
    try {
      userService.createUser('u125', '', 'invalid');
    } catch (error: any) {
      console.log(`\nError creating user: ${error.message}`);
    }

    // Demonstrating an update and re-saving
    const updatedBob = userService.activateUser('u124');
    console.log(
      `\nUpdated Bob: ${updatedBob.name} (Active: ${updatedBob.isActive})`
    );
  } catch (error: any) {
    console.log(`An unexpected error occurred: ${error.message}`);
  }
}

// Run both examples
runBadUserExample();
runGoodUserExample();
