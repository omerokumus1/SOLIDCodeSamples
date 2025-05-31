/*
    The Bad Way: Violating SRP (Monolithic User Class)

    In this example, a single User class handles its data,
    saving it to a "database," validating itself, and even formatting itself for display.
*/

/*
    Explanation of the Violation:

    The BadUser class in this "bad" example violates the Single Responsibility Principle
    because it has multiple distinct reasons to change:

    Persistence Logic:
        If the way users are saved (e.g., database type changes, API endpoint updates, file format shifts),
        the saveToDatabase() method within BadUser would need modification.

    Validation Rules:
        If the business rules defining a valid user change (e.g., new mandatory fields, different email regex,
        password complexity requirements), the isValid() method within BadUser must be updated.

    Presentation Logic:
        If the requirements for how user data is displayed (e.g., for a web UI, a mobile app,
        or a different API response format) change, the formatForDisplay() method within BadUser must be altered.

    Each of these is a separate concern with its own potential for modification.
    Tying them all to one class makes the code fragile; a change for one reason could inadvertently introduce
    bugs into another unrelated part of the same class. This leads to code that's harder to test, maintain, and understand.
*/

// Bad Example: User class with multiple responsibilities
export class BadUser {
  public id: string;
  public name: string;
  public email: string;
  public isActive: boolean;

  constructor(
    id: string,
    name: string,
    email: string,
    isActive: boolean = true
  ) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.isActive = isActive;
  }

  // --- Responsibility 1: User Persistence ---
  // This method would change if:
  // - The database schema changes (e.g., add a 'phoneNumber' column)
  // - The persistence mechanism changes (e.g., from local storage to a remote API, or a different ORM)
  public saveToDatabase(): void {
    console.log(`User: Saving user ${this.name} (${this.id}) to database...`);
    // Simulate database save operation
    // This is where actual DB logic (e.g., Axios for API, TypeORM for DB) would live
    console.log('User: User saved to DB successfully.');
  }

  // --- Responsibility 2: User Validation ---
  // This method would change if:
  // - Business rules for user validity change (e.g., email must contain '@domain.com')
  // - A new validation rule is added (e.g., password complexity, name cannot be empty)
  public isValid(): boolean {
    console.log(`User: Validating user ${this.name} (${this.id})...`);
    if (!this.name.trim()) {
      console.log('Validation failed: Name cannot be blank.');
      return false;
    }
    if (!this.email.includes('@') || !this.email.includes('.')) {
      console.log('Validation failed: Invalid email format.');
      return false;
    }
    // More complex validation logic would go here
    console.log('User: Validation successful.');
    return true;
  }

  // --- Responsibility 3: User Presentation/Display Formatting ---
  // This method would change if:
  // - The UI requirements change (e.g., display full name instead of just first name)
  // - The output format changes (e.g., from console string to JSON, or HTML)
  public formatForDisplay(): string {
    console.log(
      `User: Formatting user ${this.name} (${this.id}) for display...`
    );
    const status = this.isActive ? 'Active' : 'Inactive';
    return `User ID: ${this.id}\nName: ${this.name}\nEmail: ${this.email}\nStatus: ${status}`;
  }
}
