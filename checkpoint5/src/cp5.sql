DROP TABLE IF EXISTS da_category_ids;
CREATE TEMP TABLE da_category_ids AS (
  (SELECT data_officerallegation.id,data_allegationcategory.allegation_name,data_allegationcategory.category
  FROM data_officerallegation
  JOIN data_allegationcategory ON data_officerallegation.allegation_category_id = data_allegationcategory.id
  WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' OR allegation_name LIKE 'Medical Roll%'
  OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')));

SELECT gender,race,birth_year,first_name || ' ' || last_name officer_name,allegation_count,sustained_count,current_salary
FROM data_officer
JOIN da_category_ids ON data_officer.id=da_category_ids.id
WHERE data_officer.current_salary IS NOT NULL AND allegation_count>2 AND sustained_count>1
