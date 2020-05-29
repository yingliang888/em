# Data and Codes for "How Pervasive is Earnings Management? Evidence from a Structural Model" by Jeremy Bertomeu, Edwige Cheynel, Edward Xuejun Li and Ying Liang.

The paper can be found on https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3153047

If you have any questions, feel free to contact Ying Liang at nicole.y.liang@gmail.com. 

The studies are conducted using R and Matlab. Please make sure Rstudio and Matlab are installed, and the Optimization Toolbox is installed in Matlab. We use R as it provides nice and easy-to-use splinefit package. The estimations are conducted using Matlab.

Steps:
1. Download the files in the repository to a local folder called "Github".

2. Create a subfolder in "Github" called "boot_samples". The folder "boot_samples" will be used to store bootstrapped samples. Copy and paste the mfile "importcsv.m" to the folder "boot_samples".

3. Now we are ready to play with the data! Run the first section of Rcodes.R to fit the stock return to earnings surprise, which is the function gamma in the paper. Run Line 1- 102. Make sure to set the working directory to the folder "Github" (by altering Line 3). Note that R uses "\\" instead of "\".
  3.1. Line 1 - 28 use smoothing spline to fit the two main samples: Pre-SOX and Post-SOX. The code calls the two csv files that store the original data and add column "gamma1" and "gamma2" into the csv files. 
  3.2. Line 37 - 102 create bootstrap samples that are later used in calculating standard errors for the tables and confidence intervals for the plots.

4. It's time to use Matlab and get the estimates! Run main_est.m in Matlab till Line 78. 

5. Now back to Rstudio. Follow Rcodes.R and run Line 109 - 253. This will prepare csv files later used in main_plot.m. In particular, Line 227 - 253 returns the values in Table 4.

6. Switch to Matlab. Run main_plot.m (section by section) to replicates Figures 2, 4, and 5 (Up to Line 100). 

7. Codes and data used in the subsample analysis in Section 3.6 of the paper are not provided due to the large amount of data files. Contact Ying Liang if you are interested. 

8. Table 9 is calculated using Matlab main_est.m Line 81-97. 

9. Lastly, replicate Table 10 and Figure 6. Rcodes Line 255 to the end prepares data for Table 10. Then, run Line 98 till end in main_est.m in Matlab to get the matrix Table10, which stores the values presented in Table 10 of the paper. Lastly, the last part of the Matlab mfile main_plot.m plots the distributions of unmanaged earnings in Figure 6 of the paper. 



