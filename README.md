# Daily Time Record Application

This is a Ruby on Rails application for managing departments, employees, and log records. It provides CRUD operations for each entity along with pagination support and database seeding for testing purposes.

## Setup

To set up and run this application locally, follow these steps:

### Prerequisites

- Ruby (version >= 2.5.0)
- Rails (version >= 6.0.0)
- PostgreSQL or SQLite database

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd daily_time_record_app
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

4. (Optional) Seed the database with sample data:

   ```bash
   rails db:seed
   ```

### Running the Application

Start the Rails server:

```bash
rails server
```

The application will be accessible at `http://localhost:3000` when ran **locally**.

## Usage

### CRUD Endpoints

#### Departments

- **Create a Department**
  - Endpoint: POST `/departments`
  - Payload: `{"department": {"name": "Engineering"}}`
  - Example:
    ```bash
    curl -X POST "http://localhost:3000/departments" -d '{"department": {"name": "Engineering"}}' -H "Content-Type: application/json"
    ```

- **Read All Departments**
  - Endpoint: GET `/departments`
  - Example:
    ```bash
    curl -X GET "http://localhost:3000/departments"
    ```

- **Update a Department**
  - Endpoint: PATCH/PUT `/departments/:id`
  - Payload: `{"department": {"name": "Sales"}}`
  - Example:
    ```bash
    curl -X PATCH "http://localhost:3000/departments/1" -d '{"department": {"name": "Sales"}}' -H "Content-Type: application/json"
    ```

- **Delete a Department**
  - Endpoint: DELETE `/departments/:id`
  - Example:
    ```bash
    curl -X DELETE "http://localhost:3000/departments/1"
    ```

#### Employees

- **Create an Employee**
  - Endpoint: POST `/employees`
  - Payload: `{"employee": {"name": "John Doe", "department_id": 1}}`
  - Example:
    ```bash
    curl -X POST "http://localhost:3000/employees" -d '{"employee": {"name": "John Doe", "department_id": 1}}' -H "Content-Type: application/json"
    ```

- **Read All Employees**
  - Endpoint: GET `/employees`
  - Example:
    ```bash
    curl -X GET "http://localhost:3000/employees"
    ```

- **Update an Employee**
  - Endpoint: PATCH/PUT `/employees/:id`
  - Payload: `{"employee": {"name": "Jane Doe"}}`
  - Example:
    ```bash
    curl -X PATCH "http://localhost:3000/employees/1" -d '{"employee": {"name": "Jane Doe"}}' -H "Content-Type: application/json"
    ```

- **Delete an Employee**
  - Endpoint: DELETE `/employees/:id`
  - Example:
    ```bash
    curl -X DELETE "http://localhost:3000/employees/1"
    ```

#### Log Records

- **Create a Log Record**
  - Endpoint: POST `/log_records`
  - Payload: `{"log_record": {"employee_id": 1, "time_in": "2024-06-19T09:00:00Z", "time_out": "2024-06-19T17:00:00Z"}}`
  - Example:
    ```bash
    curl -X POST "http://localhost:3000/log_records" -d '{"log_record": {"employee_id": 1, "time_in": "2024-06-19T09:00:00Z", "time_out": "2024-06-19T17:00:00Z"}}' -H "Content-Type: application/json"
    ```

- **Read All Log Records**
  - Endpoint: GET `/log_records`
  - Example:
    ```bash
    curl -X GET "http://localhost:3000/log_records"
    ```

- **Update a Log Record**
  - Endpoint: PATCH/PUT `/log_records/:id`
  - Payload: `{"log_record": {"time_out": "2024-06-19T18:00:00Z"}}`
  - Example:
    ```bash
    curl -X PATCH "http://localhost:3000/log_records/1" -d '{"log_record": {"time_out": "2024-06-19T18:00:00Z"}}' -H "Content-Type: application/json"
    ```

- **Delete a Log Record**
  - Endpoint: DELETE `/log_records/:id`
  - Example:
    ```bash
    curl -X DELETE "http://localhost:3000/log_records/1"
    ```

### Pagination

- Pagination is supported for `departments`, `employees`, and `log_records` endpoints.
- Use `page` and `items` query parameters to paginate results.
- Example:
  ```bash
  # Get the first page of departments with 10 items per page
  curl -X GET "http://localhost:3000/departments?page=1&items=10"
  
  # Get the second page of employees with default items per page
  curl -X GET "http://localhost:3000/employees?page=2"
  ```

### Item Counts

- The total count of items for each resource is available in the pagination metadata returned with each paginated response.

### Database Seeding

- Seed the database with sample data using the `db/seeds.rb` file.
- Run the seed task to populate the database:
  ```bash
  rails db:seed
  ```

- Sample data includes departments, employees, and log records for testing and development purposes.