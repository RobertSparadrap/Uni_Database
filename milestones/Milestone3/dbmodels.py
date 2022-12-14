import os
import pymysql.cursors
import database as db

def test(msg=None):
  return "I am alive. Signed: CSC675rharakaly"

def co(connection, teachers, msg):
    c = connection.cursor()
    c.execute(teachers)
    teachers = c.fetchall()
    keys = []
    if len(msg) == 1:
      results = []
      nb = 0
      for i in teachers:
        stu = []
        k = list(i.keys())
        keys = k
        if i[k[0]].lower() == msg[0]:
          for j in k:
            stu.append(i[j])
          results.append(dict(zip(k, stu)))
          nb = 1
      if nb == 0:
        return "I don't know this student Xo"
    elif len(msg) == 0:
      results = teachers
    else:
        return("Too much arguments for me Xo")
    print(results)
    name = []
    for entity in results:
      n = []
      keys = list(entity.keys())
      for i in list(entity.keys()):
        n.append(entity[i])
      name.append(n)
    connection.close()
    print(keys)
    return show(name, keys)


class Learner:
  def __init__(self, name=None, major=None, school_year=None):
    self.name = name
    self.major = major
    self.school_year = school_year
  def help(self, name=None, major=None, school_year=None):
    return ["name", "major", "school_year"]
      

def show(list, keys):
  str = ''
  remove = []
  for idx, i in enumerate(keys):
    if i == "id" or i == "Assignment":
      remove.append(idx)
      continue
    str += "{:-<17}|".format(i)
  str += '\n\n'
  for i in list:
    for idx, j in enumerate(i):
      if idx in remove:
        continue
      if j != None:
        str += "{:-<17}|".format(j)
      else:
        str += "{:-<17}|".format('Null')
    str += '\n'
  return str

def close():
    connection.close()

def take_info(entity, msg):
  ret = []
  for i in msg:
    ret.append(entity[i])
  return ret

def all_students(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    sql = """Select * from Learner"""
    cursor = connection.cursor()
    cursor.execute(sql)
    results = cursor.fetchall()
    name = []
    try:
      for entity in results:
        learner = Learner()
        if len(msg) > 0:
          if 'name' not in msg:
            msg.insert(0, 'name')
          name.append(take_info(entity, msg))
        else:
          for i in learner.help():
            msg.append(i)
          name.append(take_info(entity, msg))
#          name.append([entity['name']])
    except:
      str = "The parameter(s) is not good :)\ntry:\n"
      for i in learner.help():
        str += i + "\n"
      return(str)
    connection.close()
    return show(name, learner.help())


def students_with_courses(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT stu.name AS Student, c.name AS Course, s.number AS Section, e.name AS Professor
FROM Learner stu
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = stu.learner_id
JOIN Course c ON l_c.Course_course_id = c.course_id
JOIN Course_has_Section c_s ON c.course_id = c_s.Course_course_id 
JOIN Section s ON s.section_id = c_s.Section_section_id
AND s.number = l_c.section
JOIN Teacher t ON t.teacher_id = s.Teacher_teacher_id
JOIN FacultyMember fm ON t.facultyMember_id = fm.facultyMember_id
JOIN Employee e ON fm.employee_id = e.employee_id"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"




def nb_student_for_teacher(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT DISTINCT e.name AS Professor , COUNT(DISTINCT stu.name) AS Student
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
ORDER BY Student DESC"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"



def student_grade(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT s.name AS Student, c.name AS Course, AVG(a.grade) AS Grade
FROM Learner s
JOIN Learner_has_Assignment l_a ON s.learner_id = l_a.Learner_learner_id
JOIN Assignment a ON a.assignment_id = l_a.Assignment_assignment_id
JOIN Course_has_Assignment c_a ON a.assignment_id = c_a.Assignment_assignment_id
JOIN Course c ON c_a.Course_course_id = c.course_id
GROUP BY s.name, Course"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"




def average_student_grade(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT s.name AS Student, AVG(ALL a.grade) AS Grade
FROM Learner s
JOIN Learner_has_Assignment l_a ON s.learner_id = l_a.Learner_learner_id
JOIN Assignment a ON a.assignment_id = l_a.Assignment_assignment_id
JOIN Course_has_Assignment c_a ON a.assignment_id = c_a.Assignment_assignment_id
JOIN Course c ON c_a.Course_course_id = c.course_id
GROUP BY s.name"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"



def students_and_all_assignments(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT DISTINCT result.*, result2.Grade, result2.Assignment, result3.Professor
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
) AS result3 ON result.id = result3.id AND result.Section = result3.Section"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"



def knowledge_needed_for_prerequirsite(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT p.name AS Prerequisite, k.name AS "The International Student need to know"
FROM Prerequisite p
LEFT JOIN Prerequisite_need_Knowledge p_k ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id
JOIN Knowledge k ON p_k.Knowledge_knowledge_id = k.knowledge_id"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"


def courses_and_their_prerequirsite(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT c.name AS Course, p.name AS Prerequisite
FROM Course c
LEFT JOIN Course_has_Prerequisite c_p ON c_p.Course_course_id = c.course_id
LEFT JOIN Prerequisite p ON c_p.Prerequisite_prerequisite_id = p.prerequisite_id"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"


def how_many_activities(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT l.name AS Student, act.name AS Activity, COUNT(act.name) AS "How many time"
FROM Learner l
LEFT JOIN participate p ON p.Learner_learner_id = learner_id
LEFT JOIN Activity act ON p.Activity_activity = activity
GROUP BY Student, act.name"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"


def researcers_and_their_publications(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT e.name AS Researcher, pr.name AS Publication
FROM Employee e
JOIN FacultyMember f ON e.employee_id = f.employee_id
JOIN Researcher r ON f.facultyMember_id = r.facultyMember_id
JOIN pubish p ON r.researcher_id = p.Researcher_researcher_id
JOIN PaperResearch pr ON pr.paperResearch_id = p.PaperResearch_paperResearch_id"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"

def number_off_students_in_a_section(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT c.name AS Course, s.number AS 'Section #',  COUNT(l.name) AS '# Students'
FROM Learner l
JOIN Learner_has_Course l_c ON l_c.Learner_learner_id = l.learner_id
JOIN Course c ON l_c.Course_course_id = c.course_id
JOIN Course_has_Section c_s ON c.course_id = c_s.Course_course_id
JOIN Section s ON s.section_id = c_s.Section_section_id
JOIN Located loc ON loc.Section_section_id = s.section_id
JOIN Class class ON loc.Facility_facility_id = class.class_id
WHERE l_c.section = s.number
GROUP BY c.name, class.size, s.number"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"

def knowledge_that_int_students_has(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT DISTINCT l.name AS Student, k.name
FROM Learner l
JOIN InternationalStudent intS ON intS.learner_id = l.learner_id
JOIN InternationalStudent_has_Knowledge IntS_k ON IntS_k.InternationalStudent_internationalStudent_id = intS.internationalStudent_id
JOIN Knowledge k ON IntS_k.Knowledge_knowledge_id = k.knowledge_id
JOIN Prerequisite_need_Knowledge p_k ON k.knowledge_id = p_k.Knowledge_knowledge_id
JOIN Prerequisite p ON p.prerequisite_id = p_k.Prerequisite_prerequisite_id"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"

def who_graded_each_student(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT grader.Grader, c.name AS Course, grader.Assignment AS Assignment, grader.Grade AS "Grade Given", l.name AS "Student Graded"
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
JOIN Course c ON c.course_id = c_a.Course_course_id"""
    return co(connection, teachers, msg)
  else:
    return "My connection failed xo"

def co2(connection, teachers, msg):
  c = connection.cursor()
  c.execute(teachers)
  teachers = c.fetchall()
  results = []
  nb = 0
  yes = 0
  student = 0
  courses = 0
  for i in teachers:
    k = list(i.keys())
    if i[k[0]].lower() == msg[0]:
      student = 1
    if i[k[1]].lower() == msg[1]:
      courses = 1
  if student and courses:
    for i in teachers:
      k = list(i.keys())
      if i[k[0]].lower() == msg[0] and i[k[1]].lower() == msg[1]:
        return "Yes "+msg[0]+" can take "+msg[1]
    return msg[0]+" can't take this course: "+msg[1]+"\n:("
  elif student == 0 and courses:
    return "I don't know this student"
  elif student and courses == 0:
    return "I don’t know this course"
  else:
    return "I don’t know the student and the course, are you sure you're in the right University ?"
  

def what_courses_can_take_international_students(msg):
  msg = msg[1:]
  print(msg)
  connection = db.connect()
  if connection:
    teachers = """SELECT DISTINCT result.Student AS 'International Students', result.Eq AS "Courses that the student can take"
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
HAVING COUNT(k.name) = result.Number"""
    if len(msg) < 2:
      return co(connection, teachers, msg)
    elif len(msg) == 2:
      return co2(connection, teachers, msg)
    else:
      return "Too much arguments for me Xo"
  else:
    return "My connection failed xo"


def assignment_grade_more_than(msg):
  msg = msg[1:]
  print(msg)
  if len(msg) != 1:
    return "You need to put one grade"
  try:
    int(msg[0])
  except:
    return "Put a number"
  if int(msg[0]) > 100:
    return "Whoa me too I would like to have more than 100% grade but unfortunately we don’t do that there :("
  if int(msg[0]) < 0:
    return "Well, fortunately it's not possible to get negative grade"
  connection = db.connect()
  if connection:
    teachers = """SELECT DISTINCT result.*, result2.Grade, result2.Assignment, result3.Professor
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
WHERE result2.Grade >= %s"""
    c = connection.cursor()
    c.execute(teachers, msg[0])
    results = c.fetchall()
    print(results)
    name = []
    keys = []
    for entity in results:
      n = []
      keys = list(entity.keys())
      for i in list(entity.keys()):
        n.append(entity[i])
      name.append(n)
    connection.close()
    return show(name, keys)
  else:
    return "My connection failed xo"




def assignment_grade_less_than(msg):
  msg = msg[1:]
  print(msg)
  if len(msg) != 1:
    return "You need to put one grade"
  try:
    int(msg[0])
  except:
    return "Put a number"
  if int(msg[0]) > 100:
    return "Whoa me too I would like to have more than 100% grade but unfortunately we don’t do that there :("
  if int(msg[0]) < 0:
    return "Well, fortunately it's not possible to get negative grade"
  connection = db.connect()
  if connection:
    teachers = """SELECT DISTINCT result.*, result2.Grade, result2.Assignment, result3.Professor
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
WHERE result2.Grade <= %s"""
    c = connection.cursor()
    c.execute(teachers, msg[0])
    results = c.fetchall()
    print(results)
    name = []
    keys = []
    for entity in results:
      n = []
      keys = list(entity.keys())
      for i in list(entity.keys()):
        n.append(entity[i])
      name.append(n)
    connection.close()
    return show(name, keys)
  else:
    return "My connection failed xo"
