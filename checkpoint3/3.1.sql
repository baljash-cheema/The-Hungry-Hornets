DROP TABLE IF EXISTS spatial_temp;
CREATE TEMPORARY TABLE spatial_temp AS (
    SELECT da_point.most_common_category_id,da_point.crid, da_point.point AS crid_point, da_area.name AS area_name, da_area.area_type AS area_type
    FROM data_allegation da_point, data_area da_area
    WHERE ST_Contains(da_area.polygon, da_point.point) and area_type ='neighborhoods'
);

SELECT * FROM spatial_temp;

select distinct area_name, count(area_name) from spatial_temp where most_common_category_id
in (select allegation_category_id from data_officerallegation
where allegation_category_id
in
(SELECT id
        FROM data_allegationcategory
        WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' or allegation_name LIKE 'Medical Roll%'
        OR data_allegationcategory.category_code IN ('024', '003', '003A', '003B', '003C', '003D', '003E')))
group by area_name;