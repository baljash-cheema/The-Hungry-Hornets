# The-Hungry-Hornets
Data Science Group for MSAI 339 Fall 2021
By Lili Barsky, Vikram Kharvi, and Josh Cheema (Team
Hungry Hornets)

Project Theme: We would like to explore the relationship between officer compliance with department medical policy including but not limited to incidents of drug and alcohol abuse, with allegations of police misconduct, officer salary and rank, use of force by police, location and type of police work conducted, and distribution of awards given by the department. We will explore these relationships with other aspects of health as the data permits.

For our third checkpoint analyses, we created interactive visualizations to answer the following questions:

How to run:
Run the 3.1 sql commands in datagrip and download the csv file and rename it to Result_63.csv.
Download chicago neighbourhood geodata from https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Neighborhoods/bbvz-uum9
Rename the downloaded file as Boundaries.geojson
Now run 3.1.py python file and this should generate R.geojson
Now upload R.geojson to obserable HQ and run

Run the 3.2 sql commands in datagrip and download the csv file and rename it to Result_17.csv.
Now upload Result_17.csv to obserable HQ and run

1) Does assignment toward a particular neighborhood yield higher drug/alcohol abuse and medical allegations among officers? This could represent a function of heightened stress. Alternatively, are officers with drug/alcohol abuse allegations more likely to work in certain areas?

We explored this question by creating an interactive map in D3, in which viewers can hover over each neighborhood in order to see the frequency of drug & alcohol abuse and medical allegation (s). The data_area values associated with drug & alcohol abuse and medical allegations were acquired from DataGrip and entered into a csv. This csv was exported from DataGrip and imported into Pycharm, where GeoJSON code was utilized for geo-localization and mapping. D3 was then employed to generate our interactive map. The SQL and python code within our src directory were utilized to generate the data for this visualization. The URL for the notebook containing the visualization itself can also be found within our src directory.

http://observablehq.com/@41f225c25079d5fe/3-2-map

2) How is the frequency of each type of drug/alcohol and medical abuse allegation varying over time?

This analysis was visualized using an interactive word cloud, in which viewers can use a scrollbar to see how the word/phrase sizes change over time. The SQL query utilized to generate the data for this visualization, as well as the URL for the notebook containing the visualization itself, can be found within our src directory.

https://observablehq.com/@41f225c25079d5fe/word-cloud-3-2
