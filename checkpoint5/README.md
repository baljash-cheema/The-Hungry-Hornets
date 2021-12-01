# The-Hungry-Hornets
Data Science Group for MSAI 339 Fall 2021
By Lili Barsky, Vikram Kharvi, and Josh Cheema (Team
Hungry Hornets)

Checkpoint 5:
Can we build a natural language processing model that allows users to ask questions
directly to it, in order to retrieve information on officers who have drug and
alcohol and medical abuse allegations against them? The aim is to create a tool that
would allow novice users to find out more information about these individuals without
coding experience. We will do this by adapting the TAPAS language model created
by Google and available publicly. Due to constraints in computational power with
the model itself, we will limit our analysis to officers with more than 2
allegations of drug and alcohol abuse, of whom have had at least 1 sustained
allegation and have a numerical value listed for their current salary.
We will measure the success of our approach by asking the following questions
to the model across every single officer and testing the overall accuracy per
question. Here, [X] represents each individual officer in our table.

a.	What is the race of [X]?
b.	What is the gender of [X]?
c.	What is the birth year of [X]?
d.	what is the allegation count of [X]?
e.	What is the sustained count of [X]?
f.	What is current salary of [X]?

SQL code for our table:
This is found under src/cp5.sql and can be run to re-create the table we used
to train our model to answer questions on.

How to run our notebook:
You will find the notebook under /src titled Checkpoint5.ipynb. Please load this in
colab and run all cells.

How to test our code:
