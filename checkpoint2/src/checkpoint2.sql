/*Question 1: Are officers with drug/alcohol abuse allegations more or less likely to be disciplined as a
result of the fallout of the allegation, compared with officers with all other kinds of
misconduct allegations? We will visualize this with two pie graphs next to each other,
showing percentage disciplined versus not disciplined in each group.*/

--D/A/M allegations and disciplined = 737
SELECT COUNT (DISTINCT(officer_id))
FROM data_officerallegation
WHERE data_officerallegation.disciplined=True AND data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))

UNION

--D/A/M allegations and NOT disciplined = 880
SELECT COUNT (DISTINCT(officer_id))
FROM data_officerallegation
WHERE data_officerallegation.disciplined=False AND data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))

UNION

--Allegations but NOT in D/A/M and disciplined = 9601
SELECT COUNT (DISTINCT(officer_id))
FROM data_officerallegation
WHERE data_officerallegation.disciplined=True AND data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))

UNION

--Allegations but NOT in D/A/M and NOT disciplined = 21797
SELECT COUNT (DISTINCT(officer_id))
FROM data_officerallegation
WHERE data_officerallegation.disciplined=False AND data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))


/*2. Is the frequency of drug/alcohol abuse allegations versus all other allegations changing
over time? We will visualize this with a connected scatterplot.*/

--Years for allegations with drug/alcohol and medical violations
SELECT SUBSTRING(cast(start_date as varchar(100)),1, 4) as year_drugalcmed
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024')
    OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('003', '003A', '003B', '003C', '003D', '003E'));

--Years for all allegations
SELECT SUBSTRING(cast(start_date as varchar(100)),1, 4) as year_other
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    );
