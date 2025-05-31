import Foundation

/*
Run this in the terminal. Current directory should be the root of the project:
swiftc swift/main.swift swift/UserExample/UserBadExample.swift swift/UserExample/UserGoodExample.swift  -o main && ./main
*/

func runBadUserExample() {
    print("--- Bad SRP Example ---")
    let badUser = BadUser(id: "u123", name: "Alice Smith", email: "alice@example.com")

    if badUser.isValid() {
        badUser.saveToDatabase()
    } else {
        print("User is invalid, cannot save.")
    }

    print("\nDisplaying user info:\n\(badUser.formatForDisplay())")

    // Imagine a change: Now emails must end with ".org"
    // -> You change isValid() directly within the BadUser class.

    // Imagine another change: Store users in a file instead of a DB
    // -> You change saveToDatabase() directly within the BadUser class.

    // Imagine another change: Display user as a JSON string for a new API
    // -> You change formatForDisplay() directly within the BadUser class.
    // Notice how BadUser changes for multiple unrelated reasons, making it fragile.
}

func runGoodUserExample() {
    print("\n--- Good SRP Example ---")

    // Instantiate the concrete implementations (dependencies)
    let userRepository = InMemoryUserRepository()
    let userValidator = UserValidatorImpl()
    let userPresenter = UserPresenterImpl()

    // Inject dependencies into the UserService
    let userService = UserService(userRepository: userRepository, userValidator: userValidator, userPresenter: userPresenter)

    do {
        let alice = try userService.createUser(id: "u123", name: "Alice Wonderland", email: "alice@example.com")
        print("Created: \(alice.name)")

        let bob = try userService.createUser(id: "u124", name: "Bob The Builder", email: "bob@example.net")
        print("Created: \(bob.name)")

        print("\nFormatted for console:\n\(try userService.getFormattedUserDetails(userId: "u123"))")
        print("\nFormatted for JSON:\n\(try userService.getFormattedUserDetails(userId: "u124", format: "json"))")

        // Demonstrating a validation failure
        do {
            _ = try userService.createUser(id: "u125", name: "", email: "invalid")
        } catch let error as UserValidationError {
            print("\nError creating user: \(error.description)")
        } catch {
            print("\nAn unexpected error during creation: \(error)")
        }

        // Demonstrating an update and re-saving
        let updatedBob = try userService.activateUser(userId: "u124")
        print("\nUpdated Bob: \(updatedBob.name) (Active: \(updatedBob.isActive))")

    } catch let error as UserDataError {
        print("A user data error occurred: \(error.description)")
    } catch {
        print("An unexpected error occurred: \(error)")
    }
}

// Call the example functions
runBadUserExample()
runGoodUserExample()