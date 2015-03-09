use EbolaQC

/*
Check for probable cases where the place of death is hospital or blank. this should never happen
103 means dd/yy/yyyy
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, PlaceDeath
 from DBExtractView
 where epicasedef in (2)
	and Isnull(PlaceDeath, -1) in (-1,2)
 order by DateReport desc

