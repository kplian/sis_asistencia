CREATE OR REPLACE FUNCTION asis.array_sort (
  pg_catalog.anyarray
)
RETURNS pg_catalog.anyarray AS
$body$
SELECT ARRAY(
    SELECT $1[s.i] AS "foo"
    FROM
        generate_series(array_lower($1,1), array_upper($1,1)) AS s(i)
    ORDER BY foo
);
$body$
LANGUAGE 'sql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.array_sort (pg_catalog.anyarray)
  OWNER TO dbaamamani;