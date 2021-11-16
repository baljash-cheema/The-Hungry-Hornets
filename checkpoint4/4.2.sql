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

----------HOORAY!

-----THEIR QUERY
SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1 JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC;
-----THEIR QUERY

SELECT da1.officer_id src, da2.officer_id dst, COUNT(DISTINCT da1.allegation_id) relationship
FROM data_officerallegation da1 JOIN data_officerallegation da2 ON da1.allegation_id = da2.allegation_id AND da1.officer_id < da2.officer_id
WHERE da1.allegation_id AND da2.allegation_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))
GROUP BY da1.officer_id, da2.officer_id ORDER BY count(*) DESC;

--can we make something like the above work?

--Award data for all officers with DAM allegations
--Can we have this vary over time?
SELECT *
FROM data_award
WHERE data_award.officer_id IN
    (SELECT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--Data on officer salary for those with DAM allegations
SELECT *
FROM data_salary
WHERE data_salary.officer_id IN
    (SELECT id
     FROM data_officer
     WHERE data_officer.id IN
        (SELECT officer_id
        FROM data_officerallegation
        WHERE data_officerallegation.allegation_category_id IN
            (SELECT id
             FROM data_allegationcategory
             WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
             OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--Data on those officers with DAM
SELECT *
FROM data_officer
WHERE data_officer.id IN
    (SELECT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--Crew id's for all DAM complaints
SELECT crew_id
FROM data_officercrew
WHERE data_officercrew.officer_id IN
    (SELECT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--Data on all these crews
SELECT *
FROM data_crew
WHERE data_crew.id IN
    (SELECT crew_id
    FROM data_officercrew
    WHERE data_officercrew.officer_id IN
        (SELECT officer_id
        FROM data_officerallegation
        WHERE data_officerallegation.allegation_category_id IN
          (SELECT id
          FROM data_allegationcategory
          WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
          OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))));

--Alderman data -> many nulls
SELECT alderman
FROM data_area
WHERE alderman IS NOT NULL and data_area.id IN
  (SELECT area_id
  FROM data_allegation_areas
  WHERE data_allegation_areas.allegation_id IN
    (SELECT DISTINCT(allegation_id)
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))));

--Can also link it to commander id -> many nulls
SELECT *
FROM data_officer
WHERE data_officer.id in
  (SELECT commander_id
  FROM data_area
  WHERE commander_id IS NOT NULL and data_area.id IN
    (SELECT area_id
    FROM data_allegation_areas
    WHERE data_allegation_areas.allegation_id IN
      (SELECT DISTINCT(allegation_id)
      FROM data_officerallegation
      WHERE data_officerallegation.allegation_category_id IN
        (SELECT id
        FROM data_allegationcategory
        WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
        OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))));

--Same kind of thing but linking to police headquarter id
SELECT police_hq_id
FROM data_area
WHERE police_hq_id is not null and data_area.id IN
  (SELECT area_id
  FROM data_allegation_areas
  WHERE data_allegation_areas.allegation_id IN
    (SELECT DISTINCT(allegation_id)
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))));


---one option is area type (beat, ward, neighborhoods, community, police-districts,school-grounds)

--distinct lawsuits filed against officers with DAM complaints
SELECT distinct(primary_cause)
FROM lawsuit_lawsuit
WHERE lawsuit_lawsuit.id in
(SELECT lawsuit_id
FROM lawsuit_lawsuit_officers
WHERE lawsuit_lawsuit_officers.officer_id IN
    (SELECT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))));


---not sure what this is doing but gives a ton of output
      SELECT *
      FROM data_officerassignmentattendance
      WHERE data_officerassignmentattendance.officer_id IN
          (SELECT officer_id
              FROM data_officerallegation
              WHERE data_officerallegation.allegation_category_id IN
                (SELECT id
                FROM data_allegationcategory
                WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
                OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));
