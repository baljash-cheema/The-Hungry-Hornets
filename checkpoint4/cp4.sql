/*
Question 1:
Among officers who have drug & alcohol abuse and medical allegations against them,
what is the general co-accusal pattern? Specifically, how often are these
officers co-accusers alongside other officers?
*/

DROP TABLE IF EXISTS da_category_ids;
CREATE TEMP TABLE da_category_ids AS (
    SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'));

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

/*
Question 2:
Among officers who have drug & alcohol abuse and medical allegations against them,
how does the co-accusal pattern compare between officers who earn above and below the average annual salary, respectively?
*/

--Salary greater than average
DROP TABLE IF EXISTS da_category_ids;
CREATE TEMP TABLE da_category_ids AS (
    SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'));

DROP TABLE IF EXISTS da_cohort;
CREATE TEMP TABLE da_cohort AS (
    SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE allegation_category_id IN (SELECT * from da_category_ids));

DELETE FROM da_cohort c
USING data_salary s WHERE s.officer_id = c.officer_id
AND s.salary > (SELECT AVG(salary) FROM data_salary);

DROP TABLE IF EXISTS class_example;
CREATE TEMP TABLE class_example AS (
SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1
JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC);

SELECT * FROM class_example
JOIN da_cohort ON da_cohort.officer_id = class_example.src;

--Salary less than average
DROP TABLE IF EXISTS da_category_ids;
CREATE TEMP TABLE da_category_ids AS (
    SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'));

DROP TABLE IF EXISTS da_cohort;
CREATE TEMP TABLE da_cohort AS (
    SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE allegation_category_id IN (SELECT * from da_category_ids));

DELETE FROM da_cohort c
USING data_salary s WHERE s.officer_id = c.officer_id
AND s.salary < (SELECT AVG(salary) FROM data_salary);

DROP TABLE IF EXISTS class_example;
CREATE TEMP TABLE class_example AS (
SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1
JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC);

SELECT * FROM class_example
JOIN da_cohort ON da_cohort.officer_id = class_example.src;

/*
Question 3:
Among officers who have drug & alcohol abuse and medical allegations against them,
how does the co-accusal pattern compare between more and less decorated officers?
Specifically, how does the co-accusal pattern compare between those with more and less than the average number of awards, respectively?
*/


--Award number greater than average
DROP TABLE IF EXISTS da_category_ids;
CREATE TEMP TABLE da_category_ids AS (
    SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'));

DROP TABLE IF EXISTS da_cohort;
CREATE TEMP TABLE da_cohort AS (
    SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE allegation_category_id IN (SELECT * from da_category_ids));

DELETE FROM da_cohort c
USING data_award a WHERE a.officer_id = c.officer_id
AND count(a.award_type) > (SELECT AVG(count(award_type) FROM data_award);

DROP TABLE IF EXISTS class_example;
CREATE TEMP TABLE class_example AS (
SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1
JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC);

SELECT * FROM class_example
JOIN da_cohort ON da_cohort.officer_id = class_example.src;

--Salary less than average
DROP TABLE IF EXISTS da_category_ids;
CREATE TEMP TABLE da_category_ids AS (
    SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'));

DROP TABLE IF EXISTS da_cohort;
CREATE TEMP TABLE da_cohort AS (
    SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE allegation_category_id IN (SELECT * from da_category_ids));

DELETE FROM da_cohort c
USING data_salary s WHERE s.officer_id = c.officer_id
AND s.salary < (SELECT AVG(salary) FROM data_salary);

DROP TABLE IF EXISTS class_example;
CREATE TEMP TABLE class_example AS (
SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1
JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC);

SELECT * FROM class_example
JOIN da_cohort ON da_cohort.officer_id = class_example.src;
