--Gives all officers who have DAM allegations
SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
  (SELECT id
  FROM data_allegationcategory
  WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
  OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'));


--Race, gender, age (of who?) related to DAM allegations 
SELECT race, gender, age
FROM data_complainant
WHERE data_complainant.allegation_id
IN
  (SELECT crid
  FROM data_allegation
  WHERE data_allegation.crid
  IN
    (SELECT allegation_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id
    IN
      (SELECT id
      FROM data_allegationcategory
      WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))));
