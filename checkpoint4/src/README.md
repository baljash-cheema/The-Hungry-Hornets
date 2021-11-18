# The-Hungry-Hornets
Data Science Group for MSAI 339 Fall 2021
By Lili Barsky, Vikram Kharvi, and Josh Cheema (Team
Hungry Hornets)

Project Theme:
We would like to explore the relationship between officer compliance with department medical
policy including but not limited to incidents of drug and alcohol abuse, with allegations of police
misconduct, officer salary and rank, use of force by police, location and type of police work
conducted, and distribution of awards given by the department. We will explore these
relationships with other aspects of health as the data allows for.

Question 1:
Among officers who have drug and alcohol abuse or medical allegations against them,
how often are they co-accused? How does this co-accusal pattern vary based on whether
officers earn below or above the average annual salary across the full department?

Question 2:
Among officers who have drug & alcohol abuse and medical allegations against them,
how does the co-accusal pattern compare between more and less decorated officers?
Specifically, how does the co-accusal pattern compare between those with more and
less than the average number of award types won, respectively?

Re-creating our analysis:
Code is provided for the SQL queries as well as 5 ipynb notebooks run in Google
Colab.

The SQL queries are located in src/cp4.sql with comments in the code to explain
what each query does. The graph analytics were completed using Spark's GraphX and
the code is in the .ipynb notebooks in the src/ directory. We ran this code using
Google Colab. In order to run the code, the /src/graphframes-0.8.2-spark3.2-s_2.12.jar
file located in the src directory must be added to the folder in Colab where the
notebook is being run from.

The first part of Question 1 is answered with Q1_base.ipynb and the salary questions
are answered by Q1_higher.ipynb and Q1_lower.ipynb. The two components of question 2
are answered by Q2_less.ipynb and Q2_more.ipynb.

The only thing the user needs to do is ensure the .jar file is added and the code
will run without additional input.
