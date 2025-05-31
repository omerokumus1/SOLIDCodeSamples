package user_example;

/**
 * The Good Way: Adhering to SRP (Delegated Responsibilities)
 *  Here, we decompose the BadUser class into a simple data holder (User data class) and separate,
 *  specialized classes, each handling a single responsibility: UserRepository for persistence,
 *  UserValidator for validation, and UserPresenter for display formatting. A UserService (or UserManager)
 *  then orchestrates these independent components.
 */

/**
 * Explanation of Adherence to SRP:
 *
 *  Each class in the "Good Way" now has only one reason to change:
 *
 *  User (data class): Changes only if the core attributes of a user (e.g., adding phoneNumber) change.
 *      It holds no logic that would change for external reasons.
 *
 *  UserRepository: Changes only if the underlying data storage mechanism or schema
 *      (e.g., switching from in-memory to a database, or changing table structure) changes.
 *
 *  UserValidator: Changes only if the business rules for what constitutes a valid user
 *      (e.g., adding a new validation for age, changing email format requirements) change.
 *
 *  UserPresenter: Changes only if the way user data is formatted for display
 *      (e.g., creating a new UI component that needs a different JSON structure, or changing how names are
 *      displayed on a report) changes.
 *
 *  UserService: Its single responsibility is orchestration or managing the user lifecycle. It changes only
 *      if the high-level steps involved in creating, retrieving, or updating a user change (e.g., adding a step
 *      to send a welcome email after creation, or integrating with an external payment gateway).
 *      It delegates the specific technical tasks to its collaborators.
 *
 * This separation leads to:
 *
 *  High Cohesion: Each class's internal elements are highly related to its single purpose.
 *
 *  Loose Coupling: Changes in UserRepository (e.g., using a different database) won't require changes
 *      in UserValidator or UserPresenter, only the UserService would need an updated UserRepository dependency
 *      (which is a minor configuration change, not a fundamental logic change).
 *
 *  Easier Testing: Each component can be tested independently without needing to set up the entire system.
 *
 *  Improved Maintainability: Developers can easily find and modify the relevant code for a specific
 *      change without affecting unrelated parts.
 */

// Data class representing a User - now it ONLY holds data.
// It has no behavioral methods related to saving, validating, or formatting for display.
public class UserGoodExample {
    private final String id;
    private String name;
    private String email;
    private boolean isActive;

    public UserGoodExample(String id, String name, String email) {
        this(id, name, email, true);
    }

    public UserGoodExample(String id, String name, String email, boolean isActive) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.isActive = isActive;
    }

    // Getters and setters
    public String getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}

// --- Responsibility 1: User Persistence ---
// This interface/class handles saving and retrieving user data.
// It would change only if the persistence mechanism or data schema changes.
interface UserRepository {
    UserGoodExample save(UserGoodExample user);
    UserGoodExample findById(String userId);
}

// Concrete implementation (e.g., in-memory for demonstration)
class InMemoryUserRepository implements UserRepository {
    private final java.util.Map<String, UserGoodExample> users = new java.util.HashMap<>();

    @Override
    public UserGoodExample save(UserGoodExample user) {
        System.out.println("UserRepository: Saving user " + user.getName() + " (" + user.getId() + ") to in-memory store...");
        users.put(user.getId(), user);
        return user;
    }

    @Override
    public UserGoodExample findById(String userId) {
        System.out.println("UserRepository: Finding user by ID: " + userId + " from in-memory store.");
        return users.get(userId);
    }
}

// --- Responsibility 2: User Validation ---
// This interface/class handles validating user data against business rules.
// It would change only if the validation rules themselves change.
interface UserValidator {
    boolean isValid(UserGoodExample user);
    void validate(UserGoodExample user); // More explicit validation with exceptions
}

class UserValidatorImpl implements UserValidator {
    @Override
    public boolean isValid(UserGoodExample user) {
        try {
            validate(user);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    @Override
    public void validate(UserGoodExample user) {
        System.out.println("UserValidator: Validating user " + user.getName() + " (" + user.getId() + ")...");
        if (user.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Validation Error: User name cannot be blank.");
        }
        if (!user.getEmail().contains("@") || !user.getEmail().contains(".")) {
            throw new IllegalArgumentException("Validation Error: Invalid email format for " + user.getEmail() + ".");
        }
        // Add more complex validation rules here
        System.out.println("UserValidator: Validation successful.");
    }
}

// --- Responsibility 3: User Presentation/Display Formatting ---
// This interface/class handles formatting user data for various display purposes.
// It would change only if the presentation format or UI requirements change.
interface UserPresenter {
    String formatForConsole(UserGoodExample user);
    String formatForJson(UserGoodExample user); // Example for another format
}

class UserPresenterImpl implements UserPresenter {
    @Override
    public String formatForConsole(UserGoodExample user) {
        System.out.println("UserPresenter: Formatting user " + user.getName() + " (" + user.getId() + ") for console display...");
        return "User ID: " + user.getId() + "\nName: " + user.getName() + "\nEmail: " + user.getEmail() + "\nStatus: " + (user.isActive() ? "Active" : "Inactive");
    }

    @Override
    public String formatForJson(UserGoodExample user) {
        System.out.println("UserPresenter: Formatting user " + user.getName() + " (" + user.getId() + ") for JSON display...");
        // In a real app, you'd use a JSON library like Gson or Jackson
        return "{\"id\":\"" + user.getId() + "\", \"name\":\"" + user.getName() + "\", \"email\":\"" + user.getEmail() + "\", \"active\":" + user.isActive() + "}";
    }
}

// --- The Orchestrator / Manager ---
// This class's single responsibility is to manage the flow of user operations.
// It delegates specific tasks to its collaborators.
class UserService {
    private final UserRepository userRepository;
    private final UserValidator userValidator;
    private final UserPresenter userPresenter;

    public UserService(UserRepository userRepository, UserValidator userValidator, UserPresenter userPresenter) {
        this.userRepository = userRepository;
        this.userValidator = userValidator;
        this.userPresenter = userPresenter;
    }

    public UserGoodExample createUser(String id, String name, String email) {
        UserGoodExample newUser = new UserGoodExample(id, name, email);

        // Delegate validation
        userValidator.validate(newUser); // Will throw if invalid

        // Delegate saving
        return userRepository.save(newUser);
    }

    public String getFormattedUserDetails(String userId, String format) {
        UserGoodExample user = userRepository.findById(userId);
        if (user == null) {
            throw new java.util.NoSuchElementException("User with ID " + userId + " not found.");
        }

        // Delegate formatting
        return switch (format) {
            case "console" -> userPresenter.formatForConsole(user);
            case "json" -> userPresenter.formatForJson(user);
            default -> throw new IllegalArgumentException("Unsupported format: " + format);
        };
    }

    public String getFormattedUserDetails(String userId) {
        return getFormattedUserDetails(userId, "console");
    }

    public UserGoodExample activateUser(String userId) {
        UserGoodExample user = userRepository.findById(userId);
        if (user == null) {
            throw new java.util.NoSuchElementException("User with ID " + userId + " not found.");
        }
        user.setActive(true);
        return userRepository.save(user); // Save the updated status
    }
}
