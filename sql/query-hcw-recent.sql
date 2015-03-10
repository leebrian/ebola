use EbolaQC

/*
quick query to check recent healthcare workers as confirmed or probable
*/
select DateOnset, DateReport, ID, EpiCaseDef, age, Surname, OtherNames, HCWposition, DistrictRes from DBExtractView
 where HCW = 'True'
 and EpiCaseDef in (1,2)
 order by DateReport desc