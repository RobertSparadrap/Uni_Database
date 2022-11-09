Queries in file tests.sql
1. Find all Students with their courses, its section and their professors
2. Find the number or students that each professors have
3. Find the average grade for each course that have each students
4. Find the overall average grade for each student
5. Show Students with all their assignment in all classes, if they didn?t had an assignment in a class, it shows ’null’ and show also the professor
6. Find the average grade for each section
7. Find the average grade for each Professor’s students
8. Show the Lecturer and the professor who gives the best grades (average)
9. Find the average grades for each major
10. Find the best student for each courses
11. Find how many activities do each students
12. Which activity did every students and how many times he did the same activity
13. Who graded each Assignment, which grade ? And who has been graded and for which course ?
14. Who graded the most Assignment
15. Find all courses with all their Prerequisites
16. Find all Knowledge that the student need to know to validate Prerequisite
17. How many Knowledge a student need to have to validate a Prerequisite
18. Show all International Students with all their knowledge
19. Show all International Students and all courses that they can take because they have the knowledge
20. Show How many students they are in each section and what is the max capacity of a section
21. Find all Researcher see all their publications
22. Count how many publication did each Researcher
23. Who published the most paper research ?
24. Which student have an Intern ? And in which position ?<br />
Function, Procedure and Triggers in file inserts.sql
1. Create a procedure where we can Put the International Students id and we’ll get courses that he/she can take
2. Createa function to see if there are still place for a student to be in one specific course/section, if the result is 1, it means TRUE, 0 means FALSE
3. Create a Trigger that can insert data inside Learner_has_Assignment after inserting on Assignment
4. Create a Trigger that can insert data inside Prerequisite after inserting on Course
5. Create a Trigger that can update the students gpa each time the grade of his assignment is upgraded
6. Create a Trigger that see the size of a class, this will define the size of the section, so if the class changes, the size of the section also will change
