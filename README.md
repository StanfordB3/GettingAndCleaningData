## Code Book

This file describes the run_analysis.R, Tidy_HAR_Summary.txt, and Tidy_HAR_CodeBook.txt files within this folder of the Githup repository.

### 1. run_analysis.R
This is an R code that was developed in RStudio on an an Apple MAC laptop. For most part the code has been commented appropriately at every step.

#### *Section I: Download HAR Data from University of California, Irvine Repository*

This section of the code ensures that the RData directory exist is user's folder. 
Next it downloads the Human Activities Recognition dataset from the University of Irvine repository.  

The above actions fetches the data as a zip file. Using the R zip command the zipped file is unzipped in to the working directory of the R code.

#### *Section II: R Libraries *
Some needed libraries are then loaded in to the working environment.

#### *Section III: Read HAR files *
The HAR data contains a list of files that contains information about the vectors, type of activitis with associated numeric code, subject codes conducting experiment. The data is devided in to the training and test folders.

Employing the "read.csv" R command all of the data files are read one by one and stored in appropriate variables.

#### *Section IV: Manipulate data *
Having read the HAR data for the training and testing sets seperately, in this sections they are comined using the rbind command. 

A required merged data set that contains both the training and test data set is also produced and stored in a variable called TT.

Also the cryptic column titles are converted in to communicable labels and generic default labels associated in TT are replaced in a for loop.

Next, using R grep command the columns with mean and std observables are extracted and the activity codes are replaced with the descriptive labels per information provided in activities_label.txt file.

#### *Section V: Write the Output files *
Finally, the information in the TT is in the appropriate format to group the data by the activity types and subject information.  Subsequently, using summarize_each command the mean for each vector is generated that tabulates the data each subject and each activity. 

### 2. Tidy_HAR_Summary.txt

The Tidy_HAR_Summary.txt is the output of run_analysis.R describe above. It lists averates for each of the mean and standard deviation vector for each of the activity as well as subject that performed the experiments.

### 3. Tidy_HAR_CodeBook.txt

The code book describes the tidy data in the csv for further analysis. 