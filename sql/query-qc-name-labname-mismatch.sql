Use EbolaQC

/*
Check for name mismatches between case and lab
It's ok to have transpositions, but not complete mismatches
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, FinalLabClass,sampleinterpret1, surnamelab1, othernamelab1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7
 from DBExtractView
 where
	surname != surnamelab1
	or othernames != othernamelab1
 order by datereport desc