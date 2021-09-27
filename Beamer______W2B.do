*Importing external data files

	*importing CSV (comma-separated values) data file
	import delimited using "data/sociology.csv", clear rowrange(4)
	save "data/sociology.dta", replace

	/*importing SPSS data file (if it works in your Stata)
	import spss using "data/2003-2018_KGSS_public_v3.sav", clear
	save "data/2003-2018_KGSS_public_v3.dta", replace
	*/
	
	
	
	
*Finding variables
	
	*KGSS data
	use "data/2003-2018_KGSS_public_v3.dta", replace
	
	*hunting for variables of interest
	describe
	describe HAP*
	describe HAP??
	describe *HAP*
	lookfor 행복

	*rename variables
	rename MARITAL marital
	rename *, lower


	
	
	
*Select a sub-sample

	tab year
	keep if year==2018
	keep happy marital sex
	order marital sex happy
	
	
	
	
	
*Tabulation and recoding
	
	*tabulate the variable of interest
	tab happy
	tab happy, nolabel
	
	*recode the variable of interest (I)
	gen happy2=.
	replace happy2=1 if happy==4
	replace happy2=2 if happy==3
	replace happy2=3 if happy==2
	replace happy2=4 if happy==1
	tab happy happy2
	
	*recode the variable of interest (II)
	recode happy (4=1) (3=2) (2=3) (1=4) (-8=.), gen(happiness)
	tab happy happiness

	
	
	
	
*Descriptive statistics (I)

	*summarize
	summarize happiness
	summarize happiness, detail
	
	*summarize a variable by another variable
	bysort marital: summarize happiness

	*summarize a variable by another variable, with "if"
	bysort marital: summarize happiness if sex==1   //male
	bysort marital: summarize happiness if sex==2   //female



	
	
	
	
	
*Descriptive statistics (II)

	*create a new variable
	tab marital
	tab marital, nolabel
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


