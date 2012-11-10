totnum=0
cat compliments.txt | while read line
do
  totnum=$(( $totnum + 1 ))
  echo "Processing new line"
  echo $line
  echo $totnum
done

