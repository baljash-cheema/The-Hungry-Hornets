--officer id's involved in DAM complaints
SELECT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
  (SELECT id
  FROM data_allegationcategory
  WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
  OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'));

--salary, pay grade for officers in these complaints
SELECT salary, pay_grade
FROM data_salary
WHERE data_salary.officer_id IN
  (SELECT officer_id
  FROM data_officerallegation
  WHERE data_officerallegation.allegation_category_id
  IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

--race, gender, composition
SELECT gender, race, birth_year
FROM data_complainant
WHERE data_complainant.allegation_id IN
  (SELECT allegation_id
  FROM data_officerallegation
  WHERE data_officerallegation.allegation_category_id
  IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
    OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));
