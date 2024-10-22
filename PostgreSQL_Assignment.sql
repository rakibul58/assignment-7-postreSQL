-- Active: 1729082098095@@127.0.0.1@5432@university_db
-- Creating Database
CREATE DATABASE university_db;

-- Creating Students Table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(255),
    age INT,
    email VARCHAR(255) UNIQUE,
    frontend_mark INT,
    backend_mark INT,
    status VARCHAR(255)
) 

-- Inserting Random Data in Students Table
INSERT INTO
    students (
        student_id,
        student_name,
        age,
        email,
        frontend_mark,
        backend_mark,
        status
    )
VALUES
    (
        1,
        'Sameer',
        21,
        'sameer@example.com',
        48,
        60,
        NULL
    ),
    (2, 'Zoya', 23, 'zoya@example.com', 52, 58, NULL),
    (
        3,
        'Nabil',
        22,
        'nabil@example.com',
        37,
        46,
        NULL
    ),
    (4, 'Rafi', 24, 'rafi@example.com', 41, 40, NULL),
    (
        5,
        'Sophia',
        22,
        'sophia@example.com',
        50,
        52,
        NULL
    ),
    (6, 'Hasan', 23, 'hasan@gmail.com', 43, 39, NULL);

-- Fetching all the students
SELECT * FROM students 

-- Creating Courses Table
CREATE TABLE courses (
        course_id SERIAL PRIMARY KEY,
        course_name VARCHAR(255),
        credits INT
    ) 
    
-- Inserting Random Courses Data
INSERT INTO
    courses (course_id, course_name, credits)
VALUES
    (1, 'Next.js', 3),
    (2, 'React.js', 4),
    (3, 'Databases', 3),
    (4, 'Prisma', 3);

-- Fetching Courses Data
SELECT * FROM courses

-- Creating Enrollment table
CREATE TABLE enrollment (
        enrollment_id SERIAL PRIMARY KEY,
        student_id INT REFERENCES students(student_id),
        course_id INT REFERENCES courses(course_id)
    ) 

-- Inserting enrollment data
INSERT INTO enrollment (enrollment_id, student_id, course_id)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 2);

-- Fetching all enrollment
SELECT * FROM enrollment

-- Query 1: Insert a new student record
INSERT INTO students
    ( student_name, age, email, frontend_mark, backend_mark, status)
    VALUES ('Rafique', 25, 'rafique@test.com', 60, 80, NULL)

-- Query 2: Retrieve the names of all students who are enrolled in the course titled 'Next.js'
SELECT student_name FROM students --only fetches student name
    WHERE student_id IN -- using in to get all the student_id
    (SELECT student_id from enrollment WHERE course_id = ( -- getting course_id from courses table with Next.js title
        SELECT course_id from courses WHERE course_name='Next.js'
    ))

-- Query 3: Update the status of the student with the highest total (frontend_mark + backend_mark) to 'Awarded'
UPDATE students
    SET status = 'Awarded'
    WHERE (frontend_mark + backend_mark) = (
        SELECT MAX(frontend_mark + backend_mark) -- will find the max frontend + backend mark
            FROM students
    )


-- Query 4: Delete all courses that have no students enrolled
DELETE FROM courses
    WHERE course_id NOT IN(
        SELECT course_id FROM enrollment
    )

-- Query 5: Retrieve the names of students using a limit of 2, starting from the 3rd student.
SELECT * FROM students
    LIMIT 2 OFFSET 2

-- Query 6: Retrieve the course names and the number of students enrolled in each course.
SELECT course_name, COUNT(enrollment.student_id) AS students_enrolled
    FROM courses
    LEFT JOIN enrollment ON courses.course_id = enrollment.course_id -- matching the course_id from course table with course_id of enrollment table
    GROUP BY courses.course_id -- grouping so that we can count the by course_id

-- Query 7: Calculate and display the average age of all students.
SELECT AVG(age)::NUMERIC(10,2) AS average_age from students

-- Query 8: Retrieve the names of students whose email addresses contain 'example.com'.
SELECT student_name FROM students
    WHERE email LIKE '%example.com';
