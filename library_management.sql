-- Create the database
CREATE DATABASE library_management;
USE library_management;

-- Table: authors
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: genres
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Table: books
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT,
    genre_id INT,
    published_year YEAR,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Table: members
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE DEFAULT (CURRENT_DATE)
);

-- Table: borrowings
CREATE TABLE borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Trigger: Update book availability on borrow
DELIMITER //
CREATE TRIGGER update_book_availability_on_borrow
AFTER INSERT ON borrowings
FOR EACH ROW
BEGIN
    UPDATE books
    SET is_available = FALSE
    WHERE book_id = NEW.book_id;
END //
DELIMITER ;

-- Trigger: Update book availability on return
DELIMITER //
CREATE TRIGGER update_book_availability_on_return
AFTER UPDATE ON borrowings
FOR EACH ROW
BEGIN
    IF NEW.return_date IS NOT NULL THEN
        UPDATE books
        SET is_available = TRUE
        WHERE book_id = NEW.book_id;
    END IF;
END //
DELIMITER ;

-- Stored Procedure: Borrow a book
DELIMITER //
CREATE PROCEDURE borrow_book(IN p_book_id INT, IN p_member_id INT)
BEGIN
    START TRANSACTION;
    INSERT INTO borrowings (book_id, member_id)
    VALUES (p_book_id, p_member_id);
    COMMIT;
END //
DELIMITER ;

-- Stored Procedure: Return a book
DELIMITER //
CREATE PROCEDURE return_book(IN p_borrowing_id INT)
BEGIN
    START TRANSACTION;
    UPDATE borrowings
    SET return_date = CURRENT_DATE
    WHERE borrowing_id = p_borrowing_id;
    COMMIT;
END //
DELIMITER ;

-- View: Available books
CREATE VIEW available_books AS
SELECT b.book_id, b.title, a.name AS author, g.name AS genre, b.published_year
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN genres g ON b.genre_id = g.genre_id
WHERE b.is_available = TRUE;

-- View: Borrowed books
CREATE VIEW borrowed_books AS
SELECT br.borrowing_id, b.title, m.name AS member_name, br.borrow_date, br.return_date
FROM borrowings br
JOIN books b ON br.book_id = b.book_id
JOIN members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL;

-- Insert sample authors
INSERT INTO authors (name) VALUES
('J.K. Rowling'),
('George Orwell'),
('Agatha Christie');

-- Insert sample genres
INSERT INTO genres (name) VALUES
('Fantasy'),
('Dystopian'),
('Mystery');

-- Insert sample books
INSERT INTO books (title, author_id, genre_id, published_year) VALUES
('Harry Potter and the Philosopher''s Stone', 1, 1, 1997),
('1984', 2, 2, 1949),
('Murder on the Orient Express', 3, 3, 1934);

-- Insert sample members
INSERT INTO members (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com');

-- Borrow a book
CALL borrow_book(1, 1); -- Alice borrows Harry Potter
CALL borrow_book(2, 2); -- Bob borrows 1984