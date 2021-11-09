# The-Hungry-Hornets
Data Science Group for MSAI 339 Fall 2021
By Lili Barsky, Vikram Kharvi, and Josh Cheema (Team
Hungry Hornets)

Project Theme: We would like to explore the relationship between officer compliance with department medical policy including but not limited to incidents of drug and alcohol abuse, with allegations of police misconduct, officer salary and rank, use of force by police, location and type of police work conducted, and distribution of awards given by the department. We will explore these relationships with other aspects of health as the data permits.

For the revision of our second checkpoint analyses, we created visualizations to answer the following questions:

1) What is the frequency of each kind of drug/alcohol abuse and medical allegation made by officers as compared with civilians?

We visualized this with two adjacent word clouds, showing the relative frequency with which each allegation was made by officers and civilians, respectively. The SQL code under the src directory was utilized to generate the csv that provided the data for this visualization in Tableau. A filter was toggled to create the word clouds for officer complaints (is_officer_complaint=True) and civilians (is_officer_complaint=False), respectively. These visualizations can be found in our final findings pdf file.

2) Is the frequency of drug/alcohol abuse and medical allegations versus other allegations changing over time? We will visualize this with a connected scatterplot.

The SQL query and python code utilized to generate the csvs for this visualization can be found under the src directory.
The line plot generated in Tableau was made more legible and less noisy than the original submission, by revising the allegation categories, decompressing the graph (making it wider) and specifying the axes for each series, respectively.
