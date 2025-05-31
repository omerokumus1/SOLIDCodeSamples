#include <iostream>
#include <string>
#include <stdexcept> // For exceptions
#include <memory>    // For smart pointers (optional but good practice)
#include <map>       // For InMemoryUserRepository

/**
 * The Good Way: Adhering to SRP (Delegated Responsibilities)
 * Here, we decompose the User concept into a simple data struct (User) and separate,
 * specialized classes/interfaces, each handling a single responsibility: IUserRepository
 * for persistence, IUserValidator for validation, and IUserPresenter for display
 * formatting. A UserService then orchestrates these independent components.
 */

 /**
  * Explanation of Adherence to SRP:
  *  Each class in the "Good Way" now has only one reason to change:
  *
  * User (struct): Changes only if the core attributes of a user (e.g., adding a phoneNumber
  *     field) change. It holds no logic that would change for external reasons.
  *
  * IUserRepository / InMemoryUserRepository: Changes only if the underlying data storage
  *     mechanism or schema (e.g., switching from in-memory to a SQL database, or changing
  *     table structure) changes.
  *
  * IUserValidator / UserValidatorImpl: Changes only if the business rules for what
  *     constitutes a valid user (e.g., adding a new validation for age, changing email
  *     format requirements) change.
  *
  * IUserPresenter / UserPresenterImpl: Changes only if the way user data is formatted for
  *     display (e.g., creating a new UI component that needs a different JSON structure, or
  *     changing how names are displayed on a report) changes.
  *
  * UserService: Its single responsibility is orchestration or managing the user lifecycle.
  *     It changes only if the high-level steps involved in creating, retrieving, or
  *     updating a user change (e.g., adding a step to send a welcome email after creation,
  *     or integrating with an external identity provider). It delegates the specific
  *     technical tasks to its collaborators.
  *
  * This separation leads to:
  *
  * High Cohesion: Each class's internal elements are highly related to its single purpose
  *
  * Loose Coupling: Changes in InMemoryUserRepository (e.g., using a different database)
  *     won't require changes in UserValidatorImpl or UserPresenterImpl. The UserService
  *     would simply be configured with a different IUserRepository implementation, which is
  *     a minor configuration change, not a fundamental logic change within UserService.
  *
  * Easier Testing: Each component can be tested independently without needing to set up the
  *     entire system.
  *
  * Improved Maintainability: Developers can easily find and modify the relevant code for a
  *     specific change without affecting unrelated parts.
  */

// User Data Structure - now it ONLY holds data.
// It has no behavioral methods related to saving, validating, or formatting for display.
struct User {
    std::string id;
    std::string name;
    std::string email;
    bool isActive;

    // Default constructor (required by std::map)
    User() : id(""), name(""), email(""), isActive(true) {}

    User(const std::string& id, const std::string& name, const std::string& email, bool isActive = true)
        : id(id), name(name), email(email), isActive(isActive) {}
};

// --- Responsibility 1: User Persistence ---
// Interface for user data persistence.
// This interface/class handles saving and retrieving user data.
// It would change only if the persistence mechanism or data schema changes.
class IUserRepository {
public:
    virtual ~IUserRepository() = default; // Virtual destructor for proper polymorphic deletion
    virtual User save(const User& user) = 0;
    virtual User* findById(const std::string& userId) = 0; // Return pointer, caller manages or use smart pointer
};

// Concrete implementation (e.g., in-memory for demonstration)
class InMemoryUserRepository : public IUserRepository {
private:
    std::map<std::string, User> users; // Stores copies of User objects

public:
    User save(const User& user) override {
        std::cout << "UserRepository: Saving user " << user.name << " (" << user.id << ") to in-memory store...\n";
        users[user.id] = user; // Store a copy
        return users[user.id]; // Return the stored copy (or original if passed by non-const ref)
    }

    User* findById(const std::string& userId) override {
        std::cout << "UserRepository: Finding user by ID: " << userId << " from in-memory store.\n";
        auto it = users.find(userId);
        if (it != users.end()) {
            return &(it->second); // Return pointer to the stored object
        }
        return nullptr; // Not found
    }
};

// --- Responsibility 2: User Validation ---
// Interface for user data validation.
// This interface/class handles validating user data against business rules.
// It would change only if the validation rules themselves change.
class IUserValidator {
public:
    virtual ~IUserValidator() = default;
    virtual void validate(const User& user) = 0; // Throws an exception if invalid
};

class UserValidatorImpl : public IUserValidator {
public:
    void validate(const User& user) override {
        std::cout << "UserValidator: Validating user " << user.name << " (" << user.id << ")...\n";
        if (user.name.empty()) {
            throw std::invalid_argument("Validation Error: User name cannot be blank.");
        }
        if (user.email.find('@') == std::string::npos || user.email.find('.') == std::string::npos) {
            throw std::invalid_argument("Validation Error: Invalid email format for " + user.email + ".");
        }
        // Add more complex validation rules here
        std::cout << "UserValidator: Validation successful.\n";
    }
};

// --- Responsibility 3: User Presentation/Display Formatting ---
// Interface for user data presentation.
// This interface/class handles formatting user data for various display purposes.
// It would change only if the presentation format or UI requirements change.
class IUserPresenter {
public:
    virtual ~IUserPresenter() = default;
    virtual std::string formatForConsole(const User& user) = 0;
    virtual std::string formatForJson(const User& user) = 0; // Example for another format
};

class UserPresenterImpl : public IUserPresenter {
public:
    std::string formatForConsole(const User& user) override {
        std::cout << "UserPresenter: Formatting user " << user.name << " (" << user.id << ") for console display...\n";
        std::string status = user.isActive ? "Active" : "Inactive";
        return "User ID: " + user.id + "\nName: " + user.name + "\nEmail: " + user.email + "\nStatus: " + status;
    }

    std::string formatForJson(const User& user) override {
        std::cout << "UserPresenter: Formatting user " << user.name << " (" << user.id << ") for JSON display...\n";
        // In a real app, you'd use a JSON library
        std::string json = "{\"id\":\"" + user.id + "\", \"name\":\"" + user.name + "\", \"email\":\"" + user.email + "\", \"active\":" + (user.isActive ? "true" : "false") + "}";
        return json;
    }
};

// --- The Orchestrator / Manager ---
// This class's single responsibility is to manage the flow of user operations.
// It delegates specific tasks to its collaborators.
class UserService {
private:
    IUserRepository& userRepository;
    IUserValidator& userValidator;
    IUserPresenter& userPresenter;

public:
    // Dependencies are injected via constructor (prefer smart pointers in real apps)
    UserService(IUserRepository& repo, IUserValidator& validator, IUserPresenter& presenter)
        : userRepository(repo), userValidator(validator), userPresenter(presenter) {}

    User createUser(const std::string& id, const std::string& name, const std::string& email) {
        User newUser(id, name, email);

        // Delegate validation
        userValidator.validate(newUser); // Will throw if invalid

        // Delegate saving
        return userRepository.save(newUser);
    }

    std::string getFormattedUserDetails(const std::string& userId, const std::string& format = "console") {
        User* user = userRepository.findById(userId);
        if (user == nullptr) {
            throw std::out_of_range("User with ID " + userId + " not found.");
        }

        // Delegate formatting
        if (format == "console") {
            return userPresenter.formatForConsole(*user);
        } else if (format == "json") {
            return userPresenter.formatForJson(*user);
        } else {
            throw std::invalid_argument("Unsupported format: " + format);
        }
    }

    User activateUser(const std::string& userId) {
        User* user = userRepository.findById(userId);
        if (user == nullptr) {
            throw std::out_of_range("User with ID " + userId + " not found.");
        }
        user->isActive = true; // Modify the stored object directly in this simplified setup
        return userRepository.save(*user); // Save the updated status
    }
};

void runGoodUserExample() {
    std::cout << "\n--- Good SRP Example ---\n";

    // Instantiate the concrete implementations (dependencies)
    InMemoryUserRepository userRepository;
    UserValidatorImpl userValidator;
    UserPresenterImpl userPresenter;

    // Inject dependencies into the UserService
    UserService userService(userRepository, userValidator, userPresenter);

    try {
        User alice = userService.createUser("u123", "Alice Wonderland", "alice@example.com");
        std::cout << "Created: " << alice.name << "\n";

        User bob = userService.createUser("u124", "Bob The Builder", "bob@example.net");
        std::cout << "Created: " << bob.name << "\n";

        std::cout << "\nFormatted for console:\n" << userService.getFormattedUserDetails("u123") << "\n";
        std::cout << "\nFormatted for JSON:\n" << userService.getFormattedUserDetails("u124", "json") << "\n";

        // Demonstrating a validation failure
        try {
            userService.createUser("u125", "", "invalid");
        } catch (const std::invalid_argument& e) {
            std::cout << "\nError creating user: " << e.what() << "\n";
        }

        // Demonstrating an update and re-saving
        User updatedBob = userService.activateUser("u124");
        std::cout << "\nUpdated Bob: " << updatedBob.name << " (Active: " << (updatedBob.isActive ? "true" : "false") << ")\n";

    } catch (const std::exception& e) {
        std::cout << "An unexpected error occurred: " << e.what() << "\n";
    }
}

/*
g++ user_good_example.cpp -o user_good_example
./user_good_example
*/
int main() {
    runGoodUserExample();
    return 0;
}