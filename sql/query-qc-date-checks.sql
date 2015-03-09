Use EbolaQC

/*
check for records where date hospital admit is greater than date of death. this should never happen
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, PlaceDeath, datehospitalcurrentadmit, DateDeath, finalstatus
 from DBExtractView
 where 
 datehospitalcurrentadmit  > DateDeath
 order by ID asc--, DateReport desc

/*
check for records where date onset of symptoms is greater than date of death. this should never happen
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, PlaceDeath, DateOnset, DateDeath, finalstatus
 from DBExtractView
 where DateOnset > DateDeath
 order by DateReport desc

 /*
 check if onsetdate is greater than isolation date. this should never happen
 */
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, DateOnset, DateIsolationCurrent, DateDeath, finalstatus
 from DBExtractView
 where DateOnset > DateIsolationCurrent
 order by DateReport desc


 /*
 check if onsetdate is greater than date report. this should never happen
 */
 select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, DateOnset, DateIsolationCurrent, DateDeath, finalstatus
 from DBExtractView
 where DateOnset > DateReport
 order by DateReport desc

  /*
 check if onset date is greater than sample collected date of any lab. this should never happen
  */
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, DateOnset, DateIsolationCurrent, DateDeath, finalstatus, DateSampleTested1, DateSampleTested2, DateSampleTested3, DateSampleTested4, DateSampleTested5, DateSampleTested6, DateSampleTested7
 from DBExtractView
 where DateOnset > DateSampleCollected1 
	or DateOnset > DateSampleCollected2  
	or DateOnset > DateSampleCollected3 
	or DateOnset > DateSampleCollected4 
	or DateOnset > DateSampleCollected5 
	or DateOnset > DateSampleCollected6 
	or DateOnset > DateSampleCollected7
 order by DateReport desc

 /*
 check if onset date is greater than sample tested date of any lab. this should never happen
  */
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, DateOnset, DateIsolationCurrent, DateDeath, finalstatus, DateSampleTested1, DateSampleTested2, DateSampleTested3, DateSampleTested4, DateSampleTested5, DateSampleTested6, DateSampleTested7
 from DBExtractView
 where DateOnset > DateSampleTested1 
	or DateOnset > DateSampleTested2  
	or DateOnset > DateSampleTested3 
	or DateOnset > DateSampleTested4 
	or DateOnset > DateSampleTested5 
	or DateOnset > DateSampleTested6 
	or DateOnset > DateSampleTested7
 order by DateReport desc

 /*
 check if date report is greater than sample collected date of any lab. this happens a lot. confirm that this is useful test
 */
 select ID, convert(varchar(10),DateReport,103) as "DateReportF", DateReport, DateSampleCollected1, DateSampleTested1, placedeath, epicasedef, surname, othernames, age, gender, DateOnset, DateIsolationCurrent, DateDeath, finalstatus, DateSampleTested2, DateSampleTested3, DateSampleTested4, DateSampleTested5, DateSampleTested6, DateSampleTested7
 from DBExtractView
 where DateReport > DateAdd(dd,0,DateSampleCollected1) 
	or DateReport > DateAdd(dd,0,DateSampleCollected2)  
	or DateReport > DateAdd(dd,0,DateSampleCollected3) 
	or DateReport > DateAdd(dd,0,DateSampleCollected4)
	or DateReport > DateAdd(dd,0,DateSampleCollected5)
	or DateReport > DateAdd(dd,0,DateSampleCollected6) 
	or DateReport > DateAdd(dd,0,DateSampleCollected7)
 order by DateReport desc

 /*
 check if date of sample collected is past date of sample tested. this should never happen
 */
 select ID, convert(varchar(10),DateReport,103) as "DateReportF", DateReport, DateSampleCollected1, DateSampleTested1, placedeath, epicasedef, surname, othernames, age, gender, DateOnset, DateIsolationCurrent, DateDeath, finalstatus, DateSampleCollected2, DateSampleTested2, DateSampleCollected3, DateSampleTested3, DateSampleTested4, DateSampleTested5, DateSampleTested6, DateSampleTested7
 from DBExtractView
 where DateSampleCollected1 > DateSampleTested1 
	or DateSampleCollected2 > DateSampleTested2 
	or DateSampleCollected3 > DateSampleTested3 
	or DateSampleCollected4 > DateSampleTested4 
	or DateSampleCollected5 > DateSampleTested5 
	or DateSampleCollected6 > DateSampleTested6 
	or DateSampleCollected7 > DateSampleTested7 
 order by DateReport desc


 /*
 check if date death is greater than sample collected date of any lab. this should never happen. but what about probables
 this happens quite a bit, confirm with OMS
 */
 select ID, convert(varchar(10),DateReport,103) as "DateReportF", DateReport, DateSampleCollected1, DateDeath, placedeath, epicasedef, surname, othernames, age, gender, DateOnset, DateIsolationCurrent, DateDeath, finalstatus, DateSampleCollected2, DateSampleTested2, DateSampleCollected3, DateSampleTested3, DateSampleTested4, DateSampleTested5, DateSampleTested6, DateSampleTested7
 from DBExtractView
 where --isnull(placedeath,-1) in (2) and
   (DateDeath < DateSampleCollected1 
	or DateDeath < DateSampleCollected2 
	or DateDeath < DateSampleCollected3 
	or DateDeath < DateSampleCollected4 
	or DateDeath < DateSampleCollected5 
	or DateDeath < DateSampleCollected6 
	or DateDeath < DateSampleCollected7 )
 order by DateReport desc

 /*
 check if date isolation is greater than sample date of any lab. this should never happen.
 this is pretty common, confirm with OMS
 */
 select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, DateSampleCollected1, DateIsolationCurrent, DateDeath, finalstatus, DateSampleTested1, DateSampleTested2, DateSampleTested3, DateSampleTested4, DateSampleTested5, DateSampleTested6, DateSampleTested7
 from DBExtractView
 where DateIsolationCurrent > DateSampleCollected1 
	or DateIsolationCurrent > DateSampleCollected2  
	or DateIsolationCurrent > DateSampleCollected3 
	or DateIsolationCurrent > DateSampleCollected4 
	or DateIsolationCurrent > DateSampleCollected5 
	or DateIsolationCurrent > DateSampleCollected6 
	or DateIsolationCurrent > DateSampleCollected7
 order by DateReport desc
