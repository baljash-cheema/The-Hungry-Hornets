src

/*1) Does assignment toward a particular neighborhood yield higher drug/alcohol abuse and medical allegations among officers? This could represent a function of heightened stress. Alternatively, are officers with drug/alcohol abuse allegations more likely to work in certain areas?*/
/* SQL code:*/
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

/*Python code:*/
import numpy as np
import pandas as pd
import datetime

location = []

import json
f = open('Boundaries.geojson',)
df0 = json.load(f)

df1 = pd.read_csv("Result_63.csv")

for x in range(len(df0['features'])):
    y = df0['features'][x]['properties']['pri_neigh']
    for z in range(len(df1['area_name'])):
        if y==str(df1['area_name'][z]):
            df0['features'][x]['properties']['pri_neigh'] = y + ', Number of allegation with Drug and alcohol abuse - ' +str(df1['count'][z])

print(df0['features'][0]['properties']['pri_neigh'])
print(df0['features'][1]['properties']['pri_neigh'])

#dfx=df0.to_json("R.geojson")
with open('R.geojson', 'w') as json_file:
  json.dump(df0, json_file)

/*URL: http://observablehq.com/@41f225c25079d5fe/3-2-map */

/*2) How is the frequency of each type of drug/alcohol and medical abuse allegation varying over time?*/

select data_allegationcategory.allegation_name as text, extract(year from data_officerallegation.start_date) AS Year
from data_officerallegation
full JOIN data_allegationcategory
on data_officerallegation.allegation_category_id=data_allegationcategory.id
where data_officerallegation.allegation_category_id in
(select id from data_allegationcategory where category='Drug / Alcohol Abuse');

/*URL: https://observablehq.com/@41f225c25079d5fe/word-cloud-3-2 */
