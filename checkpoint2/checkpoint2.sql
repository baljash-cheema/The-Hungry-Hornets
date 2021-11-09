/*Question 1: What is the frequency of each kind of drug/alcohol abuse and medical allegation made by officers as compared with civilians?*/
WITH da_category_ids AS (
    SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')),
    crids AS
        (SELECT DISTINCT allegation_id FROM data_officerallegation WHERE allegation_category_id IN (SELECT * FROM da_category_ids))
SELECT is_officer_complaint, category, allegation_name, summary
FROM data_officerallegation JOIN crids ON crids.allegation_id = data_officerallegation.allegation_id  -- filter to D&A complaints
    JOIN data_allegationcategory da on data_officerallegation.allegation_category_id = da.id -- get category names
    JOIN data_allegation d ON data_officerallegation.allegation_id = d.crid

/*2. Is the frequency of drug/alcohol abuse allegations versus all other allegations changing
over time? We will visualize this with a connected scatterplot.*/

--Years for allegations with drug/alcohol and medical violations
SELECT SUBSTRING(cast(start_date as varchar(100)),1, 4) as year_drugalcmed
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'));

--Years for all allegations
SELECT SUBSTRING(cast(start_date as varchar(100)),1, 4) as year_other
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'));
