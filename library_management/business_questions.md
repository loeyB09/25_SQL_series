# Business Questions — Library Database System (Day 2)

Each question below maps a comment from `solutions.sql` to the business reason it
matters and the SQL concept that answers it.

| # | Business question | Why it matters | SQL concept used |
|---|---|---|---|
| 1 | List all books with author names | Basic catalogue view — staff and members need a readable title-to-author mapping rather than raw `author_id` foreign keys. | `INNER JOIN` on `author_id` |
| 2 | Show all members and their membership dates | Membership tenure underpins loyalty analysis, renewal reminders, and segmenting long-standing vs. new members. | `CONCAT` for full name, `ORDER BY` on date |
| 3 | Show currently borrowed books | Operational snapshot of stock that is out — drives shelf availability and follow-up on open loans. | Three-table `JOIN`, `WHERE` with `OR` filter on status, `ORDER BY` |
| 4 | Show available books | Members need to know what they can actually borrow right now; protects against promising stock that is fully out on loan. | `WHERE` filter on copy count |
| 5 | Show overdue books with days overdue | Late returns block stock from circulating and may trigger fines/reminders; quantifying lateness prioritises chasing the worst offenders. | `CURRENT_DATE`, date subtraction for a computed `overdue_days` column |
| 6 | Show borrow history with member name and book title | A full audit trail of who borrowed what and when — the backbone of any behavioural or demand analysis. | Multi-table `JOIN` (note: `GROUP BY` here is not needed — see README notes) |
| 7 | Count how many books each member currently has borrowed | Identifies members at or near a borrowing limit and flags heavy active users. | `RIGHT JOIN`, `COUNT`, `GROUP BY`, status filter |
| 8 | Count total loans (borrowed + returned + overdue) per member | Lifetime engagement metric — distinguishes power users from dormant accounts for marketing and retention. | `RIGHT JOIN`, `COUNT`, `GROUP BY`, `ORDER BY` |
| 9 | Find members who have never borrowed any book | Surfaces dormant or at-risk members for re-engagement campaigns. | `RIGHT JOIN` + `HAVING COUNT(...) = 0` (anti-join pattern) |
| 10 | Find books that have never been borrowed | Highlights dead stock — candidates for promotion, relocation, or weeding from the collection. | `RIGHT JOIN` + `HAVING COUNT(...) = 0` (anti-join pattern) |
| 11 | Find the most borrowed book(s) | Demand signal for purchasing more copies; tie-safe so two equally popular titles both surface. | `WITH` (CTE) + scalar subquery filtering on `MAX` |
| 12 | Find the most popular book category | Guides acquisition budget toward the genres members actually read. | `JOIN`, `COUNT`, `GROUP BY`, `ORDER BY ... LIMIT 1` |
| 13 | Count monthly borrow activity | Reveals seasonality and growth trends in library usage for staffing and reporting. | `DATE_TRUNC('month', ...)`, cast to `date`, `COUNT(*)`, `GROUP BY` |
| 14 | Calculate average borrow duration for returned books | Benchmarks how long stock is typically out — informs realistic due-date policy. | `AVG`, `ROUND`, date subtraction, `WHERE return_date IS NOT NULL` |
