Use EbolaQC

/*
if epicasedef is 1, then SCRes should always be populated
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, DistrictRes, SCRes
 from DBExtractView
 where epicasedef = 1
  and len(isnull(SCRes,'')) = 0
 order by convert(varchar,DateReport,112) desc
