# Business Questions — Student Management System (Day 1)

Each question below maps a comment from `solutions.sql` to the business reason it
matters and the SQL concept that answers it.

| # | Business question | Why it matters | SQL concept used |
|---|---|---|---|
| 1 | List all students | The starting roster — a basic view of who is in the system before any analysis. | `SELECT *` |
| 2 | List students with their enrolled courses | Connects people to what they're studying — the core student-to-course view staff rely on. | Three-table `JOIN` across `students`, `enrollments`, `courses` |
| 3 | List all courses with instructor names | Readable catalogue mapping each course to its teacher instead of a raw `instructor_id`. | `JOIN`, `CONCAT` for full name |
| 4 | Count students per course | Class-size visibility — informs room allocation, demand, and which courses are thriving. | `JOIN`, `COUNT(*)`, `GROUP BY` |
| 5 | Find courses with no students | Surfaces under-subscribed courses that may need promotion or cancelling. | `LEFT JOIN` + `WHERE ... IS NULL` (anti-join) |
| 6 | Find students with no enrollments | Identifies registered-but-inactive students for follow-up. | `LEFT JOIN` + `WHERE ... IS NULL` (anti-join) |
| 7 | Find students enrolled in more than one course | Spots multi-course (engaged / high-value) students. | `JOIN`, `COUNT(*)`, `GROUP BY`, `HAVING` (see notes — should be `> 1`) |
| 8 | Count active, completed, and dropped enrollments | Headline health metric — completion vs. drop-off across the whole programme. | `COUNT(*)`, `GROUP BY status` |
| 9 | Show total expected revenue per course | Links enrolment to money — the financial view leadership cares about; excludes dropped students who won't pay. | `JOIN`, `COUNT`, `SUM`, `WHERE status != 'dropped'`, `GROUP BY`, `ORDER BY` |
| 10 | Rank courses by number of enrolled students | A ranked leaderboard of demand; dense rank so tied courses share a position with no gaps. | `DENSE_RANK() OVER (ORDER BY COUNT(*) DESC)` window function |
| 11 | Find the most popular course category | Guides where to invest teaching and marketing budget. | `DENSE_RANK()` window function over category counts |

