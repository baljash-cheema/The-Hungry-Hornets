
DROP TABLE IF EXISTS spatial_temp;
CREATE TEMPORARY TABLE spatial_temp AS (
    SELECT da_point.most_common_category_id, da_area.id, da_area.name AS area_name, da_area.area_type AS area_type
    FROM data_allegation da_point, data_area da_area
    WHERE ST_Contains(da_area.polygon, da_point.point) and area_type ='neighborhoods'
);

SELECT * FROM spatial_temp;

DROP TABLE IF EXISTS map;
CREATE TEMPORARY TABLE map AS (
select distinct area_name, count(area_name) from spatial_temp where most_common_category_id
in (select allegation_category_id from data_officerallegation
where allegation_category_id
in
(SELECT id
        FROM data_allegationcategory
        WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
        OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')))
group by area_name);

DROP TABLE IF EXISTS rc;
CREATE TEMPORARY TABLE rc AS (
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
      OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E'))))
);

DROP TABLE IF EXISTS le;
CREATE TEMPORARY TABLE le AS (
select rc.race,rc.count,rc.area_id,data_area.name from rc
 join data_area on rc.area_id=data_area.id);

select * from le;

select map.area_name,map.count,le.race,le.count as people_count from map
join le on le.name=map.area_name;