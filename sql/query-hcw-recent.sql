use EbolaQC

/*
check the total number of confirmed HCW cases, this shows in the sitrep and is a nice quick sanity check
*/
select count(*)
 from DBExtractView
 where HCW = 'True'
 and EpiCaseDef in (1)

/*
quick query to check recent healthcare workers as confirmed or probable
*/
select DateOnset, DateReport, ID, EpiCaseDef, age, Surname, OtherNames, HCWposition, DistrictRes from DBExtractView
 where HCW = 'True'
 and EpiCaseDef in (1,2,3)
 order by DateReport desc