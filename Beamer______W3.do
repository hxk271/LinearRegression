*Q5 (opposition to mask exports)

	*Mask and social distancing
	use "data/dfile_2699", clear
	
	*descriptive statistics
	describe        //check how many variables and observations are in the data
	summarize q5_n?
	
	*frequency distribution table
	tab1 q5_n?, miss
	
	*composite variable
	gen oppose=q5+q5_n2+q5_n3+q5_n4+q5_n5

	*histogram
	histogram oppose

	*scatterplot
	graph twoway scatter oppose sq3, jitter(10)
	graph twoway lfit oppose sq3
	graph twoway (scatter oppose sq3, jitter(10)) (lfit oppose sq3)

	
	

*Q4 (in favor of 5-day rotation policy)
	
	*descriptive statistics
	summarize q4 q4_n2 q4_n3

	*frequency distribution table
	tab1 q4 q4_n2 q4_n3, miss
	
	*reverse coding
	gen q4r=1 if q4==5
	replace q4r=2 if q4==4
	replace q4r=3 if q4==3
	replace q4r=4 if q4==2
	replace q4r=5 if q4==1	
	
	recode q4_n2 (5=1) (4=2) (3=3) (2=4) (1=5), generate(q4_n2r)
	
	gen q4_n3r=6-q4_n3
	
	*composite variable
	gen fdrp=q4r+q4_n2r+q4_n3r

	*histogram
	histogram fdrp

	
	
	
	
	
	
	
*World Values Survey

	*download the data from the official website
	use "data/WVS_Cross-National_Wave_7_stata_v2_0", clear

	*descriptive statistics
	describe        //check how many variables and observations are in the data
	summarize Q154 Q155

	*first and second choices
	tab Q154, miss
	tab Q154, nolabel
	tab Q155, miss
	tab Q155, nolabel

	*post-materialist values (3=post-materialist; 2=mixed; 1=materialist)
	gen pmv=0
	replace pmv=3 if (Q154==2 | Q154==4) & (Q155==2 | Q155==4)
	replace pmv=1 if (Q154==1 | Q154==3) & (Q155==1 | Q155==3)
	replace pmv=2 if (Q154==2 | Q154==4) & (Q155==1 | Q155==3)
	replace pmv=2 if (Q154==1 | Q154==3) & (Q155==2 | Q155==4)
	replace pmv=. if Q154<0 | Q155<0

	*histogram
	histogram pmv, bin(3)

	*check with the pre-existing variable
	tab pmv Y002, miss

	*survey weights (https://www.worldvaluessurvey.org/WVSContents.jsp?CMSID=WEIGHT&CMSID=WEIGHT)
	lookfor weight
	tab pwght
	
	*save as new file
	save "data/wvs_pmv", replace
		
		
	
	
	
	
	
	
*World Bank GDP data

	*download the file from the WB website
	import delimited using "Data/gdp.csv", clear rowrange(2) varnames(1)

	*descriptive statistics
	describe        //check how many variables and observations are in the data

	*transforming string to numerical and histogram
	destring yr2019, generate(gdp) force
	histogram gdp, bin(30)

	*save as new file
	save "data/wb_gdp", replace
		
		
		
		
	
	
*practice 1:1 merge

	*setup
	webuse autosize, clear
	list
	save "data/autosize", replace
	webuse autoexpense, clear
	list
	save "data/autoexpense", replace

	*Perform 1:1 match merge
	use "data/autosize", clear
	merge 1:1 make using "data/autoexpense"
	tab _merge

	*keeping only matches and squelching the _merge
	use "data/autosize", clear
	merge 1:1 make using "data/autoexpense", keep(match)
	tab _merge

	

*practice m:1 merge
	
    *setup
	webuse dollars, clear
	list
	save "data/dollars", replace
	webuse sforce
	list
	save "data/sforce", replace

	*Perform m:1 match merge with sforce in memory
	merge m:1 region using "data/dollars"
	list

	

	

	
*practice 1:m merge

	*setup
	webuse overlap1, clear
	list, sepby(id)
	save "data/overlap1", replace
	webuse overlap2
	list
	save "data/overlap2", replace

	*Perform 1:m match merge with update replace
	use "data/overlap2", clear
	merge 1:m id using "data/overlap1", update replace
	list
	
	
	
	
	
*Merge the World Values Survey data with World Bank data
	
	*make sure you've the code above
	use "data/wb_gdp", clear
	de               //double check if country code is what you are looking for
	use "data/wvs_pmv", clear
	ren B_COUNTRY_ALPHA countrycode
	keep B_COUNTRY countrycode pmv
	
	*three dummy variables
	tab pmv, generate(value)
	describe pmv value*

	*aggregate value categories by country
	collapse (mean) value1 value2 value3, by(countrycode)

	*merging WVS data with WB data
	merge m:1 countrycode using "data/wb_gdp"      //non-matched n=1,390
	drop if _merge==1 | _merge==2

	*scatterplot of value types and national wealth
	graph twoway (scatter value1 gdp) (lfit value1 gdp)
	graph twoway (scatter value2 gdp) (lfit value2 gdp)
	graph twoway (scatter value3 gdp) (lfit value3 gdp)
	 
	 
	 

	 
*KELS 2005

	*
	cd "Data\LQ400000115"
	import delimited using "Y1_STD_EDU.csv", clear
	describe        //check how many variables and observations are in the data
	
	*self-regulated learning (y1l3_1 y1l3_2 y1l3_3 y1l3_4)
	summarize y1l3_?
	tab1 y1l3_?, mis
	replace y1l3_1=. if y1l3_1==-1
	replace y1l3_2=. if y1l3_2==-1
	replace y1l3_3=. if y1l3_3==-1
	replace y1l3_4=. if y1l3_4==-1
	gen srl=y1l3_1+y1l3_2+y1l3_3+y1l3_4
	histogram srl, bin(13)
	
	*exam score (Y1KOR_S Y1ENG_S Y1MAT_S)
	summarize y1???_s
	tab1 y1???_s
	replace y1kor_s=. if y1kor_s==-1
	replace y1eng_s=. if y1eng_s==-1
	replace y1mat_s=. if y1mat_s==-1
	gen score=y1kor_s+y1eng_s+y1mat_s
	histogram score
	
	*more beautiful scatterplot
	graph twoway scatter score srl, jitter(30) msymbol(oh)
	graph twoway lfit score srl
	graph twoway (scatter score srl, jitter(10) msymbol(oh)) ///
	             (lfit score srl)
	graph twoway (scatter score srl, jitter(10) msymbol(oh)) ///
	             (lfit score srl),                           ///
				 xtitle("Self-regulated learning")           ///
				 ytitle("Exam score (total)") legend(off)
	
	
	
	
	
	
	
	
	
	
	