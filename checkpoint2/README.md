# The-Hungry-Hornets
Data Science Group for MSAI 339 Fall 2021
By Lili Barsky, Vikram Kharvi, and Josh Cheema (Team
Hungry Hornets)

Project Theme: We would like to explore the relationship between officer compliance with department medical policy including but not limited to incidents of drug and alcohol abuse, with allegations of police misconduct, officer salary and rank, use of force by police, location and type of police work conducted, and distribution of awards given by the department. We will explore these relationships with other aspects of health as the data permits.

For our second checkpoint, we created visualizations to answer the following questions:

1) Are officers with drug/alcohol abuse allegations more or less likely to be disciplined as a result of the fallout of the allegation, compared with officers with all other kinds of misconduct allegations?

We visualized this with two adjacent pie graphs, showing percentage disciplined versus not disciplined in each group. The SQL code under the src directory was utilized to generate the data, which was then plotted in Tableau.

2) Is the frequency of drug/alcohol abuse allegations versus all other allegations changing over time? We will visualize this with a connected scatterplot.

The SQL code under the src directory contains our query data. Since we are using the same table for each query, it was challenging to join or make a union of the output. Thus we ran each separately and exported the output to two CSV files. We then used Python to join the tables and export as one CSV file. The Python code for this is provided as well under src.

The output then uploaded into Tableau to generate a plot with the two lines shown.
