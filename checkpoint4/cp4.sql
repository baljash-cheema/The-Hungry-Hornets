-- CODE QUESITON 1
DROP TABLE IF EXISTS da_category_ids;
CREATE TEMP TABLE da_category_ids AS (
    SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E')
);

DROP TABLE IF EXISTS da_cohort;
CREATE TEMP TABLE da_cohort AS (
    SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE allegation_category_id IN (SELECT * from da_category_ids));

DROP TABLE IF EXISTS class_example;
CREATE TEMP TABLE class_example AS (
SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1
JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC);

SELECT * FROM class_example
JOIN da_cohort ON da_cohort.officer_id = class_example.src;


--officers with same allegation catergories id's

SELECT da1.officer_id, da2.officer_id, da2.allegation_category_id
FROM data_officerallegation da1
JOIN data_officerallegation da2 ON da1.allegation_category_id = da2.allegation_category_id AND da1.officer_id < da2.officer_id
WHERE da2.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))
    GROUP BY da1.officer_id, da2.officer_id, da2.allegation_category_id ORDER BY count(*) DESC;

--condensed
SELECT da1.officer_id, da2.officer_id, da2.allegation_category_id FROM data_officerallegation da1 JOIN data_officerallegation da2 ON da1.allegation_category_id = da2.allegation_category_id AND da1.officer_id < da2.officer_id WHERE da2.allegation_category_id IN (SELECT id FROM data_allegationcategory WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%' OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')) GROUP BY da1.officer_id, da2.officer_id, da2.allegation_category_id ORDER BY count(*) DESC;

--THIS JOINS OFFICERS WHO HAVE DAM ALLEGATIONS

SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1
JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
WHERE da2.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC;

--condensed to get on graphx
SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship FROM data_officerallegation da1 JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id WHERE da2.allegation_category_id IN (SELECT id FROM data_allegationcategory WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%' OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')) GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC;


/*
Is there a link between award winning and race, among officers who have drug and
alcohol abuse allegations? Is it that certain race groups win more or less awards?
We will investigate this by creating a graph, with officers represented as nodes
and links between officers (edges) as race groups. Officers nodes will be color coded
by the number of awards they have won. If patches of one particular color stand out
among connected officers, this will suggest a particular predilection for award
winning among race groups.
*/

--Award data
SELECT *
FROM data_award
WHERE data_award.officer_id IN
  (SELECT id
  FROM data_officer
  WHERE data_officer.id IN
    (SELECT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))));

--Race data
SELECT id, race
FROM data_officer
WHERE data_officer.id IN
  (SELECT officer_id
  FROM data_officerallegation
  WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--The above two queries use officer id


/*
Is there a link between salary and gender, among officers who have drug and
alcohol abuse allegations? Is it that men or women are more likely to continue to move
up the ranks and make money in the police department, even with drug and alcohol
abuse allegations? We will investigate this by creating a graph, with officers represented as nodes
and links between officers (edges) as gender. Officers nodes will be sized in proportion
to their salary pay grade.
*/

SELECT *
FROM data_salary
WHERE data_salary.officer_id IN
  (SELECT DISTINCT(officer_id)
  FROM data_officerallegation
  WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--There are 10 distinct pay grades above
--Many officers have more than 1 paygrade entered. We can choose only highest.
--Or we can use highest salary.
