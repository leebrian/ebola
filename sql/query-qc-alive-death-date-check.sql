Use EbolaQC

/*
check for records where person is alive, yet has a datedeath. this should never happen
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, PlaceDeath, DateDeath, finalstatus
 from DBExtractView
 where 
 finalstatus = 2
 and isnull(datedeath,-1) != -1

/*
check for records where person is alive, yet has a placedeath. this should never happen
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, PlaceDeath, DateDeath, placedeath, finalstatus
 from DBExtractView
 where 
 finalstatus = 2
 and isnull(placedeath,-1) != -1