--category id's from DAM allegations
SELECT id
FROM data_allegationcategory
WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E');

--allegation ids from category ids of DAM -> some allegations have multiple associated category id's
SELECT allegation_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
  (SELECT id
  FROM data_allegationcategory
  WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
  OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'));

--area_ids mapping from those allegation id's
SELECT area_id
FROM data_allegation_areas
WHERE data_allegation_areas.allegation_id IN
      (SELECT allegation_id
      FROM data_officerallegation
      WHERE data_officerallegation.allegation_category_id IN
        (SELECT id
        FROM data_allegationcategory
        WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
        OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));


--Race, count for those given id's -> THIS NEEDS TO BE FIXED
SELECT race, count, area_id
FROM data_racepopulation
WHERE data_racepopulation.id IN
  (SELECT area_id
  FROM data_allegation_areas
  WHERE data_allegation_areas.allegation_id IN
        (SELECT allegation_id
        FROM data_officerallegation
        WHERE data_officerallegation.allegation_category_id IN
          (SELECT id
          FROM data_allegationcategory
          WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
          OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--Geoms for all these id's
SELECT geom
FROM data_linearea
WHERE data_linearea.id IN

--polygon as string ->
SELECT st_astext(polygon)
FROM data_area
WHERE data_area.id
IN
