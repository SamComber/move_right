SELECT schools.cartodb_id, MIN(ST_Distance(schools.the_geom, imd_1.the_geom)) as MinDistance FROM schools, imd_1 GROUP BY schools.cartodb_id


SELECT c.cartodb_id,
ST_Distance(
    c.the_geom, 
    (SELECT the_geom FROM imd_1 ORDER BY the_geom <-> c.the_geom LIMIT 1)
) as MinDistance
FROM schools c

SELECT *, ST_Distance(the_geom::geography, (SELECT the_geom FROM polygon_near)) as distance_to_polygon from points_near

SELECT ST_x(st_centroid(the_geom)) as lon, ST_y(st_centroid(the_geom)) as lat FROM imd_1


-- distance to railway stations
SELECT imd_2.cartodb_id, ROUND(MIN(ST_Distance_Sphere(imd_2.the_geom, railway.the_geom))::numeric, 0) as railway_dist FROM imd_2, railway GROUP BY imd_2.cartodb_id

-- distance to schools
SELECT c.cartodb_id,
ROUND(ST_Distance_Sphere(
    c.the_geom, 
    (SELECT the_geom FROM schools ORDER BY the_geom <-> c.the_geom LIMIT 1)
)::numeric, 0) as school_dist
FROM imd_2 c



ALTER TABLE  imd_2 ADD COLUMN min_schools double precision;

UPDATE imd_2 SET min_schools = 
  (SELECT ROUND(MIN(ST_Distance_Sphere(imd_2.the_geom, railway.the_geom))::numeric, 0) as railway_dist FROM imd_2, railway 
   WHERE imd_2.cartodb_id = railway.cartodb_id
   GROUP BY imd_2.cartodb_id)


UPDATE imd_2 SET voaage_m_1 = replace(voaage_m_1, '_', ' ')
