cnt=0
while read line                                                         
do                                                                      
      Rscript allot-color-location.R "./merged/m$cnt.csv" $line "./aggregate/m$cnt.csv"                                                                   
      cnt=`expr $cnt + 1`                                             
done <color-pattern.txt
