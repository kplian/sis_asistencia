CREATE OR REPLACE FUNCTION asis.array_min (
  pg_catalog.anyarray
)
RETURNS pg_catalog.anyelement AS
$body$
SELECT min(x) FROM unnest($1);
$body$
LANGUAGE 'sql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.array_min (pg_catalog.anyarray)
  OWNER TO dbaamamani;