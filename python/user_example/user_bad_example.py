import re # For simple email validation

'''
The Bad Way: Violating SRP (Monolithic User Class)
    In this example, a single User class handles its data, saving it to a "database,"
    validating itself, and even formatting itself for display.
'''

'''
Explanation of the Violation:

The BadUser class in this "bad" example violates the Single Responsibility Principle because it has multiple distinct reasons to change:

    Persistence Logic:
        If the way users are saved (e.g., database type changes, API endpoint updates, file format shifts),
        the save_to_database() method within BadUser would need modification.

    Validation Rules:
        If the business rules defining a valid user change (e.g., new mandatory fields, different email regex,
        password complexity requirements), the is_valid() method within BadUser must be updated.

    Presentation Logic:
        If the requirements for how user data is displayed (e.g., for a web UI, a mobile app, or a different API response format) change,
        the format_for_display() method within BadUser must be altered.

Each of these is a separate concern with its own potential for modification.
Tying them all to one class makes the code fragile; a change for one reason could inadvertently introduce bugs into another unrelated part of the same class.
This leads to code that's harder to test, maintain, and understand.
'''



# Bad Example: User class with multiple responsibilities
class BadUser:
    def __init__(self, id: str, name: str, email: str, is_active: bool = True):
        self.id = id
        self.name = name
        self.email = email
        self.is_active = is_active

    # --- Responsibility 1: User Persistence ---
    # This method would change if:
    # - The database schema changes (e.g., add a 'phone' column)
    # - The persistence mechanism changes (e.g., from SQL DB to NoSQL, or a remote API)
    def save_to_database(self):
        print(f"User: Saving user {self.name} ({self.id}) to database...")
        # Simulate database save operation
        # This is where actual DB logic (e.g., SQLAlchemy, psycopg2, ORM calls) would live
        print("User: User saved to DB successfully.")

    # --- Responsibility 2: User Validation ---
    # This method would change if:
    # - Business rules for user validity change (e.g., email must contain '@domain.com')
    # - A new validation rule is added (e.g., password complexity, name cannot be empty)
    def is_valid(self) -> bool:
        print(f"User: Validating user {self.name} ({self.id})...")
        if not self.name.strip():
            print("Validation failed: Name cannot be blank.")
            return False
        # A simple regex for email validation
        if not re.match(r"[^@]+@[^@]+\.[^@]+", self.email):
            print("Validation failed: Invalid email format.")
            return False
        # More complex validation logic would go here
        print("User: Validation successful.")
        return True

    # --- Responsibility 3: User Presentation/Display Formatting ---
    # This method would change if:
    # - The UI requirements change (e.g., display full name instead of just first name)
    # - The output format changes (e.g., from console string to JSON, or HTML)
    def format_for_display(self) -> str:
        print(f"User: Formatting user {self.name} ({self.id}) for display...")
        status = "Active" if self.is_active else "Inactive"
        return f"User ID: {self.id}\nName: {self.name}\nEmail: {self.email}\nStatus: {status}"