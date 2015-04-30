#!/bin/bash
# This scripts generates charts using the logs. It uses the individual name


OPTS=(adce always-inline argpromotion basiccg block-freq branch-prob constmerge correlated-propagation deadargelim domtree dse early-cse functionattrs globaldce globalopt gvn indvars inline inline-cost instcombine ipsccp jump-threading lazy-value-info lcssa licm loop-deletion loop-idiom loop-rotate loops loop-simplify loop-unroll loop-unswitch loop-vectorize memcpyopt memdep mldst-motion prune-eh reassociate scalar-evolution sccp simplifycfg slp-vectorizer sroa strip-dead-prototypes tailcallelim verify)
NAMES=("Aggressive Dead Code Elimination" "Inliner for always_inline functions" "Promote 'by reference' arguments to scalars" "CallGraph Construction" "Block Frequency Analysis" "Branch Probability Analysis" "Merge Duplicate Global Constants" "Value Propagation" "Dead Argument Elimination" "Dominator Tree Construction" "Dead Store Elimination" "Early CSE" "Deduce function attributes" "Dead Global Elimination" "Global Variable Optimizer" "Global Value Numbering" "Induction Variable Simplification" "Function Integration/Inlining" "Inline Cost Analysis" "Combine redundant instructions" "Interprocedural Sparse Conditional Constant Propagation" "Jump Threading" "Lazy Value Information Analysis" "Loop-Closed SSA Form Pass" "Loop Invariant Code Motion" "Delete dead loops" "Recognize loop idioms" "Rotate Loops" "Natural Loop Information" "Canonicalize natural loops" "Unroll loops" "Unswitch loops" "Loop Vectorization" "MemCpy Optimization" "Memory Dependence Analysis" "MergedLoadStoreMotion" "Remove unused exception handling info" "Reassociate expressions" "Scalar Evolution Analysis" "Sparse Conditional Constant Propagation" "Simplify the CFG" "SLP Vectorizer" "SROA" "Strip Unused Function Prototypes" "Tail Call Elimination" "Module Verifier")


COUNTER=0

BASE_DIR=$( echo $PWD )
DIR_BCFILES=$( echo "$PWD/inputs_ssa" )
DIR_FILES=$( basename $DIR_BCFILES  )
AUX_PATH="Preliminar_results/OptimizationLevels/LOGS/"
IMG_DIR="IMGS/Individual/Opts"
mkdir -p $IMG_DIR

while [  $COUNTER -lt ${#OPTS[*]} ]; do
    PASS=$( echo ${OPTS[$COUNTER]} )
    cd $AUX_PATH/$DIR_FILES/$PASS

    

    for file in $( ls *-1.log ); do
      #cat $file | grep -m 1 "${NAMES[$COUNTER]}"
      #echo $file | sed -e "s/-.*//g"

      id=$( echo $file | sed -e "s/-.*//g" )
      size=$( ls -la $DIR_BCFILES/${id}.bc | awk '{print $5}'  )
      #ls -la $DIR_BCFILES/${id}.bc
      #echo "$file + ${file::-5}2.log + ${file::-5}3.log + ${file::-5}4.log + ${file::-5}5.log"
      #cat ${file} | grep -m 1 "${NAMES[$COUNTER]}"
      time1=$( cat ${file} | grep -m 1 "${NAMES[$COUNTER]}" | awk '{print $5}' )
      time2=$( cat "${file::-5}2.log" | grep -m 1 "${NAMES[$COUNTER]}" | awk '{print $5}' )
      time3=$( cat "${file::-5}3.log" | grep -m 1 "${NAMES[$COUNTER]}" | awk '{print $5}' )
      time4=$( cat "${file::-5}4.log" | grep -m 1 "${NAMES[$COUNTER]}" | awk '{print $5}' )
      time5=$( cat "${file::-5}5.log" | grep -m 1 "${NAMES[$COUNTER]}" | awk '{print $5}' )
      media=$( ${BASE_DIR}/calculator $time1 $time2 $time3 $time4 $time5 )
      #echo "$time1,$time2,$time3,$time4,$time5 = $media"
      echo "$size,0$media" >> "${BASE_DIR}/tmp_1.aux"
    done

    let COUNTER=COUNTER+1
    cd $BASE_DIR

    rm in >> /dev/null 2>&1
    echo "$PASS" >> in
    sort -n tmp_1.aux >> in

    php5 generate_big.php 2>/dev/null >> $IMG_DIR/${PASS}.png
    php5 generate_small.php 2>/dev/null >> $IMG_DIR/${PASS}_small.png
   
    mkdir -p LOGS/Individual/
    mv in LOGS/Individual/${PASS}_pares.log
    rm tmp_1.aux

done

