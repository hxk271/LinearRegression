*Descriptive Statistics Practice I

	*importing CSV (comma-separated values) data file
	import delimited using "sociology.csv", clear rowrange(4)
	save "sociology.dta", replace

	*importing SPSS data file
	import spss using "2003-2018_KGSS_public_v3.sav", clear
	save "2003-2018_KGSS_public_v3.dta", replace

	*hunting for variables of interest
	describe
	describe HAP*
	describe HAP??
	describe *HAP*
	lookfor 행복

	*investigate and recode the variable of interest
	tab HAPPY
	tab HAPPY, nolabel
	recode HAPPY (4=1) (3=2) (2=3) (1=4) (-8=.), gen(happiness)
	tab HAPPY happiness

	*select a sub-sample
	tab YEAR
	keep if YEAR==2018
	keep MARITAL happiness

	*summarize a variable by another variable
	by MARITAL, sort: summarize happiness
	bysort MARITAL: summarize happiness

	generate date = date(v1, "YM")
	format date %td




*Descriptive Statistics Practice II

	*re-load Stata file
	use "2003-2018_KGSS_public_v3.dta", clear

	*select a sub-sample, once again
	keep if YEAR==2018
	recode HAPPY (4=1) (3=2) (2=3) (1=4) (-8=.), gen(happiness)
	lookfor 성별
	tab SEX
	tab SEX, nolabel miss
	keep MARITAL SEX happiness

	*summarize a variable by another variable
	bysort MARITAL: summarize happiness if SEX==1   //male
	bysort MARITAL: summarize happiness if SEX==2   //female

	*rename variables
	rename MARITAL marital
	rename *, lower

	*Repeat the above procedure but with a different variable.



*Descriptive Statistics Practice III

	*create a new variable
	tab marital
	tab marital, nolabel
	numlabel, add       //will take time for a reason
	tab marital
	generate together=marital==1|marital==6
	replace together=. if marital==-8

	*assign a label to the new variable
	label define newmar 1 "같이" 0 "따로", replace
	label value together newmar
	label variable together "같이 혹은 따로"
	tab marital together
	tab marital together, miss


	*summarize a variable by another variable
	bysort together: summarize happiness
	bysort together: summarize happiness if sex==1   //male
	bysort together: summarize happiness if sex==2   //female


