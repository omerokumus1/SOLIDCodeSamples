from user_example.user_bad_example import BadUser
from user_example.user_good_example import UserService, InMemoryUserRepository, UserValidatorImpl, UserPresenterImpl

def run_bad_user_example():
    print("--- Bad SRP Example ---")
    bad_user = BadUser("u123", "Alice Smith", "alice@example.com")

    if bad_user.is_valid():
        bad_user.save_to_database()
    else:
        print("User is invalid, cannot save.")

    print(f"\nDisplaying user info:\n{bad_user.format_for_display()}")

    # Imagine a change: Now emails must end with ".org"
    # -> You change is_valid() directly within the BadUser class.

    # Imagine another change: Store users in a file instead of a DB
    # -> You change save_to_database() directly within the BadUser class.

    # Imagine another change: Display user as a JSON string for a new API
    # -> You change format_for_display() directly within the BadUser class.
    # Notice how BadUser changes for multiple unrelated reasons, making it fragile.

def run_good_user_example():
    print("\n--- Good SRP Example ---")

    # Instantiate the concrete implementations (dependencies)
    user_repository = InMemoryUserRepository()
    user_validator = UserValidatorImpl()
    user_presenter = UserPresenterImpl()

    # Inject dependencies into the UserService
    user_service = UserService(user_repository, user_validator, user_presenter)

    try:
        alice = user_service.create_user("u123", "Alice Wonderland", "alice@example.com")
        print(f"Created: {alice.name}")

        bob = user_service.create_user("u124", "Bob The Builder", "bob@example.net")
        print(f"Created: {bob.name}")

        print(f"\nFormatted for console:\n{user_service.get_formatted_user_details('u123')}")
        print(f"\nFormatted for JSON:\n{user_service.get_formatted_user_details('u124', format_type='json')}")

        # Demonstrating a validation failure
        try:
            user_service.create_user("u125", "", "invalid")
        except ValueError as e:
            print(f"\nError creating user: {e}")

        # Demonstrating an update and re-saving
        updated_bob = user_service.activate_user("u124")
        print(f"\nUpdated Bob: {updated_bob.name} (Active: {updated_bob.is_active})")

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Run both examples
if __name__ == "__main__":
    run_bad_user_example()
    run_good_user_example()