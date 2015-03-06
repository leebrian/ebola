/*
QC Checks
Reads in the daily extract Excel file and performs a number of checks for data management to review
Note: imports csv rather than Excel as stata8 doesn't support excel import

Rules:
#01-if epicasedef is non, probable or suspect (0,2,3) then there should be no confirmed labs
#02-if epicasedef is non, probable or suspect (0,2,3) then finallabclass should not be 1
#03-if epicasedef is confirmed (1), then there should be at least one confirmed lab specimin 
#04-if epicasedef is probable (2), then the patient should not be alive (finalstatus=2)
#05-if epicasedef is probable (2), then death location should not be blank or hospital (2)
#06-if finalstatus is alive (2), then deathdate should always be blank
#07-if finalstatus is alive (2), then placedeath should always be blank
#08-datehospitalcurrentadmit should never be beyond datedeath
#09-dateonset should never be beyond datedeath
#10-dateonset should never be beyond dateisolationcurrent
#11-dateonset should never be beyond datereport
#12-dateonset should never be beyond datesamplecollectedX
#13-dateonset should never be beyond datesampletestedX

*/

clear

cd c:\data

*this gets created manually
insheet using Database_Extraction_2015_03_05-smalled.csv

*we don't care about excluded and maisson de transmission
drop if epicasedef==4 | epicasedef==5

*format dates that are strings from csv as dates for comparison
generate datereport_calc = date(datereport, "mdy")
generate datedeath_calc = date(datedeath, "mdy")
generate dateonset_calc = date(dateonset, "mdy")
generate datehospitalcurrentadmit_calc = date(datehospitalcurrentadmit, "mdy")
generate dateisolationcurrent_calc = date(dateisolationcurrent, "mdy")
generate datesamplecollected1_calc = date(datesamplecollected1, "mdy")
generate datesampletested1_calc = date(datesampletested1, "mdy")
generate datesamplecollected2_calc = date(datesamplecollected2, "mdy")
generate datesampletested2_calc = date(datesampletested2, "mdy")
generate datesamplecollected3_calc = date(datesamplecollected3, "mdy")
generate datesampletested3_calc = date(datesampletested3, "mdy")
generate datesamplecollected4_calc = date(datesamplecollected4, "mdy")
generate datesampletested4_calc = date(datesampletested4, "mdy")
generate datesamplecollected5_calc = date(datesamplecollected5, "mdy")
generate datesampletested5_calc = date(datesampletested5, "mdy")
generate datesamplecollected6_calc = date(datesamplecollected6, "mdy")
generate datesampletested6_calc = date(datesampletested6, "mdy")
generate datesamplecollected7_calc = date(datesamplecollected7, "mdy")
generate datesampletested7_calc = date(datesampletested7, "mdy")







*save off a prepped data set for use by each rule
save daily.dta, replace


*rule #01 - Should be confirmed case if a lab sample has result of 1
keep if epicasedef==0|epicasedef==2|epicasedef==3
keep if sampleinterpret1==1|sampleinterpret2==1|sampleinterpret3==1|sampleinterpret4==1|sampleinterpret5==1|sampleinterpret6==1|sampleinterpret7==1
generate regle="#01: Au moins d'un specimin Lab positif, mais epicasedef in 0,2,3"
save temp-qc.dta, replace

*rule #02 - Should be confirmed case if finallabclass is 1
use daily.dta, clear
keep if epicasedef==0|epicasedef==2|epicasedef==3
keep if finallabclass==1
generate regle="#02: FinalLabClass est 1, mais epicasedef in 0,2,3"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #03 - Should not be confirmed case if no confirmed labs
use daily.dta, clear
keep if epicasedef==1
keep if sampleinterpret1!=1&sampleinterpret2!=1&sampleinterpret3!=1&sampleinterpret4!=1&sampleinterpret5!=1&sampleinterpret6!=1&sampleinterpret7!=1
generate regle="#03: Cas confirme, mais rein de specimin positif"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #04 - Should not be probable with final status alive
use daily.dta, clear
keep if epicasedef==2
keep if finalstatus==0
generate regle="#04: Cas probable, mais personne est vivant"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #05 - Should not be probable with a death location not in the community
use daily.dta, clear
keep if epicasedef==2
keep if placedeath!=1
generate regle="#05: Cas probable, mais location de dece ce n'est pas community"
save temp-qc.dta, replace

*rule #06 - Should not be alive with a death date
use daily.dta, clear
keep if finalstatus==2
keep if !missing(datedeath)
generate regle="#06: Personne est vivant, mais date de deces n'est pas vide"
save temp-qc.dta, replace

*rule #07 - Should not be alive with a death place
use daily.dta, clear
keep if finalstatus==2
keep if !missing(placedeath)
generate regle="#07: Personne est vivant, mais place de deces n'est pas vide"
save temp-qc.dta, replace

*rule #08 - DateHospitalCurrentAdmit should not be beyond DateDeath
use daily.dta, clear
keep if !missing(datehospitalcurrentadmit)
keep if !missing(datedeath)
keep if datehospitalcurrentadmit_calc > datedeath_calc
generate regle="#08: Date d'admis a l'hopital est plus que date de deces"
save temp-qc.dta, replace

*rule #09 - DateOnset should not be beyond DateDeath
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datedeath_calc
generate regle="#09: Date de debut des signes est plus que date de deces"
save temp-qc.dta, replace

*rule #10-datesonet should never be beyond dateisolationcurrent
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > dateisolationcurrent_calc
generate regle="#10: Date de debut des signes est plus que date l'isolement"
save temp-qc.dta, replace

*rule #11-datesonet should never be beyond datereport
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datereport_calc
generate regle="#11: Date de debut des signes est plus que date de la report"
save temp-qc.dta, replace

*rule #12-datesonet should never be beyond sample collected dates
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datesamplecollected1_calc|dateonset_calc > datesamplecollected2_calc|dateonset_calc > datesamplecollected3_calc|dateonset_calc > datesamplecollected4_calc|dateonset_calc > datesamplecollected5_calc|dateonset_calc > datesamplecollected6_calc|dateonset_calc > datesamplecollected7_calc
generate regle="#12: Date de debut des signes est plus que date de la lab specimin collectées"
save temp-qc.dta, replace

*rule #13-datesonet should never be beyond sample tested dates
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datesampletested1_calc|dateonset_calc > datesampletested2_calc|dateonset_calc > datesampletested3_calc|dateonset_calc > datesampletested4_calc|dateonset_calc > datesampletested5_calc|dateonset_calc > datesampletested6_calc|dateonset_calc > datesampletested7_calc
generate regle="#13: Date de debut des signes est plus que date de la lab specimin testé"
save temp-qc.dta, replace
 



*only keep useful fields for qc
keep id epicasedef surname othernames age gender districtres placedeath finallabclass sampleinterpret1 sampleinterpret2 sampleinterpret3 sampleinterpret4 sampleinterpret5 sampleinterpret6 sampleinterpret7 regle

*put rule first
order regle id epicasedef surname othernames age gender districtres placedeath finallabclass sampleinterpret1 sampleinterpret2 sampleinterpret3 sampleinterpret4 sampleinterpret5 sampleinterpret6 sampleinterpret7
sort regle

outsheet using pour-examen.csv , comma replace

