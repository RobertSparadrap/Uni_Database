-- FUNCTION

DELIMITER $$

CREATE FUNCTION what_course_the_student_can_take_bool (internationalStudent_id INT, course_id INT)
RETURNS TINYINT
BEGIN
	DECLARE course INT;
    SET course = (SELECT DISTINCT COUNT(result.Student)
	FROM (
		SELECT DISTINCT l.name AS Student, COUNT(k.name) AS Number, p.name AS Eq, p.prerequisite_id AS id, intS.internationalStudent_id AS STU_id, p.prerequisite_id AS C_id
		FROM Learner l
		JOIN InternationalStudent intS ON intS.learner_id = l.learner_id
		JOIN InternationalStudent_has_Knowledge IntS_k ON IntS_k.InternationalStudent_internationalStudent_id = intS.internationalStudent_id
		JOIN Knowledge k ON IntS_k.Knowledge_knowledge_id = k.knowledge_id
		JOIN Prerequisite_need_Knowledge p_k ON k.knowledge_id = p_k.Knowledge_knowledge_id
		JOIN Prerequisite p ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id
		GROUP BY l.name, p.name, p.prerequisite_id, intS.internationalStudent_id, p.prerequisite_id
	) AS result
	LEFT JOIN Prerequisite_need_Knowledge p_k ON result.id = p_k.Prerequisite_prerequisite_id
	JOIN Knowledge k ON p_k.Knowledge_knowledge_id = k.knowledge_id
	WHERE result.STU_id = internationalStudent_id AND result.C_id = course_id
	GROUP BY result.Student, result.Number, result.Eq, result.STU_id
	HAVING COUNT(k.name) = result.Number);
    IF course >= 1 THEN
    	RETURN 1;
    END IF;
    RETURN 0;
END $$

CREATE FUNCTION is_there_still_place_for_a_student_to_come (learner_id INT, course_id INT, number INT)
RETURNS TINYINT
BEGIN
	DECLARE nb_student INT;
    DECLARE capacity INT;
    SET nb_student = (	SELECT COUNT(l.name)
						FROM Learner l
						JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id
						JOIN Course c ON l_c.Course_course_id = c.course_id
						JOIN Course_has_Section c_s ON c.course_id = c_s.Course_course_id
						JOIN Section s ON s.section_id = c_s.Section_section_id
						WHERE l_c.section = s.number
                        AND c.course_id = course_id
                        AND s.number = number
						GROUP BY c.name, s.size, s.number);
    SET capacity = (	SELECT s.size
 						FROM Learner l
 						JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id
 						JOIN Course c ON l_c.Course_course_id = c.course_id
 						JOIN Course_has_Section c_s ON c.course_id = c_s.Course_course_id
 						JOIN Section s ON s.section_id = c_s.Section_section_id
 						WHERE l_c.section = s.number
                      	AND s.number = number
                    	AND c.course_id = course_id
 						GROUP BY c.name, s.size, s.number);
    IF capacity - nb_student > 0 THEN
    	RETURN 1;
    END IF;
    RETURN 0;
END $$

CREATE FUNCTION can_the_international_student_be_added_in_the_course(internationalStudent_id INT, course_id INT, number INT)
RETURNS TINYINT
BEGIN
	DECLARE bool_place INT;
    DECLARE bool_knowledge INT;
    DECLARE id INT;
    SET id = (SELECT l.learner_id FROM InternationalStudent i_s JOIN Learner l ON i_s.learner_id = l.learner_id WHERE i_s.internationalStudent_id = internationalStudent_id);
    SET bool_place = is_there_still_place_for_a_student_to_come (id, course_id, number);
    SET bool_knowledge = what_course_the_student_can_take_bool (internationalStudent_id, course_id);
    IF bool_place = 1 AND bool_knowledge = 1 THEN
    RETURN 1;
    END IF;
    RETURN 0;
END $$

CREATE PROCEDURE porcedure_to_know_if_there_are_place (internationalStudent_id INT, course_id INT, number INT)
BEGIN
	SELECT l.name AS Student, c.name AS Course, s.number AS 'Section', is_there_still_place_for_a_student_to_come (internationalStudent_id, course_id, number) AS 'Boolean if there are some place to take this course'
FROM Learner l, Course c, InternationalStudent inter, Section s, Course_has_Section c_s
WHERE inter.internationalStudent_id = internationalStudent_id AND c.course_id = course_id AND inter.learner_id = l.learner_id AND s.number = number AND c_s.Course_course_id = c.course_id AND c_s.Section_section_id = s.section_id;
END $$

CREATE PROCEDURE we_want_to_know_if_the_student_can_take_the_course (internationalStudent_id INT, course_id INT, number INT)
BEGIN
	SELECT l.name AS Student, c.name AS Course, s.number AS Section, can_the_international_student_be_added_in_the_course(internationalStudent_id, course_id, number) AS 'Bool if he can take the course'
	FROM Learner l, Course c, InternationalStudent inter, Section s, Course_has_Section c_s
	WHERE inter.internationalStudent_id = internationalStudent_id AND c.course_id = course_id AND inter.learner_id = l.learner_id AND s.number = number AND c_s.Course_course_id = c.course_id AND c_s.Section_section_id = s.section_id;
END $$

CREATE PROCEDURE fnc_course_for_intStu (internationalStudent_id INT)
BEGIN
	SELECT DISTINCT result.Student AS 'International Students', result.Eq AS "Courses that the student can take"
	FROM (
		SELECT DISTINCT l.name AS Student, COUNT(k.name) AS Number, p.name AS Eq, p.prerequisite_id AS id, intS.internationalStudent_id AS STU_id
		FROM Learner l
		JOIN InternationalStudent intS ON intS.learner_id = l.learner_id
		JOIN InternationalStudent_has_Knowledge IntS_k ON IntS_k.InternationalStudent_internationalStudent_id = intS.internationalStudent_id
		JOIN Knowledge k ON IntS_k.Knowledge_knowledge_id = k.knowledge_id
		JOIN Prerequisite_need_Knowledge p_k ON k.knowledge_id = p_k.Knowledge_knowledge_id
		JOIN Prerequisite p ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id
		GROUP BY l.name, p.name, p.prerequisite_id, intS.internationalStudent_id
	) AS result
	LEFT JOIN Prerequisite_need_Knowledge p_k ON result.id = p_k.Prerequisite_prerequisite_id
	JOIN Knowledge k ON p_k.Knowledge_knowledge_id = k.knowledge_id
	WHERE result.STU_id = internationalStudent_id
	GROUP BY result.Student, result.Number, result.Eq, result.STU_id
	HAVING COUNT(k.name) = result.Number;
END $$


-- TRIGGERS

CREATE TRIGGER trg_add_assignment_to_student AFTER INSERT ON Assignment
FOR EACH ROW
	BEGIN
		INSERT INTO Learner_has_Assignment (Learner_learner_id, Assignment_assignment_id) VALUES (new.student, new.assignment_id);
	END $$
    
CREATE TRIGGER trg_create_prerequirsite AFTER INSERT ON Course
FOR EACH ROW
	BEGIN
		INSERT INTO Prerequisite (prerequisite_id, name) VALUES (new.course_id, new.name);
	END $$
    
CREATE TRIGGER trg_add_gpa AFTER INSERT ON Assignment
FOR EACH ROW
	BEGIN
    	  DECLARE GPA FLOAT(4);
	   	  SET GPA = (
    	  SELECT AVG(grade) 
          FROM Assignment
          WHERE student = new.student
          GROUP BY student);
		  UPDATE Learner SET gpa = GPA WHERE learner_id = new.student;
	END $$


CREATE TRIGGER trg_add_size AFTER INSERT ON Class
FOR EACH ROW
	BEGIN
    	DECLARE SIZE INT;
        SET SIZE = (
        SELECT class.size
		FROM Class class
        WHERE new.class_id = class.class_id
        );
        UPDATE Section SET size = SIZE WHERE located = new.class_id;
    END $$


DELIMITER ;


-- INSERTS


-- COURSE INSERTS
INSERT INTO Course (course_id, name, type) VALUES (1, 'Mechanics', 'Physics');
INSERT INTO Course (course_id, name, type) VALUES (26, 'Modern Physics', 'Physics');
INSERT INTO Course (course_id, name, type) VALUES (2, 'Thermodynamics', 'Physics');
INSERT INTO Course (course_id, name, type) VALUES (3, 'Electrodynamics', 'Physics');
INSERT INTO Course (course_id, name, type) VALUES (16, 'Quantum Mechanics', 'Physics');
INSERT INTO Course (course_id, name, type) VALUES (4, 'Analysis', 'Mathematics');
INSERT INTO Course (course_id, name, type) VALUES (5, 'Algebra', 'Mathematics');
INSERT INTO Course (course_id, name, type) VALUES (6, 'Geometry', 'Mathematics');
INSERT INTO Course (course_id, name, type) VALUES (7, 'Discrete Math', 'Computer Science');
INSERT INTO Course (course_id, name, type) VALUES (8, 'Data Analysis', 'Computer Science');
INSERT INTO Course (course_id, name, type) VALUES (9, 'Machine Learinig', 'Computer Science');
INSERT INTO Course (course_id, name, type) VALUES (10, 'Mobile Application', 'Computer Science');
INSERT INTO Course (course_id, name, type) VALUES (12, 'Web Application', 'Computer Science');
INSERT INTO Course (course_id, name, type) VALUES (13, 'DevOps', 'Computer Science');
INSERT INTO Course (course_id, name, type) VALUES (14, 'Database', 'Computer Science');
INSERT INTO Course (course_id, name, type) VALUES (15, 'Complex Algebra', 'Mathematics');
INSERT INTO Course (course_id, name, type) VALUES (11, 'Advanced Concrete Structure', 'Civil Engineer');
INSERT INTO Course (course_id, name, type) VALUES (17, 'Marketing Analytics', 'Business');
INSERT INTO Course (course_id, name, type) VALUES (18, 'Finance', 'Business');
INSERT INTO Course (course_id, name, type) VALUES (19, 'Accounting', 'Business');
INSERT INTO Course (course_id, name, type) VALUES (20, 'Sales Training', 'Business');
INSERT INTO Course (course_id, name, type) VALUES (21, 'Digital Marketing', 'Business');
INSERT INTO Course (course_id, name, type) VALUES (22, 'Earthquake Engineering', 'Civil Engineer');
INSERT INTO Course (course_id, name, type) VALUES (23, 'Hydrodynamics', 'Civil Engineer');
INSERT INTO Course (course_id, name, type) VALUES (24, 'Energy Dissipation', 'Civil Engineer');
INSERT INTO Course (course_id, name, type) VALUES (25, 'Mechanical and Vibration Structure', 'Civil Engineer');
INSERT INTO Course (course_id, name, type) VALUES (27, 'Software Engineering', 'Computer Science');

-- INTERN INSERTS
INSERT INTO Intern (intern_id, name_position) VALUES (1, 'Nurse');
INSERT INTO Intern (intern_id, name_position) VALUES (2, 'Shop');
INSERT INTO Intern (intern_id, name_position) VALUES (3, 'Teacher Assistant');

-- LEARNER INSERTS
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (1, 'Robert Harakaly', 23, 'Computer Science', 4);
INSERT INTO Learner (learner_id, name, year, major, school_year, Intern_intern_id) VALUES (2, 'Arjun Kumar', 25, 'Civil Engineer', 3, 3);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (3, 'Daniel Harakaly', 18, 'Computer Science', 1);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (4, 'Thibault Randu', 23, 'Sport Event', 3);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (5, 'Gianluca Zanin', 24, 'Event', 5);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (6, 'Radka Popovicova', 23, 'Business', 5);
INSERT INTO Learner (learner_id, name, year, major, school_year, Intern_intern_id) VALUES (7, 'Ali Baba', 26, 'Business', 6, 2);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (8, 'Alex San', 25, 'Computer Science', 3);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (9, 'Hugo Suzanne', 28, 'Computer Science', 4);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (10, 'Clement Berard', 21, 'Computer Science', 4);
INSERT INTO Learner (learner_id, name, year, major, school_year, Intern_intern_id) VALUES (11, 'Zuzka Hadvabova', 23, 'Doctor', 4, 1);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (12, 'Luca Suter', 24, 'Physics', 5);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (13, 'Mika idk', 22, 'Physics', 3);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (14, 'Alexis Jeronimo', 27, 'Business', 2);
INSERT INTO Learner (learner_id, name, year, major, school_year) VALUES (15, 'Noam Toumi', 18, 'Business', 1);

-- ASSIGNMENTS INSERTS
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (1, 1, 95, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (2, 2, 97, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (3, 3, 93, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (4, 4, 87, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (5, 5, 100, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (6, 1, 96, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (7, 1, 94, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (8, 2, 100, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (9, 3, 91.20, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (10, 4, 90, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (11, 5, 79.80, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (12, 6, 100, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (13, 1, 100, 1);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (14, 1, 98, 6);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (15, 1, 95, 6);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (16, 1, 91, 6);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (17, 2, 89, 6);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (18, 1, 95, 6);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (19, 1, 98, 6);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (20, 1, 80, 12);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (21, 2, 85, 12);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (22, 1, 87, 12);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (23, 1, 73, 12);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (24, 1, 80, 8);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (25, 1, 85, 8);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (26, 1, 70, 10);
INSERT INTO Assignment (assignment_id, number, grade, student) VALUES (27, 1, 69, 10);


-- ACTIVITY INSERTS
INSERT INTO Activity (activity, name, date, type, price) VALUES (1, 'Soccer', '2022-03-20', 'Sport', 0);
INSERT INTO Activity (activity, name, date, type, price) VALUES (2, 'Soccer', '2022-03-23', 'Sport', 0);
INSERT INTO Activity (activity, name, date, type, price) VALUES (3, 'Gator Fest', '2022-02-23', 'Party', 0);


-- PARTICIPATE INSERTS
INSERT INTO participate (Activity_activity, Learner_learner_id) VALUES (1, 1);
INSERT INTO participate (Activity_activity, Learner_learner_id) VALUES (2, 1);
INSERT INTO participate (Activity_activity, Learner_learner_id) VALUES (3, 6);
INSERT INTO participate (Activity_activity, Learner_learner_id) VALUES (3, 1);

-- INTERNATIONAL STUDENT INSERTS
INSERT INTO InternationalStudent (internationalStudent_id, learner_id, school) VALUES (1, 1, 'University of Geneva');
INSERT INTO InternationalStudent (internationalStudent_id, learner_id, school) VALUES (2, 6, 'CPH BUSINESS');
INSERT INTO InternationalStudent (internationalStudent_id, learner_id, school) VALUES (3, 9, 'Dublin University of Technology');
INSERT INTO InternationalStudent (internationalStudent_id, learner_id, school) VALUES (4, 10, 'Epitech');
INSERT INTO InternationalStudent (internationalStudent_id, learner_id, school) VALUES (5, 4, 'Isefac');

-- STUDENT INSERTS
INSERT INTO Student (student_id, learner_id) VALUES (1, 2);
INSERT INTO Student (student_id, learner_id) VALUES (2, 7);
INSERT INTO Student (student_id, learner_id) VALUES (3, 3);
INSERT INTO Student (student_id, learner_id) VALUES (4, 5);
INSERT INTO Student (student_id, learner_id) VALUES (5, 8);
INSERT INTO Student (student_id, learner_id) VALUES (6, 11);
INSERT INTO Student (student_id, learner_id) VALUES (7, 12);
INSERT INTO Student (student_id, learner_id) VALUES (8, 13);
INSERT INTO Student (student_id, learner_id) VALUES (9, 14);
INSERT INTO Student (student_id, learner_id) VALUES (10, 15);

-- GRADER INSERTS
INSERT INTO Grader (grader_id, Student_student_id) VALUES (1, 1);
INSERT INTO Grader (grader_id, Student_student_id) VALUES (2, 7);
INSERT INTO Grader (grader_id, Student_student_id) VALUES (3, 6);
INSERT INTO Grader (grader_id, Student_student_id) VALUES (4, 5);

-- grades INSERTS
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 1);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 2);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 3);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 4);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 5);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 6);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 7);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (2, 8);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (2, 9);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (2, 10);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (2, 11);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (3, 12);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (3, 13);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (3, 14);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (3, 15);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (3, 16);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (4, 17);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (4, 18);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 19);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 20);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 21);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (2, 22);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 23);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 24);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (3, 25);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 26);
INSERT INTO Grades (Grader_grader_id, Assignment_assignment_id) VALUES (1, 27);

-- PAYROLL INSERTS
INSERT INTO Payroll (payroll_id, salary) VALUES (1, 3000);
INSERT INTO Payroll (payroll_id, salary) VALUES (2, 6000);
INSERT INTO Payroll (payroll_id, salary) VALUES (3, 5000);


-- EMPLOYEE INSERTS
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (1, 'Jose Ortiz', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (2, 'Nina', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (3, 'Charli Sasaki', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (4, 'Baumberger', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (5, 'Hugou', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (6, 'Lacobucci', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (7, 'Norman Lee', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (8, 'Valerie Randu', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (9, 'Louis', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (10, 'Lola', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (11, 'John', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (12, 'Alice', 1);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (13, 'Albert', 2);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (14, 'Charles', 2);
INSERT INTO Employee (employee_id, name, Payroll_payroll_id) VALUES (15, 'Jack', 2);

-- FACULTY_MEMBER INSERTS
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (1, 1, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (2, 2, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (3, 3, 'Physics');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (4, 4, 'Physics');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (5, 5, 'Physics');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (6, 6, 'Physics');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (7, 7, 'Data Structure');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (8, 8, 'Mathematics');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (9, 9, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (10, 10, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (11, 11, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (12, 12, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (13, 13, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (14, 14, 'Computer Science');
INSERT INTO FacultyMember (facultyMember_id, employee_id, field_know) VALUES (15, 15, 'Computer Science');

-- TEACHER INSERTS
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (1, 1);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (2, 2);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (3, 3);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (4, 4);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (5, 5);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (6, 6);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (7, 7);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (8, 8);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (9, 9);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (10, 10);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (11, 11);
INSERT INTO Teacher (teacher_id, facultyMember_id) VALUES (12, 12);

-- PROFFESSOR INSERTS
INSERT INTO Professor (professor_id, teacher_id) VALUES (1, 2);
INSERT INTO Professor (professor_id, teacher_id) VALUES (2, 3);
INSERT INTO Professor (professor_id, teacher_id) VALUES (3, 5);
INSERT INTO Professor (professor_id, teacher_id) VALUES (4, 6);
INSERT INTO Professor (professor_id, teacher_id) VALUES (5, 8);
INSERT INTO Professor (professor_id, teacher_id) VALUES (6, 9);
INSERT INTO Professor (professor_id, teacher_id) VALUES (7, 11);
INSERT INTO Professor (professor_id, teacher_id) VALUES (8, 12);

-- LECTURER INSERTS
INSERT INTO Lecturer (lecturer_id, teacher_id, work) VALUES (1, 1, 'Software Engineer');
INSERT INTO Lecturer (lecturer_id, teacher_id, work) VALUES (2, 4, 'Reserch');
INSERT INTO Lecturer (lecturer_id, teacher_id, work) VALUES (3, 7, 'Data Scientist');
INSERT INTO Lecturer (lecturer_id, teacher_id, work) VALUES (4, 10, 'Finance');

-- Researcher INSERTS
INSERT INTO Researcher (researcher_id, facultyMember_id) VALUES (1, 13);
INSERT INTO Researcher (researcher_id, facultyMember_id) VALUES (2, 14);
INSERT INTO Researcher (researcher_id, facultyMember_id) VALUES (3, 15);

-- PaperResearch INSERTS
INSERT INTO PaperResearch (paperResearch_id, size, name, date_publication) VALUES (1, 14, 'New way to program Python', '2022-02-23');
INSERT INTO PaperResearch (paperResearch_id, size, name, date_publication) VALUES (2, 20, 'Machine Learning', '2022-02-23');
INSERT INTO PaperResearch (paperResearch_id, size, name, date_publication) VALUES (3, 46, 'Using Python for SQL', '2022-02-23');
INSERT INTO PaperResearch (paperResearch_id, size, name, date_publication) VALUES (4, 14, 'Medicine', '2022-02-23');
INSERT INTO PaperResearch (paperResearch_id, size, name, date_publication) VALUES (5, 14, 'Black hole', '2022-02-23');
INSERT INTO PaperResearch (paperResearch_id, size, name, date_publication) VALUES (6, 14, 'Gravitation', '2022-02-23');

-- publish INSERTS
INSERT INTO pubish (Researcher_researcher_id, Researcher_facultyMember_id, PaperResearch_paperResearch_id) VALUES (1, 13, 1);
INSERT INTO pubish (Researcher_researcher_id, Researcher_facultyMember_id, PaperResearch_paperResearch_id) VALUES (1, 13, 2);
INSERT INTO pubish (Researcher_researcher_id, Researcher_facultyMember_id, PaperResearch_paperResearch_id) VALUES (1, 13, 3);
INSERT INTO pubish (Researcher_researcher_id, Researcher_facultyMember_id, PaperResearch_paperResearch_id) VALUES (2, 14, 4);
INSERT INTO pubish (Researcher_researcher_id, Researcher_facultyMember_id, PaperResearch_paperResearch_id) VALUES (3, 15, 5);
INSERT INTO pubish (Researcher_researcher_id, Researcher_facultyMember_id, PaperResearch_paperResearch_id) VALUES (3, 15, 6);


-- Course_has_Prerequisite INSERTS
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (1, 16);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (26, 16);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (1, 26);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (5, 26);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (3, 2);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (4, 6);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (5, 6);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (8, 9);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (5, 9);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (5, 15);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (5, 17);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (25, 22);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (10, 27);
INSERT INTO Course_has_Prerequisite (Prerequisite_prerequisite_id, Course_course_id) VALUES (12, 27);


-- COURSE INSERTS
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (26, 1, 4);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (7, 1, 4);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (8, 1, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (14, 1, 1);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (10, 9, 3);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (14, 9, 20);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (13, 9, 5);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (17, 9, 1);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (17, 6, 1);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (18, 6, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (20, 6, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (19, 6, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (24, 2, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (25, 2, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (11, 2, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (22, 2, 0);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (14, 8, 1);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (13, 8, 5);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (12, 8, 8);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (27, 8, 2);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (13, 10, 5);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (10, 10, 6);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (21, 10, 7);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (27, 10, 2);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (1, 12, 5);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (3, 12, 6);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (4, 12, 7);
INSERT INTO Learner_has_Course (Course_course_id, Learner_learner_id, section) VALUES (5, 12, 2);


-- COURSE HAS ASSIGMNMENT INSERTS
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (26, 1);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (26, 2);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (26, 3);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (26, 4);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (26, 5);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (14, 6);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (7, 7);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (7, 8);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (7, 9);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (7, 10);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (7, 11);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (7, 12);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (8, 13);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (18, 14);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (18, 15);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (17, 16);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (17, 17);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (20, 18);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (19, 19);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (3, 20);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (3, 21);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (1, 22);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (4, 23);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (14, 24);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (27, 25);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (27, 26);
INSERT INTO Course_has_Assignment (Course_course_id, Assignment_assignment_id) VALUES (13, 27);

-- SECTION INSERTS
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (1, 1, 1, 1);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (2, 2, 20, 3);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (3, 3, 4, 4);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (4, 1, 4, 5);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (5, 7, 0, 4);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (6, 1, 2, 4);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (7, 2, 3, 4);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (8, 2, 4, 4);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (9, 8, 1, 5);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (10, 9, 5, 5);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (11, 10, 6, 5);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (12, 10, 7, 5);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (13, 11, 0, 2);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (14, 12, 0, 2);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (15, 12, 0, 2);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (16, 9, 8, 2);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (17, 4, 5, 3);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (18, 6, 6, 3);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (19, 8, 7, 5);
INSERT INTO Section (section_id, Teacher_teacher_id, number, located) VALUES (20, 8, 2, 5);

-- CLASS INSERTS
INSERT INTO Class (class_id, size) VALUE (1, 20);
INSERT INTO Class (class_id, size) VALUE (2, 22);
INSERT INTO Class (class_id, size) VALUE (3, 40);
INSERT INTO Class (class_id, size) VALUE (4, 5);
INSERT INTO Class (class_id, size) VALUE (5, 4);
INSERT INTO Class (class_id, size) VALUE (6, 50);


-- COURSE HAS SECTION INSERT
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (1, 14);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (2, 14);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (3, 26);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (4, 7);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (5, 8);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (6, 27);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (7, 10);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (7, 11);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (9, 17);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (10, 13);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (11, 10);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (12, 21);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (13, 20);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (14, 19);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (15, 18);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (16, 12);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (17, 1);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (18, 3);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (19, 4);
INSERT INTO Course_has_Section (Section_section_id, Course_course_id) VALUES (20, 5);

-- Knowledge INSERT
INSERT INTO Knowledge (knowledge_id, name) VALUE (1, 'Mathematics');
INSERT INTO Knowledge (knowledge_id, name) VALUE (2, 'Basic Physics');
INSERT INTO Knowledge (knowledge_id, name) VALUE (3, 'Advancced Physics');
INSERT INTO Knowledge (knowledge_id, name) VALUE (4, 'Duality Particle/Wave');
INSERT INTO Knowledge (knowledge_id, name) VALUE (5, 'Energy');
INSERT INTO Knowledge (knowledge_id, name) VALUE (6, 'Quantum');
INSERT INTO Knowledge (knowledge_id, name) VALUE (7, 'Algebra');
INSERT INTO Knowledge (knowledge_id, name) VALUE (8, 'Set Theory');
INSERT INTO Knowledge (knowledge_id, name) VALUE (9, 'Analysis of Algorithms');
INSERT INTO Knowledge (knowledge_id, name) VALUE (10, 'Python');
INSERT INTO Knowledge (knowledge_id, name) VALUE (11, 'R');
INSERT INTO Knowledge (knowledge_id, name) VALUE (12, 'SQL');
INSERT INTO Knowledge (knowledge_id, name) VALUE (13, 'Advanced Mathematics');
INSERT INTO Knowledge (knowledge_id, name) VALUE (14, 'Basic Engineering');
INSERT INTO Knowledge (knowledge_id, name) VALUE (15, 'Vibration');
INSERT INTO Knowledge (knowledge_id, name) VALUE (16, 'Finance');
INSERT INTO Knowledge (knowledge_id, name) VALUE (17, 'Basic Programming');
INSERT INTO Knowledge (knowledge_id, name) VALUE (18, 'Java');


-- Prerequisite_need_Knowledge INSERT
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (16, 1);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (16, 3);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (16, 4);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (9, 1);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (9, 7);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (9, 8);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (9, 10);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (9, 11);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (15, 1);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (15, 13);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (11, 14);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (25, 14);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (24, 14);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (24, 14);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (23, 15);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (17, 1);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (17, 16);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (19, 16);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (20, 16);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (21, 16);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (21, 10);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (9, 17);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (10, 17);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (12, 17);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (13, 17);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (14, 17);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (27, 17);
INSERT INTO Prerequisite_need_Knowledge (Prerequisite_prerequisite_id, Knowledge_knowledge_id) VALUE (27, 18);


-- InternationalStudent_has_Knowledge INSERT
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 1);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 2);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 4);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 7);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 8);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 9);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 10);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 11);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 17);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (1, 12);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (2, 1);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (2, 7);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (2, 16);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (3, 17);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (3, 18);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (3, 10);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (4, 18);
INSERT INTO InternationalStudent_has_Knowledge (InternationalStudent_internationalStudent_id, Knowledge_knowledge_id) VALUE (4, 17);


-- Located INSERTS
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (1, 1);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (2, 3);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (3, 4);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (4, 5);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (5, 4);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (6, 4);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (7, 4);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (8, 4);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (9, 5);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (10, 5);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (11, 5);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (12, 5);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (13, 2);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (14, 2);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (15, 2);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (16, 2);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (17, 3);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (18, 3);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (19, 5);
INSERT INTO Located (Section_section_id, Facility_facility_id) VALUE (20, 5);