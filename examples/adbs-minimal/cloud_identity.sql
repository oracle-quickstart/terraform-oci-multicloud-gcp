set HEADING OFF
set FEEDBACK OFF
set PAGESIZE 0
set LINESIZE 1000
set TRIMSPOOL ON
SPOOL cloud_identity.json
select cloud_identity from v$pdbs;
SPOOL OFF
EXIT