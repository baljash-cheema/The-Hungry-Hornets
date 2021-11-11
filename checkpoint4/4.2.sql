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
