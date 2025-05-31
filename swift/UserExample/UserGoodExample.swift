import Foundation // For String operations and Error protocol

/*
 The Good Way: Adhering to SRP (Delegated Responsibilities)

 Here, we decompose the GoodUser concept. The GoodUser struct becomes a simple data holder.
 We then create specialized protocols (Swift's equivalent of interfaces) for persistence,
 validation, and presentation, along with their concrete implementations.
 Finally, a UserService orchestrates these independent components.
 */

/*
 Explanation of Adherence to SRP:

 Each component in the "Good Way" now adheres to the Single Responsibility Principle
 because it has only one reason to change:

 GoodUser (struct):
    - This struct is purely a data holder.
    - It changes only if the fundamental attributes of a user (e.g., adding a phoneNumber property) change.
    - It contains no business logic or external operations.
    - Swift structs are value types, which reinforces this data-only role; modifications create new instances.

 UserRepository / InMemoryUserRepository:
    - This component is solely responsible for user data persistence.
    - It changes only if the underlying data storage mechanism or schema (e.g., switching from an in-memory dictionary to Core Data, or altering database table structures) changes.

 UserValidator / UserValidatorImpl:
    - This component focuses entirely on user data validation.
    - It changes only if the business rules that define a valid user (e.g., new mandatory fields, different email regex, password complexity updates) change.

 UserPresenter / UserPresenterImpl:
    - This component handles user data presentation and formatting.
    - It changes only if the requirements for how user data is displayed (e.g., rendering on a SwiftUI view, generating a different JSON API response, formatting for a PDF report) change.

 UserService:
    - This class's single responsibility is orchestration or managing the user lifecycle.
    - It acts as a coordinator, knowing which specialized component to use for specific tasks (like validation, saving, or formatting).
    - It changes only if the high-level workflow or steps involved in managing a user change (e.g., adding a step to send a welcome email after user creation, or integrating with an external identity provider).
    - It delegates the specific technical operations to its collaborators.

 This robust separation of concerns leads to:

 High Cohesion:
    - Each component's internal elements are tightly related and contribute to its single, well-defined purpose.

 Loose Coupling:
    - Changes within one component (e.g., the InMemoryUserRepository switching to a Core Data implementation) will not directly impact other components like UserValidatorImpl or UserPresenterImpl.
    - The UserService would simply be initialized with a different UserRepository implementation, which is a minor configuration change, not a fundamental logic alteration within the service itself.

 Easier Testing:
    - Each component can be unit-tested in isolation, mocking only its immediate dependencies, leading to simpler, faster, and more reliable tests.

 Improved Maintainability:
    - Developers can quickly identify and modify the relevant code for a specific change without fear of inadvertently breaking unrelated parts of the system.
 */


// GoodUser Data Structure - now it ONLY holds data.
// Using a struct for value semantics, which is idiomatic Swift for data models.
// Its fields are 'var' to allow modification when fetched from repository.
public struct GoodUser: Identifiable, Hashable { // Identifiable for potential SwiftUI list, Hashable for Dictionary keys
    public let id: String // ID is usually immutable
    var name: String
    var email: String
    var isActive: Bool

    init(id: String, name: String, email: String, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.email = email
        self.isActive = isActive
    }
}

// Custom error for validation
public enum UserValidationError: Error, CustomStringConvertible {
    case invalidName(String)
    case invalidEmail(String)
    // Add more specific validation errors

    public var description: String {
        switch self {
        case .invalidName(let name): return "Validation Error: GoodUser name '\(name)' cannot be blank."
        case .invalidEmail(let email): return "Validation Error: Invalid email format for '\(email)'."
        }
    }
}

public enum UserDataError: Error, CustomStringConvertible {
    case userNotFound(String)

    public var description: String {
        switch self {
        case .userNotFound(let id): return "Data Error: GoodUser with ID \(id) not found."
        }
    }
}


// --- Responsibility 1: GoodUser Persistence ---
// This protocol defines the contract for user data persistence.
// Implementations would change only if the persistence mechanism or data schema changes.
public protocol UserRepository {
    func save(user: GoodUser) -> GoodUser
    func getById(userId: String) -> GoodUser?
}

// Concrete implementation (e.g., in-memory for demonstration)
public class InMemoryUserRepository: UserRepository {
    private var users: [String: GoodUser] = [:] // Use Dictionary for in-memory storage

    public func save(user: GoodUser) -> GoodUser {
        print("UserRepository: Saving user \(user.name) (\(user.id)) to in-memory store...")
        users[user.id] = user // Store the user (adds or updates if ID exists)
        return user
    }

    public func getById(userId: String) -> GoodUser? {
        print("UserRepository: Getting user by ID: \(userId) from in-memory store.")
        return users[userId]
    }
}

// --- Responsibility 2: GoodUser Validation ---
// This protocol defines the contract for user data validation.
// Implementations would change only if the validation rules themselves change.
public protocol UserValidator {
    func validate(user: GoodUser) throws // Throws an error if invalid
}

public class UserValidatorImpl: UserValidator {
    public func validate(user: GoodUser) throws {
        print("UserValidator: Validating user \(user.name) (\(user.id))...")
        if user.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw UserValidationError.invalidName(user.name)
        }
        if !user.email.contains("@") || !user.email.contains(".") {
            throw UserValidationError.invalidEmail(user.email)
        }
        // Add more complex validation rules here
        print("UserValidator: Validation successful.")
    }
}

// --- Responsibility 3: GoodUser Presentation/Display Formatting ---
// This protocol defines the contract for user data presentation.
// Implementations would change only if the presentation format or UI requirements change.
public protocol UserPresenter {
    func formatForConsole(user: GoodUser) -> String
    func formatForJson(user: GoodUser) -> String // Example for another format
}

public class UserPresenterImpl: UserPresenter {
    public func formatForConsole(user: GoodUser) -> String {
        print("UserPresenter: Formatting user \(user.name) (\(user.id)) for console display...")
        let status = user.isActive ? "Active" : "Inactive"
        return "GoodUser ID: \(user.id)\nName: \(user.name)\nEmail: \(user.email)\nStatus: \(status)"
    }

    public func formatForJson(user: GoodUser) -> String {
        print("UserPresenter: Formatting user \(user.name) (\(user.id)) for JSON display...")
        // In a real app, you'd use Codable/JSONEncoder
        let userData: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "active": user.isActive
        ]
        // This is a simplified JSON string representation for demonstration
        if let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: [.prettyPrinted]),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return "{}" // Fallback
    }
}

// --- The Orchestrator / Manager ---
// This class's single responsibility is to manage the flow of user operations.
// It delegates specific tasks to its collaborators.
public class UserService {
    private let userRepository: UserRepository
    private let userValidator: UserValidator
    private let userPresenter: UserPresenter

    // Dependencies are injected via constructor (Dependency Injection is key for SRP adherence)
    init(userRepository: UserRepository, userValidator: UserValidator, userPresenter: UserPresenter) {
        self.userRepository = userRepository
        self.userValidator = userValidator
        self.userPresenter = userPresenter
    }

    func createUser(id: String, name: String, email: String) throws -> GoodUser {
        let newUser = GoodUser(id: id, name: name, email: email)

        // Delegate validation
        try userValidator.validate(user: newUser) // Will throw if invalid

        // Delegate saving
        return userRepository.save(user: newUser)
    }

    func getFormattedUserDetails(userId: String, format: String = "console") throws -> String {
        guard let user = userRepository.getById(userId: userId) else {
            throw UserDataError.userNotFound(userId)
        }

        // Delegate formatting
        switch format.lowercased() {
        case "console":
            return userPresenter.formatForConsole(user: user)
        case "json":
            return userPresenter.formatForJson(user: user)
        default:
            throw UserDataError.userNotFound("Unsupported format: \(format)") // Using DataError for simplicity, a custom error would be better here
        }
    }

    func activateUser(userId: String) throws -> GoodUser {
        guard var user = userRepository.getById(userId: userId) else {
            throw UserDataError.userNotFound(userId)
        }
        user.isActive = true // Modify the fetched user struct
        return userRepository.save(user: user) // Save the updated status
    }
}