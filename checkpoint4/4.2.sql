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
