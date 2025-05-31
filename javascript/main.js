// Import the user examples
// Note: In a browser environment, you would use import statements or script tags
// In Node.js, you would use require() or import statements

const { BadUser } = require('./user_example/user_bad_example.js');
const {
  GoodUser,
  InMemoryUserRepository,
  UserValidator,
  UserPresenter,
  UserService,
} = require('./user_example/user_good_example.js');

function runBadUserExample() {
  console.log('--- Bad SRP Example ---');
  const badUser = new BadUser('u123', 'Alice Smith', 'alice@example.com');

  if (badUser.isValid()) {
    badUser.saveToDatabase();
  } else {
    console.log('BadUser is invalid, cannot save.');
  }

  console.log('\nDisplaying user info:\n' + badUser.formatForDisplay());

  // Imagine a change: Now emails must end with ".org"
  // -> You change isValid() in BadUser

  // Imagine another change: Store users in a file instead of a DB
  // -> You change saveToDatabase() in BadUser

  // Imagine another change: Display user as a JSON string for a new API
  // -> You change formatForDisplay() in BadUser
  // Notice how BadUser changes for multiple unrelated reasons.
}

function runGoodUserExample() {
  console.log('\n--- Good SRP Example ---');

  const userRepository = new InMemoryUserRepository();
  const userValidator = new UserValidator();
  const userPresenter = new UserPresenter();

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
    console.log('Created:', alice.name);

    const bob = userService.createUser(
      'u124',
      'Bob The Builder',
      'bob@example.net'
    );
    console.log('Created:', bob.name);

    console.log(
      '\nFormatted for console:\n' + userService.getFormattedUserDetails('u123')
    );
    console.log(
      '\nFormatted for JSON:\n' +
        userService.getFormattedUserDetails('u124', 'json')
    );

    // Demonstrating a validation failure
    try {
      userService.createUser('u125', '', 'invalid');
    } catch (error) {
      console.log('\nError creating user:', error.message);
    }

    // Demonstrating an update and re-saving
    const updatedBob = userService.activateUser('u124');
    console.log(
      '\nUpdated Bob:',
      updatedBob.name,
      '(Active:',
      updatedBob.isActive + ')'
    );
  } catch (error) {
    console.log('An unexpected error occurred:', error.message);
  }
}

// Run both examples
function main() {
  runBadUserExample();
  runGoodUserExample();
}

main();
