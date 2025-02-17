# Library Management System Database

A fully functional MySQL database for managing a library. Includes advanced SQL features like triggers, transactions, stored procedures, and views.

## Features
- **Tables**: Books, members, borrowings, authors, and genres.
- **Triggers**: Automatically update book availability.
- **Stored Procedures**: Simplify borrowing and returning books.
- **Views**: Easy access to available and borrowed books.
- **Sample Data**: Pre-populated data for testing.

---

## How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/library-management-system.git
2. Set up the database:
   ```bash
   mysql -u your_username -p < library_management.sql
3. Explore the database using MySQL queries.

---

# Student Management System

A **Student Management System** built with **MySQL**. This system manages students, courses, enrollments, and grades. It includes **stored procedures**, **triggers**, and **views** for easy interaction with the database.

## Features
- Manage students, courses, and enrollments.
- Add grades for students.
- Prevent duplicate enrollments with a trigger.
- View student enrollments and grades.

## Setup
1. Run the `student_management.sql` script in your MySQL server.
2. Use the provided stored procedures and views to interact with the database.

## Sample Queries
- Get all students: `SELECT * FROM students;`
- Enroll a student: `CALL enroll_student(1, 3);`
- Add a grade: `CALL add_grade(5, 'B');`

---

## License

This projects is licensed under the **MIT License**.



