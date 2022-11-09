Use CollegeDepartmentDB;

           
-- 1 ----------------------------------------------------------------------

-- Find Students with their Courses and Professors


SELECT stu.name AS Student, c.name AS Course, s.number AS Section, e.name AS Professor
FROM Learner stu
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = stu.learner_id
JOIN Course c ON l_c.Course_course_id = c.course_id
JOIN Course_has_Section c_s ON c.course_id = c_s.Course_course_id 
JOIN Section s ON s.section_id = c_s.Section_section_id
AND s.number = l_c.section
JOIN Teacher t ON t.teacher_id = s.Teacher_teacher_id
JOIN FacultyMember fm ON t.facultyMember_id = fm.facultyMember_id
JOIN Employee e ON fm.employee_id = e.employee_id
;

/*
| Student          | Course               | Section | Professor     |
| ---------------- | -------------------- | ------- | ------------- |
| Robert Harakaly  | Modern Physics       | 4       | Charli Sasaki |
| Robert Harakaly  | Discrete Math        | 4       | Jose Ortiz    |
| Robert Harakaly  | Data Analysis        | 0       | Norman Lee    |
| Robert Harakaly  | Database             | 1       | Jose Ortiz    |
| Hugo Suzanne     | Mobile Application   | 3       | Nina          |
| Hugo Suzanne     | Database             | 20      | Nina          |
| Hugo Suzanne     | DevOps               | 5       | Louis         |
| Hugo Suzanne     | Marketing Analytics  | 1       | Valerie Randu |
| Radka Popovicova | Marketing Analytics  | 1       | Valerie Randu |
| Radka Popovicova | Finance              | 0       | Alice         |
| Radka Popovicova | Sales Training       | 0       | John          |
| Radka Popovicova | Accounting           | 0       | Alice         |
| Alex San         | Database             | 1       | Jose Ortiz    |
| Alex San         | DevOps               | 5       | Louis         |
| Alex San         | Web Application      | 8       | Louis         |
| Alex San         | Software Engineering | 2       | Jose Ortiz    |
| Clement Berard   | DevOps               | 5       | Louis         |
| Clement Berard   | Mobile Application   | 6       | Lola          |
| Clement Berard   | Digital Marketing    | 7       | Lola          |
| Clement Berard   | Software Engineering | 2       | Jose Ortiz    |
| Luca Suter       | Mechanics            | 5       | Baumberger    |
| Luca Suter       | Electrodynamics      | 6       | Lacobucci     |
| Luca Suter       | Analysis             | 7       | Valerie Randu |
| Luca Suter       | Algebra              | 2       | Valerie Randu |
*/


-- ------------------------------------------------------------------------



-- 2 ----------------------------------------------------------------------

-- Find the number of students for each teachers


SELECT DISTINCT e.name AS Professor , COUNT(DISTINCT stu.name) AS Student
FROM Learner stu
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = stu.learner_id
JOIN Course c ON l_c.Course_course_id = c.course_id
JOIN Course_has_Section c_s ON c.course_id = c_s.Course_course_id 
JOIN Section s ON s.section_id = c_s.Section_section_id
AND s.number = l_c.section
JOIN Teacher t ON t.teacher_id = s.Teacher_teacher_id
JOIN FacultyMember fm ON t.facultyMember_id = fm.facultyMember_id
JOIN Employee e ON fm.employee_id = e.employee_id
GROUP BY Professor
ORDER BY Student DESC
;
/*
| Professor     | Student |
| ------------- | ------- |
| Jose Ortiz    | 3       |
| Valerie Randu | 3       |
| Louis         | 3       |
| Charli Sasaki | 1       |
| Norman Lee    | 1       |
| Lola          | 1       |
| Baumberger    | 1       |
| Nina          | 1       |
| John          | 1       |
| Lacobucci     | 1       |
| Alice         | 1       |
*/
-- ------------------------------------------------------------------------


-- 3 ----------------------------------------------------------------------

-- Find the Average grade for each student for each course


SELECT s.name AS Student, c.name AS Course, AVG(a.grade) AS Grade
FROM Learner s
JOIN Learner_has_Assignment l_a ON s.learner_id = l_a.Learner_learner_id
JOIN Assignment a ON a.assignment_id = l_a.Assignment_assignment_id
JOIN Course_has_Assignment c_a ON a.assignment_id = c_a.Assignment_assignment_id
JOIN Course c ON c_a.Course_course_id = c.course_id
GROUP BY s.name, Course
;
/*
| Student          | Course               | Grade    |
| ---------------- | -------------------- | -------- |
| Alex San         | Database             | 80.0000  |
| Alex San         | Software Engineering | 85.0000  |
| Clement Berard   | DevOps               | 69.0000  |
| Clement Berard   | Software Engineering | 70.0000  |
| Luca Suter       | Analysis             | 73.0000  |
| Luca Suter       | Electrodynamics      | 82.5000  |
| Luca Suter       | Mechanics            | 87.0000  |
| Radka Popovicova | Accounting           | 98.0000  |
| Radka Popovicova | Finance              | 96.5000  |
| Radka Popovicova | Marketing Analytics  | 90.0000  |
| Radka Popovicova | Sales Training       | 95.0000  |
| Robert Harakaly  | Data Analysis        | 100.0000 |
| Robert Harakaly  | Database             | 96.0000  |
| Robert Harakaly  | Discrete Math        | 92.5000  |
| Robert Harakaly  | Modern Physics       | 94.4000  |
*/
-- ------------------------------------------------------------------------


-- 4 ----------------------------------------------------------------------

-- Find the Average grade for each student


SELECT s.name AS Student, AVG(ALL a.grade) AS Grade
FROM Learner s
JOIN Learner_has_Assignment l_a ON s.learner_id = l_a.Learner_learner_id
JOIN Assignment a ON a.assignment_id = l_a.Assignment_assignment_id
JOIN Course_has_Assignment c_a ON a.assignment_id = c_a.Assignment_assignment_id
JOIN Course c ON c_a.Course_course_id = c.course_id
GROUP BY s.name
;
/*
| Student          | Grade   |
| ---------------- | ------- |
| Alex San         | 82.5000 |
| Clement Berard   | 69.5000 |
| Luca Suter       | 81.2500 |
| Radka Popovicova | 94.3333 |
| Robert Harakaly  | 94.0769 |
*/
-- ------------------------------------------------------------------------



-- 5 ----------------------------------------------------------------------

-- Show Students with all their assignment in all classes, if they didn’t had an assignment in a class, it shows 'null' and show also the professor

SELECT DISTINCT result.*, result2.Grade, result2.Assignment, result3.Professor
FROM (SELECT DISTINCT stu.name AS Student, c.name AS Course, c.course_id AS id, l_c.section AS Section
	FROM Learner stu
	JOIN Learner_has_Course l_c ON stu.learner_id = l_c.Learner_learner_id
	JOIN Course c ON l_c.Course_course_id = c.course_id)
AS result
LEFT JOIN (SELECT DISTINCT stu.name AS Student, c.name AS Course, a.grade AS Grade, a.number AS Assignment, c.course_id AS id, l_c.section AS Section
	FROM Learner stu
	JOIN Learner_has_Course l_c ON stu.learner_id = l_c.Learner_learner_id
	JOIN Course c ON l_c.Course_course_id = c.course_id
	LEFT JOIN Learner_has_Assignment l_a ON stu.learner_id = l_a.Learner_learner_id
	LEFT JOIN Assignment a ON a.assignment_id = l_a.Assignment_assignment_id
	JOIN Course_has_Assignment c_a ON c_a.Assignment_assignment_id = a.assignment_id AND c_a.Course_course_id = c.course_id)
AS result2 ON result.Course = result2.Course
AND result.Student = result2.Student
JOIN (SELECT DISTINCT s.number AS Section, e.name AS Professor, c.course_id AS id
    FROM Employee e
	JOIN FacultyMember fm ON e.employee_id = fm.employee_id
	JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
	RIGHT JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
	RIGHT JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
	JOIN Course c ON c_s.Course_course_id = c.course_id
) AS result3 ON result.id = result3.id AND result.Section = result3.Section
;
/*
| Student          | Course               | id  | Section | Grade | Assignment | Professor     |
| ---------------- | -------------------- | --- | ------- | ----- | ---------- | ------------- |
| Luca Suter       | Mechanics            | 1   | 5       | 87    | 1          | Baumberger    |
| Luca Suter       | Electrodynamics      | 3   | 6       | 80    | 1          | Lacobucci     |
| Luca Suter       | Electrodynamics      | 3   | 6       | 85    | 2          | Lacobucci     |
| Luca Suter       | Analysis             | 4   | 7       | 73    | 1          | Valerie Randu |
| Luca Suter       | Algebra              | 5   | 2       |       |            | Valerie Randu |
| Robert Harakaly  | Discrete Math        | 7   | 4       | 94    | 1          | Jose Ortiz    |
| Robert Harakaly  | Discrete Math        | 7   | 4       | 100   | 2          | Jose Ortiz    |
| Robert Harakaly  | Discrete Math        | 7   | 4       | 91    | 3          | Jose Ortiz    |
| Robert Harakaly  | Discrete Math        | 7   | 4       | 90    | 4          | Jose Ortiz    |
| Robert Harakaly  | Discrete Math        | 7   | 4       | 80    | 5          | Jose Ortiz    |
| Robert Harakaly  | Discrete Math        | 7   | 4       | 100   | 6          | Jose Ortiz    |
| Robert Harakaly  | Data Analysis        | 8   | 0       | 100   | 1          | Norman Lee    |
| Hugo Suzanne     | Mobile Application   | 10  | 3       |       |            | Nina          |
| Clement Berard   | Mobile Application   | 10  | 6       |       |            | Lola          |
| Alex San         | Web Application      | 12  | 8       |       |            | Louis         |
| Hugo Suzanne     | DevOps               | 13  | 5       |       |            | Louis         |
| Alex San         | DevOps               | 13  | 5       |       |            | Louis         |
| Clement Berard   | DevOps               | 13  | 5       | 69    | 1          | Louis         |
| Robert Harakaly  | Database             | 14  | 1       | 96    | 1          | Jose Ortiz    |
| Hugo Suzanne     | Database             | 14  | 20      |       |            | Nina          |
| Alex San         | Database             | 14  | 1       | 80    | 1          | Jose Ortiz    |
| Hugo Suzanne     | Marketing Analytics  | 17  | 1       |       |            | Valerie Randu |
| Radka Popovicova | Marketing Analytics  | 17  | 1       | 91    | 1          | Valerie Randu |
| Radka Popovicova | Marketing Analytics  | 17  | 1       | 89    | 2          | Valerie Randu |
| Radka Popovicova | Finance              | 18  | 0       | 98    | 1          | Alice         |
| Radka Popovicova | Finance              | 18  | 0       | 95    | 1          | Alice         |
| Radka Popovicova | Accounting           | 19  | 0       | 98    | 1          | Alice         |
| Radka Popovicova | Sales Training       | 20  | 0       | 95    | 1          | John          |
| Clement Berard   | Digital Marketing    | 21  | 7       |       |            | Lola          |
| Robert Harakaly  | Modern Physics       | 26  | 4       | 100   | 5          | Charli Sasaki |
| Robert Harakaly  | Modern Physics       | 26  | 4       | 95    | 1          | Charli Sasaki |
| Robert Harakaly  | Modern Physics       | 26  | 4       | 97    | 2          | Charli Sasaki |
| Robert Harakaly  | Modern Physics       | 26  | 4       | 93    | 3          | Charli Sasaki |
| Robert Harakaly  | Modern Physics       | 26  | 4       | 87    | 4          | Charli Sasaki |
| Alex San         | Software Engineering | 27  | 2       | 85    | 1          | Jose Ortiz    |
| Clement Berard   | Software Engineering | 27  | 2       | 70    | 1          | Jose Ortiz    |
*/
-- ------------------------------------------------------------------------



-- 6 ----------------------------------------------------------------------

-- Average grade for each section

SELECT c.name AS Course, AVG(a.grade) AS Grade, e.name AS Professor
FROM Employee e
JOIN FacultyMember fm ON e.employee_id = fm.employee_id
JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
JOIN Course c ON c_s.Course_course_id = c.course_id
JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
WHERE l_c.section = s.number
GROUP BY Course, Professor
;
/*
| Course               | Grade    | Professor     |
| -------------------- | -------- | ------------- |
| Accounting           | 98.0000  | Alice         |
| Analysis             | 73.0000  | Valerie Randu |
| Data Analysis        | 100.0000 | Norman Lee    |
| Database             | 88.0000  | Jose Ortiz    |
| DevOps               | 69.0000  | Louis         |
| Discrete Math        | 92.5000  | Jose Ortiz    |
| Electrodynamics      | 82.5000  | Lacobucci     |
| Finance              | 96.5000  | Alice         |
| Marketing Analytics  | 90.0000  | Valerie Randu |
| Mechanics            | 87.0000  | Baumberger    |
| Modern Physics       | 94.4000  | Charli Sasaki |
| Sales Training       | 95.0000  | John          |
| Software Engineering | 77.5000  | Jose Ortiz    |
*/
-- ------------------------------------------------------------------------




-- 7 ----------------------------------------------------------------------

-- Average grade for each Professor

SELECT AVG(ALL a.grade) AS Grade, e.name AS Professor
FROM Employee e
JOIN FacultyMember fm ON e.employee_id = fm.employee_id
JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
JOIN Course c ON c_s.Course_course_id = c.course_id
JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
WHERE l_c.section = s.number
GROUP BY Professor
;
/*
| Grade    | Professor     |
| -------- | ------------- |
| 97.0000  | Alice         |
| 87.0000  | Baumberger    |
| 94.4000  | Charli Sasaki |
| 95.0000  | John          |
| 88.6000  | Jose Ortiz    |
| 82.5000  | Lacobucci     |
| 69.0000  | Louis         |
| 100.0000 | Norman Lee    |
| 84.3333  | Valerie Randu |
*/
-- ------------------------------------------------------------------------




-- 8 ----------------------------------------------------------------------

-- Average grade for each Professor

SELECT AVG(ALL a.grade) AS Grade, e.name AS Professor
FROM Employee e
JOIN FacultyMember fm ON e.employee_id = fm.employee_id
JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
JOIN Course c ON c_s.Course_course_id = c.course_id
JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
JOIN Lecturer lec ON lec.teacher_id = t.teacher_id
WHERE l_c.section = s.number
GROUP BY Professor
UNION
SELECT AVG(ALL a.grade) AS Grade, e.name AS Professor
FROM Employee e
JOIN FacultyMember fm ON e.employee_id = fm.employee_id
JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
JOIN Course c ON c_s.Course_course_id = c.course_id
JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
JOIN Professor prof ON prof.teacher_id = t.teacher_id
WHERE l_c.section = s.number
GROUP BY Professor
ORDER BY Grade DESC
;
/*
| Grade    | Professor     |
| -------- | ------------- |
| 100.0000 | Norman Lee    |
| 97.0000  | Alice         |
| 95.0000  | John          |
| 94.4000  | Charli Sasaki |
| 88.6000  | Jose Ortiz    |
| 87.0000  | Baumberger    |
| 84.3333  | Valerie Randu |
| 82.5000  | Lacobucci     |
| 69.0000  | Louis         |
*/
-- ------------------------------------------------------------------------


-- 9 ---------------------------------------------------------------------

-- The Best Lecturer and Professor

SELECT result.Professor, result.Grade, "Lecturer" AS Type
FROM (
	SELECT AVG(a.grade) AS Grade, e.name AS Professor
	FROM Employee e
	JOIN FacultyMember fm ON e.employee_id = fm.employee_id
	JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
	JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
	JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
	JOIN Course c ON c_s.Course_course_id = c.course_id
	JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
	JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
	JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
	JOIN Lecturer lec ON lec.teacher_id = t.teacher_id
	WHERE l_c.section = s.number
    GROUP BY Professor
) AS result
WHERE result.Grade = (
	SELECT MAX(result.Grade)
	FROM (
	SELECT AVG(a.grade) AS Grade, e.name AS Professor
	FROM Employee e
	JOIN FacultyMember fm ON e.employee_id = fm.employee_id
	JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
	JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
	JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
	JOIN Course c ON c_s.Course_course_id = c.course_id
	JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
	JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
	JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
	JOIN Lecturer lec ON lec.teacher_id = t.teacher_id
	WHERE l_c.section = s.number
    GROUP BY Professor
) AS result
)
UNION
SELECT result.Professor, result.Grade, "Professor" AS Type
FROM (
	SELECT AVG(a.grade) AS Grade, e.name AS Professor
	FROM Employee e
	JOIN FacultyMember fm ON e.employee_id = fm.employee_id
	JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
	JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
	JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
	JOIN Course c ON c_s.Course_course_id = c.course_id
	JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
	JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
	JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
	JOIN Professor prof ON prof.teacher_id = t.teacher_id
	WHERE l_c.section = s.number
    GROUP BY Professor
) AS result
WHERE result.Grade = (
	SELECT MAX(result.Grade)
	FROM (
	SELECT AVG(a.grade) AS Grade, e.name AS Professor
	FROM Employee e
	JOIN FacultyMember fm ON e.employee_id = fm.employee_id
	JOIN Teacher t ON t.facultyMember_id = fm.facultyMember_id
	JOIN Section s ON s.Teacher_teacher_id = t.teacher_id
	JOIN Course_has_Section c_s ON c_s.Section_section_id = s.section_id
	JOIN Course c ON c_s.Course_course_id = c.course_id
	JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
	JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
	JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
	JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id AND l_c.Course_course_id = c.course_id
	JOIN Professor prof ON prof.teacher_id = t.teacher_id
	WHERE l_c.section = s.number
    GROUP BY Professor
) AS result
)
;
/*
| Professor  | Grade    | Type      |
| ---------- | -------- | --------- |
| Norman Lee | 100.0000 | Lecturer  |
| Alice      | 97.0000  | Professor |
*/
-- ------------------------------------------------------------------------


-- 10 ---------------------------------------------------------------------

-- Average grade for each Major

SELECT AVG(a.grade) AS Grade, l.major AS Major
FROM Course c
JOIN Course_has_Assignment c_a ON c_a.Course_course_id = c.course_id
JOIN Assignment a ON c_a.Assignment_assignment_id = a.assignment_id
JOIN Learner_has_Assignment l_a ON l_a.Assignment_assignment_id = a.assignment_id
JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
GROUP BY Major
;
/*
| Grade   | Major            |
| ------- | ---------------- |
| 94.3333 | Business         |
| 89.8235 | Computer Science |
| 81.2500 | Physics          |
*/
-- ------------------------------------------------------------------------


-- 11 ---------------------------------------------------------------------

-- Best Student for each class

SELECT result.Student AS Student, result.Course AS Course, result.Grade AS Grade
FROM (
	SELECT s.name AS Student, c.name AS Course, AVG(a.grade) AS Grade
	FROM Learner s
	JOIN Learner_has_Assignment l_a ON s.learner_id = l_a.Learner_learner_id
	JOIN Assignment a ON a.assignment_id = l_a.Assignment_assignment_id
	JOIN Course_has_Assignment c_a ON a.assignment_id = c_a.Assignment_assignment_id
	JOIN Course c ON c_a.Course_course_id = c.course_id
	GROUP BY s.name, Course
) AS result
WHERE result.Grade IN (
	SELECT MAX(result.Grade) AS Grade
	FROM (
		SELECT s.name AS Student, c.name AS Course, AVG(a.grade) AS Grade
		FROM Learner s
		JOIN Learner_has_Assignment l_a ON s.learner_id = l_a.Learner_learner_id
		JOIN Assignment a ON a.assignment_id = l_a.Assignment_assignment_id
		JOIN Course_has_Assignment c_a ON a.assignment_id = c_a.Assignment_assignment_id
		JOIN Course c ON c_a.Course_course_id = c.course_id
		GROUP BY s.name, c.name
	) AS result
	GROUP BY result.Course
)
;
/*
| Student          | Course               | Grade    |
| ---------------- | -------------------- | -------- |
| Alex San         | Software Engineering | 85.0000  |
| Clement Berard   | DevOps               | 69.0000  |
| Luca Suter       | Analysis             | 73.0000  |
| Luca Suter       | Electrodynamics      | 82.5000  |
| Luca Suter       | Mechanics            | 87.0000  |
| Radka Popovicova | Accounting           | 98.0000  |
| Radka Popovicova | Finance              | 96.5000  |
| Radka Popovicova | Marketing Analytics  | 90.0000  |
| Radka Popovicova | Sales Training       | 95.0000  |
| Robert Harakaly  | Data Analysis        | 100.0000 |
| Robert Harakaly  | Database             | 96.0000  |
| Robert Harakaly  | Discrete Math        | 92.5000  |
| Robert Harakaly  | Modern Physics       | 94.4000  |
*/
-- ------------------------------------------------------------------------



-- 12 ---------------------------------------------------------------------

-- How many activities do each students

SELECT l.name AS Student, COUNT(act.name) AS "# of activities"
FROM Learner l
LEFT JOIN participate p ON p.Learner_learner_id = learner_id
LEFT JOIN Activity act ON p.Activity_activity = activity
GROUP BY Student
;
/*
| Student          | # of activities |
| ---------------- | --------------- |
| Alex San         | 0               |
| Alexis Jeronimo  | 0               |
| Ali Baba         | 0               |
| Arjun Kumar      | 0               |
| Clement Berard   | 0               |
| Daniel Harakaly  | 0               |
| Gianluca Zanin   | 0               |
| Hugo Suzanne     | 0               |
| Luca Suter       | 0               |
| Mika idk         | 0               |
| Noam Toumi       | 0               |
| Radka Popovicova | 1               |
| Robert Harakaly  | 3               |
| Thibault Randu   | 0               |
| Zuzka Hadvabova  | 0               |
*/
-- ------------------------------------------------------------------------


-- 13 ---------------------------------------------------------------------

-- Which activity did every students and how many times he did the same activity

SELECT l.name AS Student, act.name AS Activity, COUNT(act.name) AS "How many time"
FROM Learner l
LEFT JOIN participate p ON p.Learner_learner_id = learner_id
LEFT JOIN Activity act ON p.Activity_activity = activity
GROUP BY Student, act.name
;
/*
| Student          | Activity   | How many time |
| ---------------- | ---------- | ------------- |
| Alex San         |            | 0             |
| Alexis Jeronimo  |            | 0             |
| Ali Baba         |            | 0             |
| Arjun Kumar      |            | 0             |
| Clement Berard   |            | 0             |
| Daniel Harakaly  |            | 0             |
| Gianluca Zanin   |            | 0             |
| Hugo Suzanne     |            | 0             |
| Luca Suter       |            | 0             |
| Mika idk         |            | 0             |
| Noam Toumi       |            | 0             |
| Radka Popovicova | Gator Fest | 1             |
| Robert Harakaly  | Gator Fest | 1             |
| Robert Harakaly  | Soccer     | 2             |
| Thibault Randu   |            | 0             |
| Zuzka Hadvabova  |            | 0             |
*/
-- ------------------------------------------------------------------------

-- 14 ---------------------------------------------------------------------

-- Who graded each Assignment, which grade ? And who has been graded and for which course ?

SELECT grader.Grader, c.name AS Course, grader.Assignment AS Assignment, grader.Grade AS "Grade Given", l.name AS "Student Graded"
FROM (
	SELECT l.name AS Grader, a.assignment_id AS Assignment, a.grade AS Grade
	FROM Learner l
	JOIN Student s ON l.learner_id = s.learner_id
	JOIN Grader g ON g.Student_student_id = s.student_id
	JOIN Grades grades ON grades.Grader_grader_id = g.grader_id
	JOIN Assignment a ON a.assignment_id = grades.Assignment_assignment_id
) AS grader
JOIN Learner_has_Assignment l_a ON grader.Assignment = l_a.Assignment_assignment_id
JOIN Learner l ON l.learner_id = l_a.Learner_learner_id
JOIN Course_has_Assignment c_a ON c_a.Assignment_assignment_id = grader.Assignment
JOIN Course c ON c.course_id = c_a.Course_course_id
;
/*
| Grader          | Assignment | Grade Given | Course               | Student Graded   |
| --------------- | ---------- | ----------- | -------------------- | ---------------- |
| Luca Suter      | 22         | 87          | Mechanics            | Luca Suter       |
| Arjun Kumar     | 20         | 80          | Electrodynamics      | Luca Suter       |
| Arjun Kumar     | 21         | 85          | Electrodynamics      | Luca Suter       |
| Arjun Kumar     | 23         | 73          | Analysis             | Luca Suter       |
| Arjun Kumar     | 7          | 94          | Discrete Math        | Robert Harakaly  |
| Luca Suter      | 8          | 100         | Discrete Math        | Robert Harakaly  |
| Luca Suter      | 9          | 91          | Discrete Math        | Robert Harakaly  |
| Luca Suter      | 10         | 90          | Discrete Math        | Robert Harakaly  |
| Luca Suter      | 11         | 80          | Discrete Math        | Robert Harakaly  |
| Zuzka Hadvabova | 12         | 100         | Discrete Math        | Robert Harakaly  |
| Zuzka Hadvabova | 13         | 100         | Data Analysis        | Robert Harakaly  |
| Arjun Kumar     | 27         | 69          | DevOps               | Clement Berard   |
| Arjun Kumar     | 6          | 96          | Database             | Robert Harakaly  |
| Arjun Kumar     | 24         | 80          | Database             | Alex San         |
| Zuzka Hadvabova | 16         | 91          | Marketing Analytics  | Radka Popovicova |
| Alex San        | 17         | 89          | Marketing Analytics  | Radka Popovicova |
| Zuzka Hadvabova | 14         | 98          | Finance              | Radka Popovicova |
| Zuzka Hadvabova | 15         | 95          | Finance              | Radka Popovicova |
| Arjun Kumar     | 19         | 98          | Accounting           | Radka Popovicova |
| Alex San        | 18         | 95          | Sales Training       | Radka Popovicova |
| Arjun Kumar     | 1          | 95          | Modern Physics       | Robert Harakaly  |
| Arjun Kumar     | 2          | 97          | Modern Physics       | Robert Harakaly  |
| Arjun Kumar     | 3          | 93          | Modern Physics       | Robert Harakaly  |
| Arjun Kumar     | 4          | 87          | Modern Physics       | Robert Harakaly  |
| Arjun Kumar     | 5          | 100         | Modern Physics       | Robert Harakaly  |
| Zuzka Hadvabova | 25         | 85          | Software Engineering | Alex San         |
| Arjun Kumar     | 26         | 70          | Software Engineering | Clement Berard   |
*/
-- ------------------------------------------------------------------------

-- 15 ---------------------------------------------------------------------

-- Who graded the most Assignment

SELECT grader.Grader, COUNT(*) AS Quantity, AVG(grader.Grade) AS "Average of grades"
FROM (
	SELECT l.name AS Grader, a.assignment_id AS Assignment, a.grade AS Grade
	FROM Learner l
	JOIN Student s ON l.learner_id = s.learner_id
	JOIN Grader g ON g.Student_student_id = s.student_id
	JOIN Grades grades ON grades.Grader_grader_id = g.grader_id
	JOIN Assignment a ON a.assignment_id = grades.Assignment_assignment_id
) AS grader
GROUP BY grader.Grader
ORDER BY Quantity DESC
LIMIT 1
;
/*
| Grader      | Quantity | Average of grades |
| ----------- | -------- | ----------------- |
| Arjun Kumar | 14       | 86.9286           |
*/
-- ------------------------------------------------------------------------


-- 16 ---------------------------------------------------------------------

-- Courses with all their Prerequisites 

SELECT c.name AS Course, p.name AS Prerequisite
FROM Course c
LEFT JOIN Course_has_Prerequisite c_p ON c_p.Course_course_id = c.course_id
LEFT JOIN Prerequisite p ON c_p.Prerequisite_prerequisite_id = p.prerequisite_id
;
/*
| Course                             | Prerequisite                       |
| ---------------------------------- | ---------------------------------- |
| Quantum Mechanics                  | Mechanics                          |
| Modern Physics                     | Mechanics                          |
| Thermodynamics                     | Electrodynamics                    |
| Geometry                           | Analysis                           |
| Geometry                           | Algebra                            |
| Machine Learinig                   | Algebra                            |
| Complex Algebra                    | Algebra                            |
| Marketing Analytics                | Algebra                            |
| Modern Physics                     | Algebra                            |
| Machine Learinig                   | Data Analysis                      |
| Software Engineering               | Mobile Application                 |
| Software Engineering               | Web Application                    |
| Earthquake Engineering             | Mechanical and Vibration Structure |
| Quantum Mechanics                  | Modern Physics                     |
| Mechanics                          |                                    |
| Electrodynamics                    |                                    |
| Analysis                           |                                    |
| Algebra                            |                                    |
| Discrete Math                      |                                    |
| Data Analysis                      |                                    |
| Mobile Application                 |                                    |
| Advanced Concrete Structure        |                                    |
| Web Application                    |                                    |
| DevOps                             |                                    |
| Database                           |                                    |
| Finance                            |                                    |
| Accounting                         |                                    |
| Sales Training                     |                                    |
| Digital Marketing                  |                                    |
| Hydrodynamics                      |                                    |
| Energy Dissipation                 |                                    |
| Mechanical and Vibration Structure |                                    |
*/
-- ------------------------------------------------------------------------

-- 17 ---------------------------------------------------------------------

-- Knowledge that the student need to know to validate Prerequisite 

SELECT p.name AS Prerequisite, k.name AS "The International Student need to know"
FROM Prerequisite p
LEFT JOIN Prerequisite_need_Knowledge p_k ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id
JOIN Knowledge k ON p_k.Knowledge_knowledge_id = k.knowledge_id
;
/*
| Prerequisite                       | The International Student need to know |
| ---------------------------------- | -------------------------------------- |
| Machine Learinig                   | Mathematics                            |
| Machine Learinig                   | Algebra                                |
| Machine Learinig                   | Set Theory                             |
| Machine Learinig                   | Python                                 |
| Machine Learinig                   | R                                      |
| Machine Learinig                   | Basic Programming                      |
| Mobile Application                 | Basic Programming                      |
| Advanced Concrete Structure        | Basic Engineering                      |
| Web Application                    | Basic Programming                      |
| DevOps                             | Basic Programming                      |
| Database                           | Basic Programming                      |
| Complex Algebra                    | Mathematics                            |
| Complex Algebra                    | Advanced Mathematics                   |
| Quantum Mechanics                  | Mathematics                            |
| Quantum Mechanics                  | Advancced Physics                      |
| Quantum Mechanics                  | Duality Particle/Wave                  |
| Marketing Analytics                | Mathematics                            |
| Marketing Analytics                | Finance                                |
| Accounting                         | Finance                                |
| Sales Training                     | Finance                                |
| Digital Marketing                  | Finance                                |
| Digital Marketing                  | Python                                 |
| Hydrodynamics                      | Vibration                              |
| Energy Dissipation                 | Basic Engineering                      |
| Energy Dissipation                 | Basic Engineering                      |
| Mechanical and Vibration Structure | Basic Engineering                      |
| Software Engineering               | Basic Programming                      |
| Software Engineering               | Java                                   |
*/
-- ------------------------------------------------------------------------

-- 18 ---------------------------------------------------------------------

-- How many Knowledge a student need to validate Prerequisite 

SELECT p.name AS Prerequisite, COUNT(k.name) AS "# Courses to know"
FROM Prerequisite p
LEFT JOIN Prerequisite_need_Knowledge p_k ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id
JOIN Knowledge k ON p_k.Knowledge_knowledge_id = k.knowledge_id
GROUP BY p.name
;
/*
| Prerequisite                       | # Courses to know |
| ---------------------------------- | ----------------- |
| Accounting                         | 1                 |
| Advanced Concrete Structure        | 1                 |
| Complex Algebra                    | 2                 |
| Database                           | 1                 |
| DevOps                             | 1                 |
| Digital Marketing                  | 2                 |
| Energy Dissipation                 | 2                 |
| Hydrodynamics                      | 1                 |
| Machine Learinig                   | 6                 |
| Marketing Analytics                | 2                 |
| Mechanical and Vibration Structure | 1                 |
| Mobile Application                 | 1                 |
| Quantum Mechanics                  | 3                 |
| Sales Training                     | 1                 |
| Software Engineering               | 2                 |
| Web Application                    | 1                 |
*/
-- ------------------------------------------------------------------------

-- 19 ---------------------------------------------------------------------

-- International Students and all their knowledge

SELECT DISTINCT l.name AS Student, k.name
FROM Learner l
JOIN InternationalStudent intS ON intS.learner_id = l.learner_id
JOIN InternationalStudent_has_Knowledge IntS_k ON IntS_k.InternationalStudent_internationalStudent_id = intS.internationalStudent_id
JOIN Knowledge k ON IntS_k.Knowledge_knowledge_id = k.knowledge_id
JOIN Prerequisite_need_Knowledge p_k ON k.knowledge_id = p_k.Knowledge_knowledge_id
JOIN Prerequisite p ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id
;
/*
| Student          | name                  |
| ---------------- | --------------------- |
| Robert Harakaly  | Mathematics           |
| Radka Popovicova | Mathematics           |
| Robert Harakaly  | Duality Particle/Wave |
| Robert Harakaly  | Algebra               |
| Radka Popovicova | Algebra               |
| Robert Harakaly  | Set Theory            |
| Robert Harakaly  | Python                |
| Hugo Suzanne     | Python                |
| Robert Harakaly  | R                     |
| Radka Popovicova | Finance               |
| Robert Harakaly  | Basic Programming     |
| Hugo Suzanne     | Basic Programming     |
| Clement Berard   | Basic Programming     |
| Hugo Suzanne     | Java                  |
| Clement Berard   | Java                  |
*/
-- ------------------------------------------------------------------------

-- 20 ---------------------------------------------------------------------

-- International Students and courses that they can take

SELECT DISTINCT result.Student AS 'International Students', result.Eq AS "Courses that the student can take"
FROM (
SELECT DISTINCT l.name AS Student, COUNT(k.name) AS Number, p.name AS Eq, p.prerequisite_id AS id
FROM Learner l
JOIN InternationalStudent intS ON intS.learner_id = l.learner_id
JOIN InternationalStudent_has_Knowledge IntS_k ON IntS_k.InternationalStudent_internationalStudent_id = intS.internationalStudent_id
JOIN Knowledge k ON IntS_k.Knowledge_knowledge_id = k.knowledge_id
JOIN Prerequisite_need_Knowledge p_k ON k.knowledge_id = p_k.Knowledge_knowledge_id
JOIN Prerequisite p ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id
GROUP BY l.name, p.name, p.prerequisite_id
) AS result
LEFT JOIN Prerequisite_need_Knowledge p_k ON result.id = p_k.Prerequisite_prerequisite_id
JOIN Knowledge k ON p_k.Knowledge_knowledge_id = k.knowledge_id
GROUP BY result.Student, result.Number, result.Eq
HAVING COUNT(k.name) = result.Number
;
/*
| International Students | Courses that the student can take |
| ---------------------- | --------------------------------- |
| Clement Berard         | Database                          |
| Clement Berard         | DevOps                            |
| Clement Berard         | Mobile Application                |
| Clement Berard         | Web Application                   |
| Clement Berard         | Software Engineering              |
| Hugo Suzanne           | Database                          |
| Hugo Suzanne           | DevOps                            |
| Hugo Suzanne           | Mobile Application                |
| Hugo Suzanne           | Web Application                   |
| Hugo Suzanne           | Software Engineering              |
| Radka Popovicova       | Accounting                        |
| Radka Popovicova       | Sales Training                    |
| Radka Popovicova       | Marketing Analytics               |
| Robert Harakaly        | Database                          |
| Robert Harakaly        | DevOps                            |
| Robert Harakaly        | Mobile Application                |
| Robert Harakaly        | Web Application                   |
| Robert Harakaly        | Machine Learinig                  |
*/
-- ------------------------------------------------------------------------


-- 21 ---------------------------------------------------------------------

-- Put the International Students id and get courses that he/she can take

CALL fnc_course_for_intStu(3);
/*
| International Students | Courses that the student can take |
| ---------------------- | --------------------------------- |
| Hugo Suzanne           | Database                          |
| Hugo Suzanne           | DevOps                            |
| Hugo Suzanne           | Mobile Application                |
| Hugo Suzanne           | Web Application                   |
| Hugo Suzanne           | Software Engineering              |
*/
-- ------------------------------------------------------------------------


-- 22 ---------------------------------------------------------------------

-- How many students they are in each section and what is the max capacity of a section

SELECT c.name AS Course, s.number AS 'Section #',  COUNT(l.name) AS '# Students', s.size AS '# MAX Capacity'
FROM Learner l
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id
JOIN Course c ON l_c.Course_course_id = c.course_id
JOIN Course_has_Section c_s ON c.course_id = c_s.Course_course_id
JOIN Section s ON s.section_id = c_s.Section_section_id
JOIN Located loc ON loc.Section_section_id = s.section_id
JOIN Class class ON loc.Facility_facility_id = class.class_id
WHERE l_c.section = s.number
GROUP BY c.name, s.size, class.size, s.number
;
/*
| Course               | Section # | # MAX Capacity | # Students |
| -------------------- | --------- | -------------- | ---------- |
| Accounting           | 0         | 22             | 1          |
| Algebra              | 2         | 4              | 1          |
| Analysis             | 7         | 4              | 1          |
| Data Analysis        | 0         | 5              | 1          |
| Database             | 1         | 20             | 2          |
| Database             | 20        | 40             | 1          |
| DevOps               | 5         | 4              | 3          |
| Digital Marketing    | 7         | 4              | 1          |
| Discrete Math        | 4         | 4              | 1          |
| Electrodynamics      | 6         | 40             | 1          |
| Finance              | 0         | 22             | 1          |
| Marketing Analytics  | 1         | 4              | 2          |
| Mechanics            | 5         | 40             | 1          |
| Mobile Application   | 6         | 4              | 1          |
| Mobile Application   | 3         | 5              | 1          |
| Modern Physics       | 4         | 5              | 1          |
| Sales Training       | 0         | 22             | 1          |
| Software Engineering | 2         | 5              | 2          |
| Web Application      | 8         | 22             | 1          |
*/
-- ------------------------------------------------------------------------


-- 23 ---------------------------------------------------------------------

-- See if they are still place for a student to be in one course/section
-- 1 Means TRUE and 0 means FALSE

SELECT l.name AS Student, c.name AS Course, s.number AS 'Section', can_the_student_take_this_course (1, 13, 5) AS 'Boolean if he can take the course'
FROM Learner l, Course c, InternationalStudent inter, Section s, Course_has_Section c_s
-- JOIN InternationalStudent inter ON inter.learner_id = l.learner_id
-- WHERE inter.internationalStudent_id = 1 AND c.course_id = 13
WHERE inter.internationalStudent_id = 1 AND c.course_id = 13 AND inter.learner_id = l.learner_id AND s.number = 5 AND c_s.Course_course_id = c.course_id AND c_s.Section_section_id = s.section_id
;
/*
| Student         | Course | Section | Boolean if he can take the course |
| --------------- | ------ | ------- | --------------------------------- |
| Robert Harakaly | DevOps | 5       | 1                                 |
*/

-- ------------------------------------------------------------------------


-- 24 ---------------------------------------------------------------------

-- Find all Researcher see all their publications

SELECT e.name AS Researcher, pr.name AS Publication
FROM Employee e
JOIN FacultyMember f ON e.employee_id = f.employee_id
JOIN Researcher r ON f.facultyMember_id = r.facultyMember_id
JOIN pubish p ON r.researcher_id = p.Researcher_researcher_id
JOIN PaperResearch pr ON pr.paperResearch_id = p.PaperResearch_paperResearch_id
;
/*
| Researcher | Publication               |
| ---------- | ------------------------- |
| Albert     | New way to program Python |
| Albert     | Machine Learning          |
| Albert     | Using Python for SQL      |
| Charles    | Medicine                  |
| Jack       | Black hole                |
| Jack       | Gravitation               |
*/

-- ------------------------------------------------------------------------

-- 25 ---------------------------------------------------------------------

-- Count how many publication did each Researcher

SELECT e.name AS Researcher, COUNT(pr.name) AS '# Publication'
FROM Employee e
JOIN FacultyMember f ON e.employee_id = f.employee_id
JOIN Researcher r ON f.facultyMember_id = r.facultyMember_id
JOIN pubish p ON r.researcher_id = p.Researcher_researcher_id
JOIN PaperResearch pr ON pr.paperResearch_id = p.PaperResearch_paperResearch_id
GROUP BY e.name
;
/*
| Researcher | # Publication |
| ---------- | ------------- |
| Albert     | 3             |
| Charles    | 1             |
| Jack       | 2             |
*/

-- ------------------------------------------------------------------------

-- 26 ---------------------------------------------------------------------

-- Who published the most paper research ?

SELECT e.name AS Researcher, COUNT(pr.name) AS '# Publication'
FROM Employee e
JOIN FacultyMember f ON e.employee_id = f.employee_id
JOIN Researcher r ON f.facultyMember_id = r.facultyMember_id
JOIN pubish p ON r.researcher_id = p.Researcher_researcher_id
JOIN PaperResearch pr ON pr.paperResearch_id = p.PaperResearch_paperResearch_id
GROUP BY e.name
ORDER BY COUNT(pr.name) DESC
LIMIT 1
;
/*
| Researcher | # Publication |
| ---------- | ------------- |
| Albert     | 3             |
*/

-- ------------------------------------------------------------------------

-- 27 ---------------------------------------------------------------------

-- Which student have an Intern ? And in which position ?

SELECT l.name AS Student, i.name_position AS 'Position name'
FROM Learner l
JOIN Intern i ON i.intern_id = l.Intern_intern_id
;

/*
| Student         | Position name     |
| --------------- | ----------------- |
| Zuzka Hadvabova | Nurse             |
| Ali Baba        | Shop              |
| Arjun Kumar     | Teacher Assistant |
*/

-- ------------------------------------------------------------------------

-- */