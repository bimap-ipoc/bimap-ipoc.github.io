declare
cursor c is
select to_char(s.startup_time,'dd Mon "at" HH24:mi:ss') instart_fmt
, di.instance_name inst_name
, di.instance_number instance_number
, di.db_name db_name
, di.dbid dbid
, lag (s.snap_id,1,0) over (partition by di.instance_number order by s.snap_id) begin_snap_id
, s.snap_id end_snap_id
, to_char(s.begin_interval_time,'yyyymmddhh24mi') beginsnapdat
, to_char(s.end_interval_time,'yyyymmddhh24mi') endsnapdat
, s.snap_level lvl
from dba_hist_snapshot s
, dba_hist_database_instance di
,gv$instance i
,v$database d
where s.dbid = d.dbid
and di.dbid = d.dbid
and s.instance_number = i.instance_number
and di.instance_number = i.instance_number
and di.dbid = s.dbid
and di.instance_number = s.instance_number
and di.startup_time = s.startup_time
and s.begin_interval_time > trunc(sysdate -7) -- last last 7 days
order by di.db_name, i.instance_name, s.snap_id;
begin
for c1 in c
loop
if c1.begin_snap_id > 0 and c1.beginsnapdat > &1 then
dbms_output.put_line('spool '||c1.inst_name||'_'
||c1.begin_snap_id||'_'||c1.end_snap_id||'_'||c1.beginsnapdat||'_'||c1.endsnapdat||'.html');
dbms_output.put_line('select output from table(dbms_workload_repository.awr_report_html( '||c1.dbid||','||
c1.instance_number||','||
c1.begin_snap_id||','||
c1.end_snap_id||',0 ));');
dbms_output.put_line('spool off');
end if;
end loop;
end;
/
