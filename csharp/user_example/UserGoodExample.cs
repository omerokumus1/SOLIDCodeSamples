using System;
using System.Collections.Generic; // For Dictionary
using System.Linq; // For email validation simple check

/*
    The Good Way: Adhering to SRP (Delegated Responsibilities)
        Here, we decompose the User concept. The User object becomes a simple data holder.
        We then create specialized classes/interfaces, each handling a single
        responsibility: IUserRepository for persistence, IUserValidator for validation, and
        IUserPresenter for display formatting. Finally, a UserService orchestrates these
        independent components.
*/

/*
    Explanation of Adherence to SRP:
        Each class in the "Good Way" now adheres to the Single Responsibility Principle
        because it has only one reason to change:

            User (data class): This class is purely a data holder. It changes only if the
            fundamental attributes of a user (e.g., adding a PhoneNumber field) change. It
            contains no business logic or external operations.

            IUserRepository / InMemoryUserRepository: This component is solely responsible
            for user data persistence. It changes only if the underlying data storage
            mechanism or schema (e.g., switching from an in-memory dictionary to a SQL
            database, or altering table structures) changes.

            IUserValidator / UserValidator: This component focuses entirely on user data
            validation. It changes only if the business rules that define a valid user (e
            g., new mandatory fields, different email format requirements, password
            complexity updates) change.

            IUserPresenter / UserPresenter: This component handles user data presentation
            and formatting. It changes only if the requirements for how user data is
            displayed (e.g., rendering on a web UI, generating a different JSON API
            response, formatting for a PDF report) change.

            UserService: This class's single responsibility is orchestration or managing the
            user lifecycle. It acts as a coordinator, knowing which specialized component to
            use for specific tasks (like validation, saving, or formatting). It changes only
            if the high-level workflow or steps involved in managing a user change (e.g.,
            adding a step to send a welcome email after user creation, or integrating with
            an external identity provider). It delegates the specific technical operations
            to its collaborators.

This robust separation of concerns leads to:

    High Cohesion: Each class's internal elements are tightly related and contribute to its
    single, well-defined purpose.

    Loose Coupling: Changes within one component (e.g., the InMemoryUserRepository switching
    to a SQL database) will not directly impact other components like UserValidator or
    UserPresenter. The UserService would simply be configured with a different
    IUserRepository implementation, which is a minor configuration change, not a fundamental
    logic alteration within the service itself.

    Easier Testing: Each component can be unit-tested in isolation, mocking only its
    immediate dependencies, leading to simpler, faster, and more reliable tests.

    Improved Maintainability: Developers can quickly identify and modify the relevant code
    for a specific change without fear of inadvertently breaking unrelated parts of the
    system.
*/

namespace UserExample.Good
{
    // User Data Structure - now it ONLY holds data.
    // It has no behavioral methods related to saving, validating, or formatting for display.
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
    }

    // --- Responsibility 1: User Persistence ---
    // This interface/class handles saving and retrieving user data.
    // It would change only if the persistence mechanism or data schema changes.
    public interface IUserRepository
    {
        User Save(User user);
        User GetById(string userId);
    }

    // Concrete implementation (e.g., in-memory for demonstration)
    public class InMemoryUserRepository : IUserRepository
    {
        private readonly Dictionary<string, User> _users = new Dictionary<string, User>();

        public User Save(User user)
        {
            Console.WriteLine($"UserRepository: Saving user {user.Name} ({user.Id}) to in-memory store...");
            _users[user.Id] = user; // Store the user (updates if ID exists, adds if not)
            return user;
        }

        public User GetById(string userId)
        {
            Console.WriteLine($"UserRepository: Getting user by ID: {userId} from in-memory store.");
            _users.TryGetValue(userId, out var user);
            return user; // Returns null if not found
        }
    }

    // --- Responsibility 2: User Validation ---
    // This interface/class handles validating user data against business rules.
    // It would change only if the validation rules themselves change.
    public interface IUserValidator
    {
        void Validate(User user); // Throws an exception if invalid
    }

    public class UserValidator : IUserValidator
    {
        public void Validate(User user)
        {
            Console.WriteLine($"UserValidator: Validating user {user.Name} ({user.Id})...");
            if (string.IsNullOrWhiteSpace(user.Name))
            {
                throw new ArgumentException("Validation Error: User name cannot be blank.");
            }
            if (!user.Email.Contains("@") || !user.Email.Contains("."))
            {
                throw new ArgumentException($"Validation Error: Invalid email format for {user.Email}.");
            }
            // Add more complex validation rules here
            Console.WriteLine("UserValidator: Validation successful.");
        }
    }

    // --- Responsibility 3: User Presentation/Display Formatting ---
    // This interface/class handles formatting user data for various display purposes.
    // It would change only if the presentation format or UI requirements change.
    public interface IUserPresenter
    {
        string FormatForConsole(User user);
        string FormatForJson(User user); // Example for another format
    }

    public class UserPresenter : IUserPresenter
    {
        public string FormatForConsole(User user)
        {
            Console.WriteLine($"UserPresenter: Formatting user {user.Name} ({user.Id}) for console display...");
            return $"User ID: {user.Id}\nName: {user.Name}\nEmail: {user.Email}\nStatus: {(user.IsActive ? "Active" : "Inactive")}";
        }

        public string FormatForJson(User user)
        {
            Console.WriteLine($"UserPresenter: Formatting user {user.Name} ({user.Id}) for JSON display...");
            // In a real app, you'd use a JSON library like Newtonsoft.Json or System.Text.Json
            return $"{{\"id\":\"{user.Id}\", \"name\":\"{user.Name}\", \"email\":\"{user.Email}\", \"active\":{user.IsActive.ToString().ToLower()}}}";
        }
    }

    // --- The Orchestrator / Manager ---
    // This class's single responsibility is to manage the flow of user operations.
    // It delegates specific tasks to its collaborators.
    public class UserService
    {
        private readonly IUserRepository _userRepository;
        private readonly IUserValidator _userValidator;
        private readonly IUserPresenter _userPresenter;

        // Dependencies are injected via constructor (Dependency Injection is key for SRP adherence)
        public UserService(IUserRepository userRepository, IUserValidator userValidator, IUserPresenter userPresenter)
        {
            _userRepository = userRepository;
            _userValidator = userValidator;
            _userPresenter = userPresenter;
        }

        public User CreateUser(string id, string name, string email)
        {
            User newUser = new User(id, name, email);

            // Delegate validation
            _userValidator.Validate(newUser); // Will throw if invalid

            // Delegate saving
            return _userRepository.Save(newUser);
        }

        public string GetFormattedUserDetails(string userId, string format = "console")
        {
            User user = _userRepository.GetById(userId);
            if (user == null)
            {
                throw new KeyNotFoundException($"User with ID {userId} not found.");
            }

            // Delegate formatting
            switch (format.ToLower())
            {
                case "console":
                    return _userPresenter.FormatForConsole(user);
                case "json":
                    return _userPresenter.FormatForJson(user);
                default:
                    throw new ArgumentException($"Unsupported format: {format}");
            }
        }

        public User ActivateUser(string userId)
        {
            User user = _userRepository.GetById(userId);
            if (user == null)
            {
                throw new KeyNotFoundException($"User with ID {userId} not found.");
            }
            user.IsActive = true; // Modify the fetched user object
            return _userRepository.Save(user); // Save the updated status
        }
    }

    public class UserGoodExample
    {
        public static void Run()
        {
            Console.WriteLine("\n--- Good SRP Example ---");

            // Instantiate the concrete implementations (dependencies)
            IUserRepository userRepository = new InMemoryUserRepository();
            IUserValidator userValidator = new UserValidator();
            IUserPresenter userPresenter = new UserPresenter();

            // Inject dependencies into the UserService
            UserService userService = new UserService(userRepository, userValidator, userPresenter);

            try
            {
                User alice = userService.CreateUser("u123", "Alice Wonderland", "alice@example.com");
                Console.WriteLine($"Created: {alice.Name}");

                User bob = userService.CreateUser("u124", "Bob The Builder", "bob@example.net");
                Console.WriteLine($"Created: {bob.Name}");

                Console.WriteLine($"\nFormatted for console:\n{userService.GetFormattedUserDetails("u123")}");
                Console.WriteLine($"\nFormatted for JSON:\n{userService.GetFormattedUserDetails("u124", "json")}");

                // Demonstrating a validation failure
                try
                {
                    userService.CreateUser("u125", "", "invalid");
                }
                catch (ArgumentException ex)
                {
                    Console.WriteLine($"\nError creating user: {ex.Message}");
                }

                // Demonstrating an update and re-saving
                User updatedBob = userService.ActivateUser("u124");
                Console.WriteLine($"\nUpdated Bob: {updatedBob.Name} (Active: {updatedBob.IsActive})");

            }
            catch (Exception ex)
            {
                Console.WriteLine($"An unexpected error occurred: {ex.Message}");
            }
        }
    }
}