-- Create the database
CREATE DATABASE student_management;
USE student_management;

-- Table: students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    enrollment_date DATE DEFAULT (CURRENT_DATE)
);

-- Table: courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL
);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Table: grades
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT,
    grade CHAR(1) NOT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

-- Trigger: Prevent duplicate enrollments
DELIMITER //
CREATE TRIGGER prevent_duplicate_enrollment
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM enrollments WHERE student_id = NEW.student_id AND course_id = NEW.course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student is already enrolled in this course';
    END IF;
END //
DELIMITER ;

-- Stored Procedure: Enroll a student in a course
DELIMITER //
CREATE PROCEDURE enroll_student(IN p_student_id INT, IN p_course_id INT)
BEGIN
    START TRANSACTION;
    INSERT INTO enrollments (student_id, course_id)
    VALUES (p_student_id, p_course_id);
    COMMIT;
END //
DELIMITER ;

-- Stored Procedure: Add a grade for a student in a course
DELIMITER //
CREATE PROCEDURE add_grade(IN p_enrollment_id INT, IN p_grade CHAR(1))
BEGIN
    START TRANSACTION;
    INSERT INTO grades (enrollment_id, grade)
    VALUES (p_enrollment_id, p_grade);
    COMMIT;
END //
DELIMITER ;

-- View: Student enrollments
CREATE VIEW student_enrollments AS
SELECT s.student_id, s.first_name, s.last_name, c.course_name, e.enrollment_date
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- View: Student grades
CREATE VIEW student_grades AS
SELECT s.student_id, s.first_name, s.last_name, c.course_name, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Insert sample students
INSERT INTO students (first_name, last_name, email, date_of_birth) VALUES
('John', 'Doe', 'john.doe@example.com', '2000-05-15'),
('Jane', 'Smith', 'jane.smith@example.com', '2001-08-22'),
('Alice', 'Johnson', 'alice.johnson@example.com', '1999-12-10');

-- Insert sample courses
INSERT INTO courses (course_name, course_code) VALUES
('Mathematics', 'MATH101'),
('Physics', 'PHYS101'),
('Computer Science', 'CS101');

-- Enroll students in courses
CALL enroll_student(1, 1); -- John enrolls in Mathematics
CALL enroll_student(1, 2); -- John enrolls in Physics
CALL enroll_student(2, 3); -- Jane enrolls in Computer Science
CALL enroll_student(3, 1); -- Alice enrolls in Mathematics

-- Add grades for students
CALL add_grade(1, 'A'); -- John gets an A in Mathematics
CALL add_grade(2, 'B'); -- John gets a B in Physics
CALL add_grade(3, 'A'); -- Jane gets an A in Computer Science
CALL add_grade(4, 'C'); -- Alice gets a C in Mathematics