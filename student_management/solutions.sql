-- Listing all students
Select * from students;

-- Listing students with their enrolled courses
Select students.student_id, students.first_name, students.last_name, enrollments.course_id, courses.course_name from students 
JOIN enrollments on students.student_id = enrollments.student_id
JOIN courses on enrollments.course_id = courses.course_id

-- Listing all courses with instructor names
Select courses.course_name, CONCAT(instructors.first_name,' ',instructors.last_name) AS instructor_name 
from courses JOIN instructors on courses.instructor_id = instructors.instructor_id

--Counting students per course
Select courses.course_name, COUNT(*) AS student_quantity from enrollments
JOIN courses on enrollments.course_id = courses.course_id
GROUP BY courses.course_name

-- Finding courses with no students
Select courses.course_id, courses.course_name, enrollments.course_id from courses
LEFT JOIN enrollments on enrollments.course_id = courses.course_id WHERE enrollments.course_id IS NULL

-- Finding students with no enrollments
Select students.student_id, CONCAT(students.first_name,' ',students.last_name) AS student_name from students
LEFT JOIN enrollments on enrollments.student_id = students.student_id WHERE enrollments.student_id IS NULL

-- Finding students enrolled in more than one course
Select students.student_id, students.first_name, students.last_name, COUNT(*) AS enrolled_count from students 
JOIN enrollments on students.student_id = enrollments.student_id 
GROUP BY students.student_id
HAVING COUNT(*) > 1
ORDER BY students.student_id ASC

-- Counting active, completed, and dropped enrollments
Select status, COUNT(*) from enrollments GROUP BY status

-- Showing total expected revenue per course
Select courses.course_name,
courses.course_fee,
COUNT(*) AS enrollment_count,
SUM(course_fee) AS total_expected_revenue from enrollments
JOIN courses on enrollments.course_id = courses.course_id
where enrollments.status != 'dropped'
GROUP BY courses.course_name, courses.course_fee
Order BY total_expected_revenue DESC

-- Ranking courses by number of enrolled students
-- Dense ranked was used so it is ranked by number, not by position
Select 
DENSE_RANK()OVER (ORDER BY COUNT(*) DESC) AS course_rank,
courses.course_name,
COUNT(*) AS enrollment_count from enrollments
JOIN courses on enrollments.course_id = courses.course_id
GROUP BY courses.course_name, courses.course_fee

-- Finding the most popular course category
select 
DENSE_RANK()OVER (ORDER BY COUNT(*)DESC) AS category_rank,
courses.category, 
COUNT(*) AS category_count from courses
JOIN enrollments on courses.course_id = enrollments.course_id
GROUP BY courses.category

