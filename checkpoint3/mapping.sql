# need to create a table 

SELECT (race, count)
FROM data_racepopulation
WHERE data_racepopulation.area_id
IN (SELECT id
FROM data_area
WHERE data_area.id
IN (SELECT beat_id
FROM data_allegation
WHERE data_allegation.crid
IN (SELECT allegation_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id
IN (SELECT id
FROM data_allegationcategory
WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')))))
