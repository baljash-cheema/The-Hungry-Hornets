--category id's from DAM allegations
SELECT id
FROM data_allegationcategory
WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E');

--distinct allegation ids from category ids of DAM -> 1267
SELECT DISTINCT(allegation_id)
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
  (SELECT id
  FROM data_allegationcategory
  WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
  OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'));

--area_ids from those allegation id's -> 5293 of these (464 if area_id distinct)
SELECT *
FROM data_allegation_areas
WHERE data_allegation_areas.allegation_id IN
  (SELECT DISTINCT(allegation_id)
  FROM data_officerallegation
  WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--polygons as strings for those area_ids -> 464
SELECT st_astext(polygon)
FROM data_area
WHERE data_area.id IN
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

--Race, count for those given id's -> 497
SELECT race, count, area_id
FROM data_racepopulation
WHERE data_racepopulation.area_id IN
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

--Geoms for all these id's -> 98
SELECT geom
FROM data_linearea
WHERE data_linearea.id IN
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

--these are all beat names from these allegations
--in data_area, names of areas are either neighborhoods or beats (given by number)
--i mapped those beat numbers to beat names
--so if we combine the output from both, we have a list of names
SELECT DISTINCT(unit_description)
FROM data_policebeat
WHERE data_policebeat.beat_name IN
    (SELECT name
    FROM data_area
    WHERE data_area.id IN
      (SELECT area_id
      FROM data_allegation_areas
      WHERE data_allegation_areas.allegation_id IN
        (SELECT DISTINCT(allegation_id)
        FROM data_officerallegation
        WHERE data_officerallegation.allegation_category_id IN
          (SELECT id
          FROM data_allegationcategory
          WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
          OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')))));

--all names of areas with these allegations, including beat numbers for many
SELECT name
FROM data_area
WHERE data_area.id IN
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

--date of allegations
SELECT incident_date
FROM data_allegation
WHERE data_allegation.crid IN
  (SELECT DISTINCT(allegation_id)
  FROM data_officerallegation
  WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));
