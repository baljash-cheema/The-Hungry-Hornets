select data_allegationcategory.allegation_name as text, extract(year from data_officerallegation.start_date) AS Year
from data_officerallegation
full JOIN data_allegationcategory
on data_officerallegation.allegation_category_id=data_allegationcategory.id
where data_officerallegation.allegation_category_id in
(select id from data_allegationcategory where category='Drug / Alcohol Abuse');