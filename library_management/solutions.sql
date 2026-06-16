-- List all books with author names
Select books.title, authors.author_name from books
JOIN authors on books.author_id = authors.author_id

-- Show all members and their membership dates
Select
	member_id, 
	CONCAT(first_name,' ', last_name) AS full_name, 
	membership_date 
from members
ORDER BY membership_date

-- Show current borrowed books
select 
	borrow_records.borrow_id, 
	books.title, 
	CONCAT(first_name,' ', last_name) AS member_name,
	borrow_records.borrow_date,
	borrow_records.due_date,
	borrow_records.status
from borrow_records
JOIN books ON borrow_records.book_id = books.book_id
JOIN members ON borrow_records.member_id = members.member_id
where status = 'borrowed' OR status = 'overdue'
ORDER BY status

-- Show available books
select 
	book_id,
	title,
	total_copies
from books 
where available_copies > 0

-- Show overdue books (current date: 11th june 2026)
select
	members.member_id,
	CONCAT(first_name,' ', last_name) AS member_name,
	borrow_records.book_id,
	books.title,
	borrow_records.borrow_date,
	borrow_records.due_date,
	CURRENT_DATE as today_date,
	CURRENT_DATE - borrow_records.due_date AS overdue_date
from borrow_records
JOIN members ON borrow_records.member_id = members.member_id
JOIN books ON borrow_records.book_id = books.book_id
where status = 'overdue' OR return_date IS NULL

-- Show borrow history with member name and book title
select
	CONCAT(first_name,' ', last_name) AS member_name,
	books.title, 
	borrow_records.borrow_date,
	borrow_records.status
from borrow_records
JOIN members ON borrow_records.member_id = members.member_id
JOIN books ON borrow_records.book_id = books.book_id
GROUP BY member_name, books.title, borrow_records.borrow_date, borrow_records.status
ORDER BY member_name

-- Count how many books each member has borrowed
select 
	CONCAT(first_name,' ', last_name) AS member_name,
	COUNT (borrow_records.member_id) AS borrowed_count
from borrow_records
RIGHT JOIN members on borrow_records.member_id = members.member_id
WHERE borrow_records.status = 'borrowed'
GROUP BY member_name
ORDER BY borrowed_count ASC

-- Count total books each member has borrowed/completed/overdued
select 
	CONCAT(first_name,' ', last_name) AS member_name,
	COUNT (borrow_records.member_id) AS borrowed_count
from borrow_records
RIGHT JOIN members on borrow_records.member_id = members.member_id
GROUP BY member_name
ORDER BY borrowed_count DESC

-- Find members who have not borrowed any books.
Select
	CONCAT(first_name,' ', last_name) AS member_name,
	COUNT (borrow_records.member_id) AS borrowed_count
from borrow_records
RIGHT JOIN members on borrow_records.member_id = members.member_id
GROUP BY member_name
HAVING COUNT(borrow_records.member_id) = 0

-- Find books that have never been borrowed
Select
	books.title,
	COUNT (borrow_records.book_id) AS borrowed_count
from borrow_records
RIGHT JOIN books on borrow_records.book_id = books.book_id
GROUP BY books.title
HAVING COUNT (borrow_records.book_id) = 0

-- Find the most borrowed books
WITH cte AS (
Select
	books.title,
	COUNT (borrow_records.book_id) AS borrowed_count
from borrow_records
RIGHT JOIN books on borrow_records.book_id = books.book_id
GROUP BY books.title
ORDER BY borrowed_count DESC
)
Select
	cte.title,
	cte.borrowed_count
from cte
where borrowed_count = (SELECT Max(borrowed_count) from cte)

-- Find the most popular book categories.	
Select
	books.category,
	COUNT (borrow_records.borrow_id) AS borrowed_count
from books
JOIN borrow_records ON books.book_id = borrow_records.book_id
GROUP BY books.category
ORDER BY borrowed_count DESC
LIMIT 1

-- Count monthly borrow activity
Select
	DATE_TRUNC('month',borrow_date)::date AS borrow_month,
	COUNT(*) AS borrowed_count
from borrow_records
GROUP BY borrow_month
ORDER BY borrow_month 

-- Calculate average borrow duration for returned books
Select
	ROUND(AVG(return_date - borrow_date),2) AS average_borrow_duration
from borrow_records
where return_date IS NOT NULL

