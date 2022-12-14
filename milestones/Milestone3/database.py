# database.py
# Handles all the methods interacting with the database of the application.
# Students must implement their own methods here to meet the project requirements.

import os
import pymysql.cursors
import dbmodels as model

db_host = os.environ['DB_HOST']
db_username = os.environ['DB_USER']
db_password = os.environ['DB_PASSWORD']
db_name = os.environ['DB_NAME']


def connect():
    try:
        conn = pymysql.connect(host=db_host,
                               port=3306,
                               user=db_username,
                               password=db_password,
                               db=db_name,
                               charset="utf8mb4", cursorclass=pymysql.cursors.DictCursor)
        print("Bot connected to database {}".format(db_name))
        return conn
    except:
        print("Bot failed to create a connection with your database because your secret environment variables " +
              "(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME) are not set".format(db_name))
        print("\n")

# your code here



HELP = [
          "This is just a test to know if I'm not sleeping XD",
          "This function can take 0 or many parameters:\nIf 0, it will show all info.\nIf more, it will show students with parameters given",
          "This will show all students and their courses and the professors they have, can take 0 or many parameters.\n If 0 parameters, it will show all students.\nIf one parameter (student's name), it will show only for this student",
          "This will show how many student have teachers:\nIf no paramaters are given, it will show all teachers\nIf we give a Teacher's name, it will show only this teacher",
          "This will show students gardes:\nIf 0 arguments, it will show all students\nIf the argument is a student, it will show his grade",
          "This will show the average grade of students\nIf 0 arguments, it will show all students\nIf the argument is a student, it will show his grade",
          "This will show all students with the courses they have with the professor, can take 0 or many parameters.\n If 0 parameters, it will show all students.\nIf one parameter (student's name), it will show only for this student",
          "This will show all courses and all their prerequisites, can take 0 or many parameters.\n If 0 parameters, it will show all courses.\nIf one parameter (courses's name), it will show only for this course",
          "This will show the Knowledge a student need to validate to have the prerequisite, can take 0 or many parameters.\n If 0 parameters, it will show all Knowledge.\nIf one parameter (Knowledge's name), it will show only for this Knowledge",
          "This will show all courses that a international student can take, can take 0 or many parameters.\n If 0 parameters, it will show all students with all courses.\nIf one parameter (student's name), it will show all courses for this students\nAnd if 2 parameters (student's name and course's name, it will say if this student can take or not the course)",
          "This will show all assignments with grade more than the parameter given",
          "This will show all assignments with grade less than the parameter given",
          "This will show how many activities did students, can take 0 or many parameters.\nIf 0 it will show for all students\nIf 1 parameter (student's name) it will show only for this student",
          "This will show how many grades the grader has given, can take 0 or many parameters.\nIf 0 it will show for all graders\nIf 1 parameter (grader's name) it will show only for this grader",
          "This will show knowledge students has, can take 0 or many parameters.\nIf 0 it will show for all students\nIf 1 parameter (student's name) it will show only ffor this student",
          "This will show the the number of students in sections",
          "This will show all publications of researcher, can take 0 or many arguments\nIf 0, it will show for all researchers\nIf 1 argument are given (researcher's name) it will show only for this researcher"
       ]

COMMANDS = {
            'milestone3': model.test,
            '/get_all_studdents': model.all_students,
            '/students_with_courses' : model.students_with_courses,
            '/nb_student_for_teacher': model.nb_student_for_teacher,
            '/student_grade': model.student_grade,
            '/average_student_grade': model.average_student_grade,
            '/students_and_all_assignment': model.students_and_all_assignments,
            '/courses_and_their_prerequirsite': model.courses_and_their_prerequirsite,
            '/knowledge_needed_for_prerequirsite': model.knowledge_needed_for_prerequirsite,
            '/what_courses_can_take_international_students': model.what_courses_can_take_international_students,
            '/assignment_grade_more_than': model.assignment_grade_more_than,
            '/assignment_grade_less_than': model.assignment_grade_less_than,
            '/how_many_activities': model.how_many_activities,
            '/who_graded_each_student': model.who_graded_each_student,
            '/knowledge_that_int_students_has': model.knowledge_that_int_students_has,
            '/number_off_students_in_a_section': model.number_off_students_in_a_section,
            '/researchers_and_their_publications': model.researcers_and_their_publications
        }

def my_split(msg):
  new = []
  last = 0
  inside = 0
  for idx, i in enumerate(msg):
    if i == "\"" and inside == 0:
      inside = 1
    elif i == "\"" and inside == 1:
      new.append(msg[last+1:idx])
      last = idx+1
      inside = 0
    if i == ' ' and inside == 0 and len(msg[last:idx]) > 1:
      new.append(msg[last:idx])
      last = idx+1
    elif i == ' ' and inside == 0 and len(msg[last:idx]) < 1:
      last = idx+1
  if msg[-1] != "\"":
    new.append(msg[last:idx+1].lower())
  print(new)
  try:
    new.remove('')
  except:
    return new
  return new
