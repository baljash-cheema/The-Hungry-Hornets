# The-Hungry-Hornets
Data Science Group for MSAI 339 Fall 2021
By Lili Barsky, Vikram Kharvi, and Josh Cheema (Team
Hungry Hornets)

Project Theme: We would like to explore the relationship between officer compliance with department medical policy including but not limited to incidents of drug and alcohol abuse, with allegations of police misconduct, officer salary and rank, use of force by police, location and type of police work conducted, and distribution of awards given by the department. We will explore these relationships with other aspects of health as the data permits.

For our third checkpoint analyses, we created interactive visualizations to answer the following questions:

1) Does assignment toward a particular neighborhood yield higher drug/alcohol abuse and medical allegations among officers? This could represent a function of heightened stress. Alternatively, are officers with drug/alcohol abuse allegations more likely to work in certain areas? What are the social characteristics of these regions?

We explored this question by creating a heatmap with a toggle in D3, demonstrating in which polygon (s) each drug/alcohol abuse and medical allegation occurred. The polygon values were converted to a set of latitude and longitude coordinates, which were subsequently entered into GeoJSON for geo-localization. For interested viewers and to convey more specific details about the neighborhoods associated with these polygons, we also included the gender and racial composition of these geographic areas. The SQL code under the src directory was utilized to generate the data for this visualization. The URL for the notebook containing the visualization itself can be found within our src directory.

2) How is the frequency of each type of drug/alcohol and medical abuse allegation varying over time? What is the relationship between this trend and the social attributes of the complainants (median salary for officers on the force) over time?

This analysis was visualized using an interactive word cloud, in which viewers can use a scrollbar to see how the word/phrase sizes change over time. In parallel, we display a dynamic color bar, illustrating how average age, gender and race of the complainants (median salary for officers on the force) vary over time. The SQL query utilized to generate the data for this visualization, as well as the URL for the notebook containing the visualization itself, can be found within our src directory.
