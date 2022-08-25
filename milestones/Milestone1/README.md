# Milestone 1: The Semantic-Conceptual Model (25 points)

The goal of this milestone is to create a complete technical document that will define in detail the conceptual 
design and architecture of your database system. Note that this milestone is a professional document that is read 
by technical and non-technical people and teams (i,e CEO, CTO, Project Managers, Founders, Engineers, Testers....).

## Cover Page

This page must contain the title of your project (i.e Library Management System ), your name, student id and GitHub  username, and finally, a version history table similar 
to the one in the below:

| Milestone/Version |    Date    |
| ----------------- | ---------- |
|       M1V1        | 06/07/2020 |

## Table of Contents

A technical document like this one is read by technical and non-technical people (i,e CEO, founders, 
engineers....). So, some of them would want to have access to specific sections of this milestone directly and 
skip some others. A table of contents with page numbers will help them to access quickly to all the content in 
this milestone
   

## Section I: Project Description (2 points)

In this section, you are going to create a complete description of the idea for your database system project. 
This is a high level description since at this point, the scope of the database system that you are about to create 
is not clear yet. The project description should define clearly the technical/business problems you are trying to solve. 
Focus on problems in the scope of database systems. Put time on this section because all the user cases that you are going to create
in the next section must be strictly related with this section


## Section II: Use Cases (5 points)

Based on your project description, **create at least five use cases for all the main entities and actors in your system.**
Refer to class slides to learn more about how to create good use cases for your system. 
Take into consideration that having good use cases will help to extract good 
database requirements for your system. Use at least one of your use cases to define a possible failure in your system, 
and how to recover from it. For example, taking into consideration the example from section I, 
a good use case for that system would be:

"Marie wants to rent a book from library X (X is your system´s name), the system asks Marie to register first as a 
prerequisite to rent the book. Marie register into the system, and then login in her account. Then, she can search 
for the book she wants to rent. Marie finds a good book and starts the renting process. During the process, 
she decides that she needs an additional book. However, the system does not let her to rent a new book until 
the process of renting the first one is done." 

As you can see, this is a good use case because is using three main entities, 
and one specific problem that our system should be able to solve with a good DB design. 

## Section III: Database Requirements (5 points)

***Note: In this section, students must create database requirements based on the user cases from section II. They
must cover all your entities and relations that will exist in your database system.***

Business rules are database requirements that are extracted from use cases. A good business rules contains: 
(1) two or more entities, (2) one or more rules defining a relationship between such entities, 
(3) all the entities must be quantifiable, and (4) one or more optional conditions. 
Quantifiable entities are defined by the many, one or zero quantities. 

Database requirements must be enumerated and grouped by the entity that performs the action 
so later they are easy to find in the document. 

Example of database requirements extracted from our use case example given in section II: 

    1. User 
        1.1. A user shall create only one account 
        1.2. A user shall be able to rent multiple books at once before checking out
        1.3. A user shall have at least one role.

    2. Account 
        2.1. An account shall be created by only one user. 
    
    3. Role
        3.1 A role shall be linked to many users. 
    
    4. Book
        4.1 A book can be rented by multiple users

Database requirements listed in this section must cover ALL the following relationships:

1. Many-to-Many
2. One-to-One
3. Many-to-One
4. One-to-Many
5. ISA
6. Aggregation 
7. Recursive

 

## Section IV: Detailed List of Main Entities, Attributes and Keys (3 points)

***Note: In this section, students must create at least 16 strong entities, and each entity must have 
at least three or more attributes. Failure to meet those guidelines will result in your milestone being returned with
a grade reduction.***

In this section, you must describe entities and their attributes for your database system, including keys and 
attributes details (data type and form). For example using our two business rules from section III. A good list would be:

      1. User (Strong)
          * user_id: key, numeric 
          * name: composite, alphanumeric
          * dob: multivalue, timestamp
          
      2. Book (Strong)
          * ISBM: key, alphanumeric
          * title: composite, alphanumeric
          * author: composite, alphanumeric
      
      3. Role (Strong)
          * role_id: key, numeric
          * description: alphanumeric
      
      3. Account (Weak)
          * id: key, numeric 
          * user: key, numeric 
          * role: key, numeric
          


***Give meaningful names to your entities and your attributes. For instance 't' is not a good
attribute name for the title of the book***

## Section V: Entity Relationship Diagram (ERD) (10 points)

***Note: all your entities from section IV must be in this diagram***

Based on your database requirements from section III and the entities and attributes from section IV, create a Entity
Relationship Diagram (ERD) that will represent the conceptual high level architecture of your database system.  

***Note: hand drawing diagrams are not allowed in this section***

This ERD must be done using a software tool that supports drawing diagrams. I strongly recommend for this section to
use [draw.io](https://www.draw.io) 



# Grading Rubrics 

1. This milestone is worth 25 points of your final grade

2. Students will be given more than enough time to complete your milestones. Plan your work accordingly because neither milestones submitted late nor milestones with incomplete sections will get credit. 

3. Good formatting in technical documents is really important. There are non-technical individuals that would want to read 
   only some specific sections of your document. That is why your document formatting must be good. (e.g including table 
   of contents and page numbers). 

4. Each section of this milestone must begin in a new page. 





# Submission Guidelines 

The due date for this milestone will be announced in class, on iLearn, Discord, and by email. The following are the 
submission guidelines that you need to follow:

1. Late work won't be accepted. No exceptions!!!

2. The table of assignments (found in main README file of your repository) MUST be updated to "completed/done" for this milestone. 
Milestones set to 'not completed' won't be graded because the grader, and I,  will assume that the milestone was not turned in on time 

3. The name of your document must be m1.pdf, and must be uploaded in PDF format. 

4. Milestone 1 document must be hosted in the master branch of your class repository 
(DatabaseSystems/milestones/milestone1/m1.pdf).

5. Milestones documents that are sent by email, or hosted in personal repositories, or uploaded in a file format other than PDF won't be graded, and will be considered as not submitted. ***No exceptions***












