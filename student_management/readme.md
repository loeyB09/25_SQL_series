# Student Management System — SQL Analysis (Day 1)

A practice project building and querying a relational student management database in
PostgreSQL. The goal is to model a small training school, then answer realistic
operational and analytical questions against it using SQL — from simple joins through to
window functions and anti-joins.

## Project Overview

The project consists of two parts:

- **`schema.sql`** — defines four related tables, their keys, and a set of integrity
  constraints (foreign keys, checks, unique constraints) that keep the data honest.
- **`solutions.sql`** — a progression of queries answering business questions, ordered
  roughly from beginner (single select) to intermediate (window functions, anti-joins,
  conditional aggregation).

## Business Problem

A training school needs to understand both its operations and its commercials:

- *Operationally:* Who is enrolled in what? Which courses are full and which are empty?
  Which students signed up but never enrolled in anything? How are enrolments split
  across active, completed, and dropped?
- *Strategically:* Which courses and categories are most in demand? How much revenue is
  each course expected to bring in? Who are the engaged multi-course students?

This project turns those questions into SQL so the answers come from data, not guesswork.

## Database Tables

| Table | Purpose | Key columns |
|---|---|---|
| `students` | One row per student | `student_id` (PK), `email` (unique), `city`, `date_of_birth`, `gender` |
| `instructors` | One row per instructor | `instructor_id` (PK), `email` (unique), `expertise` |
| `courses` | One row per course offered | `course_id` (PK), `course_name` (unique), `category`, `instructor_id` (FK), `course_fee`, `start_date`, `end_date` |
| `enrollments` | One row per student-course enrolment (bridge table) | `enrollment_id` (PK), `student_id` (FK), `course_id` (FK), `enrollment_date`, `status` |

The schema enforces data quality at the database level: course fees can't be negative, a
course's end date can't precede its start date, `gender` and `status` are restricted to
valid values, and a student can't be enrolled in the same course twice
(`UNIQUE (student_id, course_id)`).

## Entity Relationship Explanation

```
instructors ──< courses ──< enrollments >── students
```

- **instructors → courses (one-to-many):** one instructor can teach many courses; each
  course has exactly one instructor (`courses.instructor_id` references
  `instructors.instructor_id`).
- **students → enrollments (one-to-many):** one student can have many enrolments; each
  enrolment belongs to exactly one student.
- **courses → enrollments (one-to-many):** one course can have many enrolments; each
  enrolment refers to exactly one course.

`enrollments` is the **junction / bridge table**. It resolves the many-to-many
relationship between `students` and `courses` — one student can take many courses and one
course can have many students — and because it carries `enrollment_date` and `status`, it
records the state of each enrolment rather than just a static link.

## Business Questions

Full mapping of question → why it matters → SQL concept is in
[`business_questions.md`](./business_questions.md). In brief, the queries cover:

1. All students
2. Students with their enrolled courses
3. Courses with instructor names
4. Student count per course
5. Courses with no students (anti-join)
6. Students with no enrollments (anti-join)
7. Students enrolled in more than one course
8. Enrollment status breakdown (active / completed / dropped)
9. Expected revenue per course
10. Courses ranked by enrolment (dense rank)
11. Most popular course category


## LinkedIn Reflection

> **Day 1 of my SQL series: a Student Management System 🎓**
>
> I kicked off a daily SQL series by designing a PostgreSQL schema from scratch — four
> related tables (students, instructors, courses, and an enrollments bridge table) — then
> writing queries to answer real questions a training school would ask.
>
> The lesson that stuck: a query running cleanly isn't the same as a query answering the
> question. "Students in more than one course" is `COUNT(*) > 1`, not `= 2` — get that
> wrong and you silently miss your most engaged students. "Most popular category" needs a
> filter on the rank, or you just hand back every category sorted. Catching that gap is
> where SQL stops being syntax and starts being analysis.
>
> Techniques I practised: anti-joins (`LEFT JOIN ... WHERE IS NULL`) to find empty
> courses and inactive students, conditional revenue aggregation that excludes dropped
> enrolments, and `DENSE_RANK()` window functions to build demand leaderboards.
>
> #SQL #DataAnalytics #PostgreSQL #LearningInPublic
