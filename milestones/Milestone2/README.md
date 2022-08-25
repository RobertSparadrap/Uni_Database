# Milestone 2: The Relational Model (25 points)

This milestone contains two checkpoints and it is worth 25 points of your final grade. The objetive of checkpoint #1 is to finish the modeling and architecture of your database, while the objective of checkpoint #2 is to test your database model against a set of self made business requirements. 

# Checkpoint #1: Database Model (12.5 points)

The goal of this milestone is to create a complete technical document that will define in detail the logical 
design and architecture of your database system. Note that this milestone is a professional document that is read by 
technical and non-technical people and teams (i,e CEO, CTO, Project Managers, Founders, Engineers, Testers....).

The relational model defines how data in your database system is storage based on your design from milestone 1 
In this milestone, you are going to create the database model (EER) based in your ERD. Once the database model is created, 
it will be forwarded engineered, and then tested. The integration process of your database system is not part of this milestone, but will be done
in the final project. 

After milestone 2 is completed, M1 and M2 become a single technical DB document with all the documentation needed 
to understand the design and architecture of your database system.

## TODO Before Next Section 

**IMPORTANT: Milestone 1 and 2 will become the same document. So, all the work done in this milestone must be done
after section VI of milestone 1**

1. Update your milestone history table with this new milestone. In descending order. For example: 


| Milestone/Version |    Date    |
| ----------------- | ---------- |
|       M2          | 07/15/2020 |
|       M1          | 06/25/2020 |

***Note: the dates on the "Date" column are not the real deadlines of the milestones. I made them up to illustrate the concept***

2. Update the table of contents of the document with the new sections from this milestone that will be added to the 
actual document

3. Complete the following sections after section VI of your milestone 1

## Section VII: Database Model/EER (8.5 points)

***Note: I strongly recommend to use MYSQLWorkBench for this section. Hand draw database models are not allowed here ***

1. Create the database model of your database system based on the final version of your ERD. Once the database model is 
completed. Export it as in image, or take a screen shot of it, and add it to this section. Note that screenshot must look 
professional (don't forget that this is a professional technical document about your database system). You can use 
MYSQLWorkBench to create the database model as taught in class. Your database must show clearly:
 
   * PK, FK and Unique keys
  
   * All the table attributes, and their data types
  
   * NOT NULL in attributes (if any)
  
   * Identifying relationships and non-identifying relationships. Both of them represented by solid and dashed lines in 
  the database model. 
  
   * All the cardinalities including those with zeros 
   
2. Save your database model as EER.mwb and add this file to the "files" folder  

3. Create a description (similar to the one below) of all the tables that implement ON DELETE AND ON UPDATE and all their possible 
constraints (CASCADE, SET NULL......). This description should include a detailed comment about your
motivations to select those tables as the ones that implement those constraints. 

|     Table     |       FK        |       ON DELETE        |        ON UPDATE        |                  Comment                        | 
| ------------- | --------------- | ---------------------- | ----------------------- | ----------------------------------------------- |
|    Account    |      user       |       ON CASCADE       |        ON CASCADE       | If a user is deleted, then the account from that user must be deleted as well
|    User       |      role       |       SET NULL         |        ON CASCADE       | If a role is deleted from the user table, the user that was holding that role will have no role until a new one is assigned.    

## Section VIII: Forward Engineering (2 points)

***Note: in this section, I strongly recommend to use MYSQLWorkBench for this section. Backward engineering is 
not allowed in this section***

The forwarding engineering process is the one that translate your database model (EER)  into the database schema 
that is used to create the physical database, tables and attributes in your database system

1. Before starting the forwarding engineering process of your database model, make sure to provide a meaningful name for your 
database schema. By default, MSQLWorkBench assign 'mydb'. Replace it with the name of your database + "DB" (i.e LibraryManagementDB)

2. Proceed with the forward engineering process of your database model as learned in class, and create a
file databasemodel.sql file that contains all the CREATE SQL statements from the forward engineering process

4. Run databasemodel.sql script in your mysql instance to create your physical database schema and its tables 
in your system. This can be done in many different ways, but the most common are:

    * Run the databasemodel.sql script directly in your MYSQLWorkBench 
    
    * Open a SQL script windows MYSQLWorkBench, and copy and paste the content of databasemodel.sql there.
      Then, click on run.
      
    * Open a terminal windows, and connect to your MySQL instance, then execute the following command: 
       ```mysql
          mysql> source <path_to_your_sql_script>;
       ```

5. Put databasemodel.sql file in the 'files' folder

6. No need to add anything to the milestone2 document for this section. 

***Note: databasemodel.sql must run without errors when I run it in my machine***

## Section IX: Inserting Data (2 points )

In order to test your database system, it needs to have sample data that represents the scope and domain
of the real data that the user of your system will insert in your database. 

1. Create a file inserts.sql file. 

2. Add some comments on the top of the file to explain the context of this file

3. The first SQL code this file must have is the following: 

    ```mysql
       USE LibrarySystemDB; -- Replace LibrarySystemDB by the name of your database system
    ```
4. Insert some sample data in all your tables. ***Each table in your database must have at least three inserts.***
For instance, our library system database has three tables User, Book, and Account: 
    ```mysql
       -- Script name: inserts.sql
       -- Author:      Jose Ortiz
       -- Purpose:     insert sample data to test the integrity of this database system
       
       -- the database used to insert the data into.
       USE LibrarySystemDB; 
       
       -- User table inserts
       INSERT INTO User (user_id, name, dob) VALUES (1, 'Alice', 631152000), (2, 'Bob', 694742400), (3, 'Trudi', 958089600);
       
       -- Book table inserts
       INSERT INTO Book (ISBM, title, author) VALUES (87736778838, 'Database System Concepts', 'Avi Silberschatz'), (87736778838, 'Clean Code', 'Robert C. Martin'), (8773677564, 'The Art of Computer Programming', 'Donald E. Knuth');
   
       -- Account table inserts
       INSERT INTO Account (account_id, user, role) VALUES (1, 1, 'Admin'), (2, 2, 'user'), (3, 3, 'admin');
       
   ``` 
5. Run inserts.sql in your MySQL instance. Steps are the same as listed in Section VIII (4) but using inserts.sql
instead of databasemodel.sql file

6. Put inserts.sql file in 'files' folder

7. No need to add anything to the milestone 2 document for this section. 

***Note: inserts.sql must run without errors when I run it in my machine***

## Checkpoint #1 Submission Guidelines 

The due date for this checkpoint will be announced in class, on iLearn, Discord, and by email. The following are the 
submission guidelines that you need to follow:

1. The name of your document must be m2.pdf, and must be uploaded to 'DatabaseSystems/milestones/milestone2/m2.pdf'

2. Late submissions won't be accepted. 

3. Failure to add all the files required in this milestone into the files folder in this directory will result in a grade of zero for your milestone. No exceptions. Those files must follow the naming format specified in the guidelines for this milestone.

4. Milestones documents that are sent by email, or hosted in personal repositories, or uploaded in a file format other than PDF won't be graded, and will be considered as not submitted. ***No exceptions***


# Checkpoint #2: Database Testing (12.5 points)

In this checkpoint, students will create at least 16 business requirements (plus two optional extra-credit). In addition, students will implement SQL queries to test and validate the logic for these business requirements. Business requirements (don't confuse them with business rules) are requirements created for the client as per your database specifications. Solutions to bussiness requirements in form of queries return data that is transformed into knowledge to meet the client needs.

## Business Requirements (2.5 points)

In the files directory, create a new BusinessRequirements.md file with the following: 

   * A list of 16-18 business requirements. They need to be clear and concise. Feel free to add any clarification in form of comments to your business requirements if needed. 

The following are some examples of business requirements for a learning management database system (e.g iLearn). Note that if you have this topic for your database, you can't use these business requirements for your project.: 

1. "Find the number of students with GPA greater than \<X\> that have not yet applied to grad school"
2. "For each professor that taught the same class, find the number of students that dropped before the drop deadline"
3. "For each professor, show the average grade per course taught by those professors"
4. "For each course, find the number of exams"
5. "Find the prerequisites of course \<X\>"
6. "Enroll a student in a course only if the student meets the class prerequisites"
7. "Find the points every student needs to get an A in the courses they are enrolled during a specific 
    semester"
8. "Find the number of students who took the same class within a specific date range"
9. "Update automatically the grade letter table every time a grade for an assignment is inserted into the database"
10. "Create a procedure to find all the students that took a course (passed as a parameter) that is not scheduled this semester" 
11. "Create a function that returns the number of professors that published more than 10 papers in all their academic life"

## Validating Business Requirements (10 points)

Students must create SQL queries to validate the logic of ALL their bussiness requeriments. This step is really important to test/validate if the business requirements meet the database design requirements, and most importantly, the client/user needs. Your queries will be tested against your SQL files submitted in M2.

In the files directory, create a SQL file (tests.sql) with implemented queries (an their outputs as comments) that will serve as a validation for the logic of all your business requirements. Those testing queries must meet the following business rules to get credit:  

    * Business requirements that can be solved using simple queries such that "SELECT * FROM TABLE WHERE ATTRIBUTE = VALUE" are not allowed in this 
      checkpoint, and won't get credit as such. 
    * ALL your business requirements MUST be implemented using fully optimized queries and "JOINS" to join tables.
    * At least 4 of your business requirements must be implemented with some sort of logic that includes a "GROUP BY" and "HAVING" queries 
    * At least 2 of your business requirements must be implemented using inner queries
    * At least 2 of your business requirements must be implemented using data insertion with implemented triggers using "BEFORE INSERT" and "AFTER INSERT"
    * At least 2 of your business requirements must be implemented using stored procedures 
    * At least 2 of your business requirements must be implemented using stored functions
    * At least 2 of your business requirements must be implemented using updates that include "JOINS" in the same query 
    * At least 2 of your business requirements must be implemented to delete data (ON CASCADE) from at least two tables in your database 
    * The 2 extracredit business requirements must be approved by the instructor before being implemented. They must be HARD problems (harder than the other mandatory business requirements. Implemented extracredit business requirements are 1 point each as long as they are correctly implemented. 
    * All the queries will be tested against your database model and need to work without errors to get credit
    

## Checkpoint #2: Submission Guidelines.

1. This checkpoint must have the following files in the files folder: BusinessRequirements.md and tests.sql. Note that test.sql must run without errors to get credit for this checkpoint.


# Grading Rubrics 

1. This milestone is worth 25% of your final grade
2. Checkpoint #1 is worth 12.5 points out of the 35 points
3. Checkpoint #2 is worth 12.5 points out of the 35 points
4. Neither late work nor milestones with incomplete sections will get credit
6. Good formatting in technical documents is really important. There are non-technical individuals or organizations that would want to read only some specific sections of your document. That is why your document formatting must be good. (e.g including table of contents and page numbers) 

Good luck, everyone!








