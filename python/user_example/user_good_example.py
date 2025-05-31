
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
import re # For email validation
import json # For JSON formatting

'''
The Good Way: Adhering to SRP (Delegated Responsibilities)
    Here, we decompose the GoodUser concept. The GoodUser object becomes a simple data
    holder using Python's dataclasses module. We then create specialized
    Abstract Base Classes (ABCs) for persistence, validation, and presentation,
    along with their concrete implementations. Finally, a UserService orchestrates these independent components.
'''

'''
Explanation of Adherence to SRP:

Each class in the "Good Way" now adheres to the Single Responsibility Principle because it has only one reason to change:

- GoodUser (dataclass):
    This class is purely a data holder. It changes only if the fundamental attributes of a user
    (e.g., adding a phone_number field) change. It contains no business logic or external operations.

- UserRepository / InMemoryUserRepository:
    This component is solely responsible for user data persistence. It changes only if the underlying
    data storage mechanism or schema (e.g., switching from an in-memory dictionary to a SQL database,
    or altering table structures) changes.

- UserValidator / UserValidatorImpl:
    This component focuses entirely on user data validation. It changes only if the business rules
    that define a valid user (e.g., new mandatory fields, different email regex, password complexity
    requirements) change.

- UserPresenter / UserPresenterImpl:
    This component handles user data presentation and formatting. It changes only if the requirements
    for how user data is displayed (e.g., rendering on a web UI, generating a different JSON API
    response, formatting for a PDF report) change.

- UserService:
    This class's single responsibility is orchestration or managing the user lifecycle. It acts as a
    coordinator, knowing which specialized component to use for specific tasks (like validation,
    saving, or formatting). It changes only if the high-level workflow or steps involved in managing
    a user change (e.g., adding a step to send a welcome email after user creation, or integrating
    with an external identity provider). It delegates the specific technical operations to its
    collaborators.

This robust separation of concerns leads to:

- High Cohesion:
    Each class's internal elements are tightly related and contribute to its single, well-defined
    purpose.

- Loose Coupling:
    Changes within one component (e.g., the InMemoryUserRepository switching to a different database
    implementation) will not directly impact other components like UserValidatorImpl or
    UserPresenterImpl. The UserService would simply be configured with a different UserRepository
    implementation, which is a minor configuration change, not a fundamental logic alteration within
    the service itself.

- Easier Testing:
    Each component can be unit-tested in isolation, mocking only its immediate dependencies, leading
    to simpler, faster, and more reliable tests.

- Improved Maintainability:
    Developers can quickly identify and modify the relevant code for a specific change without fear
    of inadvertently breaking unrelated parts of the system.
'''


# GoodUser Data Structure - now it ONLY holds data.
# It has no behavioral methods related to saving, validating, or formatting for display.
@dataclass
class GoodUser:
    id: str
    name: str
    email: str
    is_active: bool = True

# --- Responsibility 1: GoodUser Persistence ---
# This Abstract Base Class (interface) defines the contract for user data persistence.
# Implementations would change only if the persistence mechanism or data schema changes.
class UserRepository(ABC):
    @abstractmethod
    def save(self, user: GoodUser) -> GoodUser:
        pass

    @abstractmethod
    def get_by_id(self, user_id: str) -> GoodUser | None: # Python 3.10+ for | None
        pass

# Concrete implementation (e.g., in-memory for demonstration)
class InMemoryUserRepository(UserRepository):
    def __init__(self):
        self._users: dict[str, GoodUser] = {} # Use dict for in-memory storage

    def save(self, user: GoodUser) -> GoodUser:
        print(f"UserRepository: Saving user {user.name} ({user.id}) to in-memory store...")
        self._users[user.id] = user # Store the user (adds or updates if ID exists)
        return user

    def get_by_id(self, user_id: str) -> GoodUser | None:
        print(f"UserRepository: Getting user by ID: {user_id} from in-memory store.")
        return self._users.get(user_id) # Returns None if not found

# --- Responsibility 2: GoodUser Validation ---
# This Abstract Base Class (interface) defines the contract for user data validation.
# Implementations would change only if the validation rules themselves change.
class UserValidator(ABC):
    @abstractmethod
    def validate(self, user: GoodUser) -> None: # Throws an exception if invalid
        pass

class UserValidatorImpl(UserValidator):
    def validate(self, user: GoodUser) -> None:
        print(f"UserValidator: Validating user {user.name} ({user.id})...")
        if not user.name.strip():
            raise ValueError("Validation Error: GoodUser name cannot be blank.")
        if not re.match(r"[^@]+@[^@]+\.[^@]+", user.email):
            raise ValueError(f"Validation Error: Invalid email format for {user.email}.")
        # Add more complex validation rules here
        print("UserValidator: Validation successful.")

# --- Responsibility 3: GoodUser Presentation/Display Formatting ---
# This Abstract Base Class (interface) defines the contract for user data presentation.
# Implementations would change only if the presentation format or UI requirements change.
class UserPresenter(ABC):
    @abstractmethod
    def format_for_console(self, user: GoodUser) -> str:
        pass

    @abstractmethod
    def format_for_json(self, user: GoodUser) -> str: # Example for another format
        pass

class UserPresenterImpl(UserPresenter):
    def format_for_console(self, user: GoodUser) -> str:
        print(f"UserPresenter: Formatting user {user.name} ({user.id}) for console display...")
        status = "Active" if user.is_active else "Inactive"
        return f"GoodUser ID: {user.id}\nName: {user.name}\nEmail: {user.email}\nStatus: {status}"

    def format_for_json(self, user: GoodUser) -> str:
        print(f"UserPresenter: Formatting user {user.name} ({user.id}) for JSON display...")
        # Convert dataclass to dict and then to JSON string
        user_dict = {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "active": user.is_active
        }
        return json.dumps(user_dict, indent=2)

# --- The Orchestrator / Manager ---
# This class's single responsibility is to manage the flow of user operations.
# It delegates specific tasks to its collaborators.
class UserService:
    def __init__(self, user_repository: UserRepository, user_validator: UserValidator, user_presenter: UserPresenter):
        self._user_repository = user_repository
        self._user_validator = user_validator
        self._user_presenter = user_presenter

    def create_user(self, id: str, name: str, email: str) -> GoodUser:
        new_user = GoodUser(id=id, name=name, email=email)

        # Delegate validation
        self._user_validator.validate(new_user) # Will raise ValueError if invalid

        # Delegate saving
        return self._user_repository.save(new_user)

    def get_formatted_user_details(self, user_id: str, format_type: str = "console") -> str:
        user = self._user_repository.get_by_id(user_id)
        if user is None:
            raise KeyError(f"GoodUser with ID {user_id} not found.")

        # Delegate formatting
        if format_type.lower() == "console":
            return self._user_presenter.format_for_console(user)
        elif format_type.lower() == "json":
            return self._user_presenter.format_for_json(user)
        else:
            raise ValueError(f"Unsupported format: {format_type}")

    def activate_user(self, user_id: str) -> GoodUser:
        user = self._user_repository.get_by_id(user_id)
        if user is None:
            raise KeyError(f"GoodUser with ID {user_id} not found.")
        user.is_active = True # Modify the fetched user object
        return self._user_repository.save(user) # Save the updated status