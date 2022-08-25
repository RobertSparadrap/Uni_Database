# Discord Bot (15 points)

In this milestone, students will create a Discord bot that will serve as a bridge interface between your database and the user. The main goal of this milestone is to transform the data (output from your business rules) into knowledge to meet the user needs.  

Before getting started with the bot implementation do the following:

1. Copy and paste your BusinessRequirements.md and tests.sql files from M2 into the BusinessRequirements folder found in this directory. 
2. Update your BusinessRequirements.md. So, in addition to your existing business requirements, you must create bot commands so once executed, the user will get the output from your implemented business requirements in for of data knowledge to fit their business needs. Finally, the list of bot commands must include at least one example that ilustrate (using real data from your database) the execution of the command, as I did in my examples below. When grading your project, we'll run those bot command examples first as a preliminary baseline tests.  

## Examples of Bot Commands: 

Note that the following examples are only ilustrative. You are not allowed to reuse them for your project. Also keep in mind that some of your bot commands will take user input. In your tests.sql, students implemented their business requirements based on the assumption that such conditions were static such as "WHERE GPA = 3.0". However, in this project, students must let the user choose the condition of the query entered right after the bot command, this also will require implementation of techniques to avoid SQL injection attacks comming from the user.

```.sql
    1. /number-students-gpa-greater-than \<gpa\> (i.e /students-gpa-greater-than 3.0)
    2. /number-students-dropped
    3. /avg-grade-per-course
    4. /number-exams-per-course
    5. /prerequisites-for \<course\> (i.e /prerequisites-for CSC675)
    6. /enroll-student \<sid\>, \<name\> <course> (i.e /enroll-student 123456789 Jose Csc675)   
```

## Getting Started

Bots are really popular (and sometimes necessary) in modern apps because they can be used to automatize processes, 
automatically handle data from storage systems (e.g databases), and provide specific services to the user of the app.
For instance, Nina's bot -- the one I created to manage my discord server --  helps me to provide useful information 
for students that otherwise, I would need to provide myself by email or in form of messages. Nina's bot saves me a 
lot of work.

In this milestone, students will be building their own Discord bot. Your bot must connect 
to your database system to solve some business problems related to the data stored in your database. 

The following are the high level steps that will be covered in this README file. 

1. Preparing Discord for your bot
2. Implementing your Bot in Python 
3. Hosting your Bot in Replit 

### Preparing Discord for your Bot 

Let's get started with the setting up of your Discord server. In this section you will prepare your discord to provide 
support for your Bot.

#### Discord Account

If you do not have a Discord account yet, create a new one [here](https://discord.com). If you already have a Discord account,
then ignore this step

#### Creating a Discord Server (Technically Know as Guild)

We'll use a Discord server as the user interface between out Bot and the user. 

1. Head to the discord [home](https://discord.com) page and sign in (if needed) using your Discord account
2. On the left hand panel, select select the + icon to add a new server 
3. It will prompt two options, select "Create Your Server", and provide the following name to your server 
"<your sfsu username>Server". For instance, my server would be named "jortizcoServer"
4. Create two new channels, ```#commands and #business-requirements```
5. In the ```#commands``` channel write the list of commands that the bot needs in order to solve each one of your business rules, and also add there some real examples about how to run those commands. (similar to what I did with my NinaBot in #bot-commands channel) 
6. In the ```#business-requirements``` channel write the list of bussiness requirements that your bot will solve. 

**Note that the lists of commands and business requirements must be approved by the class instructor by email**

#### Discord Application 

A Discord application allows you to interact with the Discord API. As many other APIs, 
you'll need to provide authentication and permissions. Applications in Discord are a high level abstraction to provide
communication between the Discord API and your Bot. 

1. In your [Discord Develpper Portal](https://discord.com/developers/applications), click on the "New Application" button
to create a new application. 
2. You'll be prompted to enter the name of the application, create the following name "CSC675M3" for your application, and
save the changes. 
3. Next, you'll be able to see all the information about your new application.  

#### Discord Bot 

Once an application has been successfully created, it is time to create your Bot user. The job of the Bot user is to 
react to certain events and command triggered by the user.  

1. Head to the left panel of your application in your [Developer Portal](https://discord.com/developers/applications)
and select the tab "Bot", and click on the "Add Bot" button found on the right panel of the bot tab. 
2. After the bot is successfully created, edit the name of your bot. Set the new name to "CSC675<your sfsu username>Bot"
where your SFSU username is the name before the @ in your SFSU email. For instance, if I were to create a bot, I would 
name it "CSC675jortizcoBot" (without quotes) because my SFSU email is jortizco@sfsu.edu. 
3. Click on reveal the Token link that is located below the username field of your bot, this token will be used later to provide authentication when the bot needs 
to access to the Discord API of your application. We'll use this token later when coding the Bot.  
4. Save all the changes 


#### Adding your Bot to your Server

Finally, we'll finish the set up of our application by registering our Bot to our server. Note that the Bots use the 
[QAuth2](https://oauth.net/2/), and we need to set up the Bot to use that protocol. 

1. Head again to your application [Developer Portal](https://discord.com/developers/applications) and click in your application. 
2. Head to the left hand panel of your application and select the QAuth2 tab. This tool will authorize the use of Discord APIs for your bot using your 
application's credentials 
3. On the right panel, set the authorization method to "In-app Authorization" and then in "scopes" check the "bot" checkbox. 
4. On the same panel, head to "Bot Permissions" and allow "administrator" permissions for your bot
5. Copy and paste the client id that can be found in "Client Information". 
6. Use the following link https://discordapp.com/oauth2/authorize?&client_id=YOUR_CLIENT_ID_HERE&scope=bot and replace YOUR_CLIENT_ID_HERE in the url with the client id from (5)


### Implementing your Bot in Python 

**IMPORTANT: from now on, this guideline assumes that students have some basic programming knowledge in Python. If you are
planning to implement your Bot using a programming language other than Python, you'll find useful links to tutorials at the end of 
this section that will help you to create the Bot using your favorite programming language. In addition, take into
 consideration that this guideline will help you to have your Bot running on Discord. However, this is a databases systems course 
and it is the students' job implementing the connection between the Bot and the database, and all the 
data manipulation required to solve the business rules approved by the class' instructor.** 

In this directory (milestone3), you'll find the following files: 

#### bot.py

The sample code provided in this file will help you to understand the basics of how the bot triggers
some events based on messages received by users (or the Discord system)

#### database.py 

In this file, you will implement the methods needed to handle all the connection and data manipulation that the bot needs to 
do in order to process requests from the Discord user. 

The connection method has been implemented for you already. However, you must set up first your secret environment 
variables to make it work. More details about this can be found in section "Host Bot in Replit" of this document

Finally, you will need to implement your own methods in order for your bot to solve the business rules approved by the
class' instructor. 

#### dbmodels.py 

In this file students will implement database modeling techniques for all their database entities. 


### Hosting your Bot in Replit 

For this milestone it is mandatory that students host their Bots in [Replit](htpps://replit.com). That way system 
incompatibilities during the grading process are minimized. In addition, a remote database must be created using your database model from milestone 2. Please refrain from hosting your database in Replit because it does not offer built-in support for relational databases. Replit only supports <key, value> database architectures which are not the focus of this course.  

#### Hosting your Database Remotely

First of all, students must host their database model remotely (localhost is not allowed in this milestone). Students are 
free to choose the hosting server to host their databases. Some examples of remote host where you can host a relational database for free are [AWS](https://aws.amazon.com/free/database/?trk=c0fcea17-fb6a-4c27-ad98-192318a276ff&sc_channel=ps&sc_campaign=acquisition&sc_medium=ACQ-P%7CPS-GO%7CBrand%7CDesktop%7CSU%7CDatabase%7CSolution%7CUS%7CEN%7CText&s_kwcid=AL!4422!3!548665196301!e!!g!!amazon%20relational%20db&ef_id=CjwKCAjw3K2XBhAzEiwAmmgrAoE1SvlDFAECMaxijNoBwdjfg6U6GcmNkrqIVqPruWdH2TxNSS5N9xoCJ_oQAvD_BwE:G:s&s_kwcid=AL!4422!3!548665196301!e!!g!!amazon%20relational%20db), [Google Cloud](https://cloud.google.com), [Microsoft Azure](https://azure.microsoft.com/en-gb/free/), and [Heroku](https://www.heroku.com). Note that in the remote database host of your choice, you must have permissions to run stored SQL triggers, procedures and functions.  

Once your database has been created in your remote host server. You'll need to write down the following info provided by your database host server.

• The name of the database 
    
• Your db username 
    
• Your db password 

#### Create a Bot in Replit 

The next steps will guide you into creating your bot (manually or importing this repository) into [Replit](https://replit.com)

1. Create a new account in [Replit](https://replit.com) (if you don't have one already)
2. Login using your email and password from step (1)
3. Create a new Python repl app. Note that [Replit](https://replit.com) supports many other programming languages. In this milestone, you are free to create your
bot using your favorite programming language. There are two ways to create a new repl app (1) importing the code from this repository, and 
(2) creating the app manually. The new steps cover the (2) way.   
4. Give a name to your repl. The name of your repl must be your SFSU username followed by "bot". For example, my app would be "jortizcobot" because my SFSU username is "jortizco".
5. If everything goes as expected, your screen will show your new programming environment for your app. Take your time to familiarize yourself with this environment. 
6. Copy and paste the code from "bot.py" into the "main.py" file of your repl app. 
7. In your repl app, create a new file "database.py" and copy and paste there the code from the same file found in this repository

Now is time to set up all the secret environment variables in your repl app

#### Secret Environment Variables

Your repl app allows you to set up secret environment variables such as tokens, db usernames and passwords. We'll use this tool
to set all the environments variables related to our bot and the database

Head to the left hand panel of your application, and click in the lock icon. 
Once there, set the following secret environment variables and their values 

```.env
DISCORD_TOKEN= dicord token of your bot
DISCORD_GUILD= the name of your Discord server
DB_HOST=       the host url where your remote database is hosted. (localhost won't work here)
DB_USER=       db username 
DB_PASSWORD=   db password
DB_NAME =      database name 
```

The Discord token can be copied and pasted from your [Developer Portal](https://discord.com/developers/applications) 
in the Bot tab from your application. 

Note that you don't need to modify the code related to the secret environment variables in 
"main.py" and "database.py". It is already ready to be used because it is reading
from any value set in those keys. For example, ```host = os.environ['DB_HOST']``` will save the
database host in the ```host``` variable. 

Now, your bot is ready to be tested. 

#### Testing your Bot 

Before you start the development of your methods for the database part of this project is imperative that you test 
your bot with the code provided by the instructor to make sure that everything works as expected, and then you can focus
in the database part of this project. 

Let's test your Bot. Before running the Bot client, make sure that the bot has been added to your Discord Server. You 
should see your bot in the list of users, and the bot must be offline. Also, make sure that all the environment variables
in repl have the correct values.  

1. In your repl application, click in your "main.py" file, and click in the "Run" button located on the top. Your 
console will begin installing all the Discord and pymysql libraries needed to run your app. Then, if no errors found, your app automatically will be deployed. 
2. If your program throws errors, they are probably due to secret environment variables with
wrong values. Fix this, and re-run the program. 
3. If no errors found, you'll see in console a message saying that your bot is connected to 
your database, and joined your Discord server
4. Head to your Discord server and check that your bot is online. If your bot is still offline, 
then check the logs of your repl to see what went wrong. 
5. If your bot is online, congratulations! you created your first Discord Bot. 
6. Now is time to test your bot. Write the following message in any of the channels of your
Discord server: ```milestone3``` and click enter. Your bot should react with the following message 
```I am alive. Signed: 'your bot'```


Pretty cool right? you just created your first bot. Now you are all set. 

Your job is to use your favorite programming language and your bot to connect with your database and execute from there your implement queries for your business requirements (you can reuse your SQL implementation from M2), so now users can interact with your bot to receive real time data in form of knowledge (well formatted data). 

### Useful Resources 

Here is a list of useful resources that you can use that will help you with the development of your bot for this milestone

* [How to create a Discord Bot with Java](https://medium.com/discord-bots/making-a-basic-discord-bot-with-java-834949008c2b)
* [How to create a Discord Bot with Javascript](https://www.freecodecamp.org/news/create-a-discord-bot-with-javascript-nodejs/)
* [Sample Repl App with the code from this repo](https://replit.com/join/aexibrqa-jortizco)

## Submission Guidelines 

***Failure to follow the following submission guidelines in detail will affect negatively your grade.**

By the deadline of this milestone, students must have the following in their main/master branch of their repositories for 
this milestone.  

1. In the main README (table of assignments) milestone3 must be set to "completed". **No exceptions**
2. The BusinessRequirements directory must contain both BusinessRequirements.md and tests.sql files. 
3. Your Discord server must have the following channels ```#general, #commands, and #business-requirements```
   * We'll use the #general channel to test your bot 
   * The #business-requirements channel must have all your enumerated business requirements (copy and paste them from BusinessRequirements.md)
   * The #commands channel must list your enumerated bot commands with examples (copy and paste them from BusinessRequirements.md) 
4. In this directory, create a new README file (ProjectReadme.md) and add the following info: 
   * Your name and student id. 
   * The link to join your Discord Server. Make sure that it doesn't expire. If the link is expired, we cannot grade your assignment. 
   * The invite link to your app hosted in replit.com. Note that this must be an invite link with edit permissions. Do not just copy and paste the url from your browser because that link won't work.
5. It is the responsability of the student to make sure that the database hosted in the remote server of your choice is always online and accessible by the bot. If the database is offline by the time we are grading, then we won't be able to grade your assignment. 
6. All your code must also be within this directory, and it must be exactly the same code that you have in your repl app. 
7. If you modified your databasemodel.sql or inserts.sql from milestone 2, then upload your updated files into this directory. 


## Grading Rubrics 

I totally recommend (as a good practice) to write readable and organized code with meaningful names for methods and variables. Keep in mind that if you are planning to showcase this project to employers to demostrate your knowledge in database systems, they will also require from you to have readable code even if a particular piece of code is not related to any of the aspects of the database.

This milestone is worth 15 points of your final grade, and the grade rubrics are detailed here as follow: 

* Your milestone won't be considered for grading if at least one of the following fails:

   *  All the links provided in the ProjectReadme.md file must work.  
   *  All the the coding files, bot.py, database.py, and dbmodels.py are must be fully implemented and/or run without throwing errors/exceptions
   *  Once we put your bot online, it must create a connection with your remote database.
 
* - 0.8 points will be deducted for every business requirement that was not correctly implemeneted or returns the wrong results. Note that all bot commands that are executed must return well formatted data. 
* Students are free to reuse, edit or distribute my own code provided in this folder in any of its forms. However, students cannot share their own code with other students. Otherwise, the work from all the parties involved in this action will incur into a cheating and plagiarism fault. Please read the course syllabus to learn more about the Cheating and Plagarishm policies stated by our department and the university related to this matter.
    

Good luck, everyone!


















 





