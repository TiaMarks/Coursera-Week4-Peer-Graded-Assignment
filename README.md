# Coursera-Week4-Peer-Graded-Assignment
I created a data frame comprising both the test and the training measurements. 

I tried tidying it up by adding the name of the columns and by sorting it by
subject number with the type of activity as the second parameter.

I tried searching for matches to the "mean()" string but it matched every single
"mean" it encountered even if there were no parentheses aftwerwards.
So I substituted the "(" with an "x" and then used grep to look for the position
of every column with "meanx" in its name. 
I did the same with "std" and then subset all the columns I got as a result, 
adding the first two for more clarity.

I used a for loop to subset the activity labels with the corresponding activity
name.

Then I created a new data frame with the average of each variable for every 
Subject+Activity subset using melt and dcast. 