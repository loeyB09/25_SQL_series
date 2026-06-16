# Library Database System — SQL Analysis (Day 2)

A practice project building and querying a relational library database in PostgreSQL.
The goal is to model a small library, then answer realistic operational and analytical
questions against it using SQL — from simple joins through to CTEs and aggregate-based
filtering.

## Project Overview

The project consists of two parts:

- **`schema.sql`** — defines four related tables, their keys, and a set of integrity
  constraints (foreign keys, checks, unique constraints) that keep the data honest.
- **`solutions.sql`** — fourteen queries that answer a progression of business
  questions, ordered roughly from beginner (single join) to intermediate
  (CTEs, anti-joins, date arithmetic).

## Business Problem

A library needs more than a list of books on a shelf. To run well it has to answer
day-to-day operational questions and longer-term strategic ones:

- *Operationally:* What's currently out on loan? What's overdue, and by how long? What
  can a member actually borrow today?
- *Strategically:* Which books and categories are in demand and deserve more copies?
  Which stock never moves? Which members are dormant and worth re-engaging? How is
  borrowing trending month over month?

This project turns those questions into SQL so the answers come from data, not guesswork.

## Database Tables

| Table | Purpose | Key columns |
|---|---|---|
| `authors` | One row per author | `author_id` (PK), `author_name` (unique) |
| `books` | One row per book title held by the library | `book_id` (PK), `author_id` (FK), `category`, `total_copies`, `available_copies` |
| `members` | One row per library member | `member_id` (PK), `email` (unique), `membership_date` |
| `borrow_records` | One row per borrowing event over time | `borrow_id` (PK), `member_id` (FK), `book_id` (FK), `borrow_date`, `due_date`, `return_date`, `status` |

The schema also enforces data quality at the database level rather than trusting the
application: published years must fall in a sensible range, `available_copies` can never
exceed `total_copies`, a return date can't precede the borrow date, and the `status`
field and `return_date` must stay logically consistent (a `returned` record must have a
return date; `borrowed`/`overdue` records must not).

## Entity Relationship Explanation

```
authors ──< books ──< borrow_records >── members
```

- **authors → books (one-to-many):** one author can write many books; each book has
  exactly one author (`books.author_id` references `authors.author_id`).
- **members → borrow_records (one-to-many):** one member can have many borrow events;
  each borrow event belongs to exactly one member.
- **books → borrow_records (one-to-many):** one book can be borrowed many times; each
  borrow event refers to exactly one book.

`borrow_records` is the **junction / fact table**. It resolves the many-to-many
relationship between `members` and `books` — a member can borrow many books and a book
can be borrowed by many members — and because it carries dates and status, it records
that relationship *over time* rather than as a static link.

## Business Questions

Full mapping of question → why it matters → SQL concept is in
[`business_questions.md`](./business_questions.md). In brief, the fourteen queries cover:

1. Books with author names
2. Members and membership dates
3. Currently borrowed books
4. Available books
5. Overdue books (with days overdue)
6. Full borrow history (member + title)
7. Active borrow count per member
8. Total lifetime loans per member
9. Members who never borrowed (re-engagement targets)
10. Books never borrowed (dead stock)
11. Most borrowed book(s) — tie-safe
12. Most popular category
13. Monthly borrow activity (trend)
14. Average borrow duration for returned books

## LinkedIn Reflection

> **Day 2 of my SQL series: a Library Database System 📚**
>
> Today I designed a PostgreSQL schema from scratch — four related tables (authors,
> books, members, and a borrow_records fact table) — and then wrote 14 queries to answer
> real library questions.
>
> What I focused on this time wasn't just *getting a result*, but making sure each query
> answered the actual business question behind it. A query can run perfectly and still
> answer the wrong thing — for example, "show available books" is `available_copies > 0`,
> not `total_copies > 0`, and a `WHERE` filter on a right-joined table can quietly undo
> the outer join you wrote it for. Catching those distinctions is where SQL stops being
> syntax and starts being analysis.
>
> Techniques I practised: anti-joins with `HAVING COUNT(...) = 0` to find dormant members
> and dead stock, a CTE with a scalar subquery to return the most-borrowed book in a
> tie-safe way, and `DATE_TRUNC` for monthly trend reporting.
>
>
> #SQL #DataAnalytics #PostgreSQL #LearningInPublic

