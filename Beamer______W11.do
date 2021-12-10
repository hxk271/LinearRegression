*principal component analysis (1)

	*Scores by Roger de Piles for Renaissance painters
	use "renpainters", clear

	*single princpal component
	graph twoway (scatter composition expression) (lfit composition expression)
	factor composition expression, pcf
	di 0.9529^2 + 0.9529^2           //eigenvalue
	predict pc
	di 0.9529/1.81611   			 //regression-based scoring
	pwcorr pc composition expression

	*two princpal components
	factor composition drawing colour expression, pcf
	di 0.7804^2 + 0.8396^2 + (-0.6242)^2 + 0.8857^2   //eigenvalue
	di 2.48792/(2.48792+1.06280+0.31537+0.13391)      //contribution
	di 1-(0.7804^2 + 0.5419^2)						  //communality and uniqueness
	predict pc1 pc2
	di 0.7804/2.48792   //regression-based scoring
	pwcorr pc1 composition drawing colour expression
	graph twoway (scatter pc2 pc1, mlabel(painter))

	

			   

*principal component analysis (2)

	import delimited using "../data/Y1_STD_EDU.csv", clear
	
	*recoding Xs
	foreach i of varlist y1s3_*  {
		replace `i'=. if `i'<0
		}
		
	*pca
	factor y1s3_*, pcf
 
	*extracting the principal components
	screeplot, yline(1)

	
		
		
	
*rotation

	*Scores by Roger de Piles for Renaissance painters
	use "renpainters", clear

	*orthogonal rotation
	factor composition drawing colour expression, pcf
	rotate
	rotate, blank(.4)
	predict pc1o pc2o
	pwcorr pc1o pc2o
	
	*oblique rotation
	factor composition drawing colour expression, pcf
	rotate, promax(3) blank(.4)
	predict pc1p pc2p
	pwcorr pc1p pc2p
	
	
	
	
	

*rotation and pc extraction

	import delimited using "../data/Y1_STD_EDU.csv", clear
	
	*recoding Xs
	foreach i of varlist y1s3_*  {
		replace `i'=. if `i'<0
		}
		
	*pca 1
	factor y1s3_*, pcf
	rotate
	rotate, blank(.4)
	
	*pca 2
	drop y1s3_27
	factor y1s3_*, pcf
	rotate, blank(.4)
	
	*pca 3
	drop y1s3_8
	factor y1s3_*, pcf
	rotate, blank(.4)
	
	*four principal components
	predict pc1 pc2 pc3 pc4

	*recoding Ys
	foreach i of varlist y1kor_s y1eng_s y1mat_s {
		replace `i'=. if `i'<0
		}
	gen score=y1kor_s+y1eng_s+y1mat_s

	*regress y on principal components
	reg score pc1 pc2 pc3 pc4
		
		
  
	
		
*pca post-estimation

	*
	use "renpainters", clear
	
	*pca
	factor composition drawing colour expression, pcf
	
	*post-estimation
	pwcorr
	//make sure "ssc install factortest"
	factortest composition drawing colour expression
	estat kmo
	
	
	*
	import delimited using "../data/Y1_STD_EDU.csv", clear
	foreach i of varlist y1s3_*  {
		replace `i'=. if `i'<0
		}
	drop y1s3_27 y1s3_8
	factor y1s3_*, pcf
	rotate, blank(.4)
	predict pc1 pc2 pc3 pc4	
	correl y1s3_*
	factortest y1s3_*
	estat kmo
	
		
	
	
	
	
	
	
	
		   
*reliability
		   
	*cronbach's alpha
	use "Data/Fear of Statistics", clear
	alpha q01 q03 q04 q05 q12 q16 q20 q21
	
	*check if there are items to be deleted
	alpha q01 q03 q04 q05 q12 q16 q20 q21, item

	*normalization
	foreach i of varlist q01 q03 q04 q05 q12 q16 q20 q21 {
		qui su `i'
		gen `i'_std=(`i'-r(mean))/r(sd)
		}
	alpha *_std

	*alpha with normalized items
	alpha q01 q03 q04 q05 q12 q16 q20 q21, std



