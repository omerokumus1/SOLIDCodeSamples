/*
The Good Way: Adhering to SRP (Delegated Responsibilities)

Here, we decompose the User concept. The User interface defines the shape of user data.
We then create specialized interfaces for persistence, validation, and presentation, along with their concrete implementations.
Finally, a UserService orchestrates these independent components.
*/

/*
Explanation of Adherence to SRP:

Each component in the "Good Way" now adheres to the Single Responsibility Principle because it has only one reason to change:

- User (interface): This interface is purely a data shape definition. It changes only if the fundamental attributes of a user (e.g., adding a phoneNumber property) change. It contains no business logic or external operations.

- UserRepository / InMemoryUserRepository: This component is solely responsible for user data persistence. It changes only if the underlying data storage mechanism or schema (e.g., switching from an in-memory Map to a NoSQL database like MongoDB, or a SQL database via an ORM) changes.

- UserValidator / UserValidatorImpl: This component focuses entirely on user data validation. It changes only if the business rules that define a valid user (e.g., new mandatory fields, different email regex, password complexity requirements) change.

- UserPresenter / UserPresenterImpl: This component handles user data presentation and formatting. It changes only if the requirements for how user data is displayed (e.g., rendering on a React/Angular UI, generating a different JSON API response, formatting for a PDF report) change.

- UserService: This class's single responsibility is orchestration or managing the user lifecycle. It acts as a coordinator, knowing which specialized component to use for specific tasks (like validation, saving, or formatting). It changes only if the high-level workflow or steps involved in managing a user change (e.g., adding a step to send a welcome email after user creation, or integrating with an external identity provider). It delegates the specific technical operations to its collaborators.

This robust separation of concerns leads to:

- High Cohesion: Each class's internal elements are tightly related and contribute to its single, well-defined purpose.

- Loose Coupling: Changes within one component (e.g., the InMemoryUserRepository switching to a database-backed repository) will not directly impact other components like UserValidatorImpl or UserPresenterImpl. The UserService would simply be initialized with a different UserRepository implementation, which is a minor configuration change, not a fundamental logic alteration within the service itself.

- Easier Testing: Each component can be unit-tested in isolation, mocking only its immediate dependencies, leading to simpler, faster, and more reliable tests.

- Improved Maintainability: Developers can quickly identify and modify the relevant code for a specific change without fear of inadvertently breaking unrelated parts of the system.
*/

// User Data Structure - now it ONLY defines the shape of data.
// It has no behavioral methods related to saving, validating, or formatting for display.
export interface User {
  id: string;
  name: string;
  email: string;
  isActive: boolean;
}

// --- Responsibility 1: User Persistence ---
// This interface defines the contract for user data persistence.
// Implementations would change only if the persistence mechanism or data schema changes.
export interface UserRepository {
  save(user: User): User;
  getById(userId: string): User | undefined;
}

// Concrete implementation (e.g., in-memory for demonstration)
export class InMemoryUserRepository implements UserRepository {
  private users: Map<string, User> = new Map<string, User>();

  public save(user: User): User {
    console.log(
      `UserRepository: Saving user ${user.name} (${user.id}) to in-memory store...`
    );
    this.users.set(user.id, { ...user }); // Store a copy to avoid external modification of stored object
    return { ...user }; // Return a copy
  }

  public getById(userId: string): User | undefined {
    console.log(
      `UserRepository: Getting user by ID: ${userId} from in-memory store.`
    );
    const user = this.users.get(userId);
    return user ? { ...user } : undefined; // Return a copy if found
  }
}

// --- Responsibility 2: User Validation ---
// This interface defines the contract for user data validation.
// Implementations would change only if the validation rules themselves change.
export interface UserValidator {
  validate(user: User): void; // Throws an error if invalid
}

export class UserValidatorImpl implements UserValidator {
  public validate(user: User): void {
    console.log(`UserValidator: Validating user ${user.name} (${user.id})...`);
    if (!user.name.trim()) {
      throw new Error('Validation Error: User name cannot be blank.');
    }
    if (!user.email.includes('@') || !user.email.includes('.')) {
      throw new Error(
        `Validation Error: Invalid email format for ${user.email}.`
      );
    }
    // Add more complex validation rules here
    console.log('UserValidator: Validation successful.');
  }
}

// --- Responsibility 3: User Presentation/Display Formatting ---
// This interface defines the contract for user data presentation.
// Implementations would change only if the presentation format or UI requirements change.
export interface UserPresenter {
  formatForConsole(user: User): string;
  formatForJson(user: User): string; // Example for another format
}

export class UserPresenterImpl implements UserPresenter {
  public formatForConsole(user: User): string {
    console.log(
      `UserPresenter: Formatting user ${user.name} (${user.id}) for console display...`
    );
    const status = user.isActive ? 'Active' : 'Inactive';
    return `User ID: ${user.id}\nName: ${user.name}\nEmail: ${user.email}\nStatus: ${status}`;
  }

  public formatForJson(user: User): string {
    console.log(
      `UserPresenter: Formatting user ${user.name} (${user.id}) for JSON display...`
    );
    // Use JSON.stringify for proper JSON formatting
    return JSON.stringify(user, null, 2); // null, 2 for pretty printing
  }
}

// --- The Orchestrator / Manager ---
// This class's single responsibility is to manage the flow of user operations.
// It delegates specific tasks to its collaborators.
export class UserService {
  private readonly userRepository: UserRepository;
  private readonly userValidator: UserValidator;
  private readonly userPresenter: UserPresenter;

  // Dependencies are injected via constructor (Dependency Injection is key for SRP adherence)
  constructor(
    userRepository: UserRepository,
    userValidator: UserValidator,
    userPresenter: UserPresenter
  ) {
    this.userRepository = userRepository;
    this.userValidator = userValidator;
    this.userPresenter = userPresenter;
  }

  public createUser(id: string, name: string, email: string): User {
    const newUser: User = { id, name, email, isActive: true };

    // Delegate validation
    this.userValidator.validate(newUser); // Will throw an error if invalid

    // Delegate saving
    return this.userRepository.save(newUser);
  }

  public getFormattedUserDetails(
    userId: string,
    format: string = 'console'
  ): string {
    const user = this.userRepository.getById(userId);
    if (!user) {
      throw new Error(`User with ID ${userId} not found.`);
    }

    // Delegate formatting
    switch (format.toLowerCase()) {
      case 'console':
        return this.userPresenter.formatForConsole(user);
      case 'json':
        return this.userPresenter.formatForJson(user);
      default:
        throw new Error(`Unsupported format: ${format}`);
    }
  }

  public activateUser(userId: string): User {
    let user = this.userRepository.getById(userId);
    if (!user) {
      throw new Error(`User with ID ${userId} not found.`);
    }
    // Create a new user object with updated status (or directly modify if repo returns mutable)
    user = { ...user, isActive: true };
    return this.userRepository.save(user); // Save the updated status
  }
}
