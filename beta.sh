#!/bin/bash
#export PATH=~/Applications/llvm-3.6/Release+Asserts/bin/:$PATH
export PATH=~/media/HD/IC/llvm/bin/:$PATH
clang --version
#OPTS=(basicaa basiccg block-freq branch-prob domtree inline-cost lazy-value-info loops memdep no-aa scalar-evolution tbaa)
#OPTS=(basicaa adce always-inline correlated-propagation deadargelim dse early-cse functionattrs globalopt indvars instcombine ipsccp jump-threading lcssa licm loop-deletion loop-idiom loop-rotate loop-simplify loop-unroll loop-unswitch loop-vectorize memcpyopt prune-eh reassociate  sccp simplifycfg sroa strip-dead-prototypes tailcallelim)
#OPTS=()

#analysis 46
#OPTS=(aa-eval basicaa basiccg block-freq branch-prob count-aa da debug-aa domfrontier domtree dot-callgraph dot-cfg dot-cfg-only dot-dom dot-dom-only dot-postdom dot-postdom-only dot-regions dot-regions-only globalsmodref-aa inline-cost instcount intervals iv-users lazy-value-info libcall-aa lint loops memdep module-debuginfo no-aa postdomtree print-alias-sets print-callgraph print-callgraph-sccs print-cfg-sccs print-dom-info print-externalfnconstants print-function print-module print-used-types print-bb print-memdeps regions scalar-evolution scev-aa tbaa)
#transform 96
#OPTS=(adce add-discriminators alloca-hoisting always-inline argpromotion atomic-ll-sc bb-vectorize bounds-checking break-crit-edges codegenprepare consthoist constmerge constprop correlated-propagation cost-model datalayout dce deadargelim debug-ir delinearize dfsan die domfrontier dse early-cse functionattrs generic-to-nvvm globaldce globalopt gvn indvars inline insert-gcov-profiling instcombine instsimplify internalize ipconstprop ipsccp jump-instr-table-info jump-threading lcssa licm load-combine loop-deletion loop-extract loop-extract-single loop-idiom loop-instsimplify loop-reduce loop-reroll loop-rotate loop-simplify loop-unroll loop-unswitch loop-vectorize loweratomic lower-expect lowerinvoke lowerswitch mem2reg memcpyopt mergefunc mergereturn metarenamer mldst-motion msan nvptx-assign-valid-global-names nvptx-favor-non-generic nvvm-reflect objc-arc objc-arc-aa objc-arc-apelim objc-arc-contract objc-arc-expand partial-inliner partially-inline-libcalls prune-eh reassociate reg2mem sample-profile scalarizer scalarrepl scalarrepl-ssa sccp separate-const-offset-from-gep simplifycfg sink slp-vectorizer sroa strip strip-dead-debug-info strip-dead-prototypes strip-debug-declare strip-nondebug structurizecfg tailcallelim tsan)
#utility 10
OPTS=(deadarghaX0r extract-blocks instnamer notti targetlibinfo verify view-cfg view-dom view-postdom view-callgraph view-regions)


PASTA="inputs_ssa"
PASS="-sroa"

rm in tmp 2>/dev/null

if [ -d LOGS/$PASTA ]; then
  diff=` date +%Y_%m_%d_%H_%M_%S `
  mv LOGS/$PASTA LOGS/OLDS/${PASTA}_$diff
fi

if [ -d IMGS/$PASTA ]; then
  diff=` date +%Y_%m_%d_%H_%M_%S `
  mv IMGS/$PASTA IMGS/OLDS/${PASTA}_$diff
fi

mkdir -p LOGS/$PASTA
mkdir -p IMGS/$PASTA

COUNTER=0

echo "Executando na pasta $PASTA"

while [  $COUNTER -lt ${#OPTS[*]} ]; do
    PASS=` echo -${OPTS[$COUNTER]} `
    T="$(date +%s)"
    echo "Gerando imagens para ${PASS:1}"

    for file in $( ls $PASTA/*.bc ); do
    #for file in $( ls $PASTA/1000152* ); do
      size=` ls -la $file | awk '{print $5}' `
      file=` ls -la $file | awk '{print $9}' `
      #echo "File: $file, Size: $size"
      time1=0
      time2=0
      time3=0
      time4=0
      time5=0
    
      #echo "File = $file | Size=$size"
    


      opt -disable-output -disable-verify -time-passes -info-output-file=LOGS/${file::-3}-1.log $PASS $file 2>&1 >> /dev/null
      if [ -f LOGS/${file::-3}-1.log ]; then
        time1=` grep Total_Time LOGS/${file::-3}-1.log | awk '{print $5}'	`    
      else
      	time1=0
      fi

      
      opt -disable-output -disable-verify -time-passes -info-output-file=LOGS/${file::-3}-2.log $PASS $file  2>&1 >> /dev/null
      if [ -f LOGS/${file::-3}-2.log ]; then
        time2=` grep Total_Time LOGS/${file::-3}-2.log | awk '{print $5}'	`    
      else
      	time2=0
      fi
    
      opt -disable-output -disable-verify -time-passes -info-output-file=LOGS/${file::-3}-3.log $PASS $file  2>&1 >> /dev/null
      if [ -f LOGS/${file::-3}-3.log ]; then
        time3=` grep Total_Time LOGS/${file::-3}-3.log | awk '{print $5}'	`    
      else
      	time3=0
      fi

    
      opt -disable-output -disable-verify -time-passes -info-output-file=LOGS/${file::-3}-4.log $PASS $file  2>&1 >> /dev/null
      if [ -f LOGS/${file::-3}-4.log ]; then
        time4=` grep Total_Time LOGS/${file::-3}-4.log | awk '{print $5}'	`    
      else
      	time4=0
      fi

      opt -disable-output -disable-verify -time-passes -info-output-file=LOGS/${file::-3}-5.log $PASS $file  2>&1 >> /dev/null
      if [ -f LOGS/${file::-3}-5.log ]; then
        time5=` grep Total_Time LOGS/${file::-3}-5.log | awk '{print $5}'	`    
      else
      	time5=0
      fi

      
      #echo "=========================================>"
      #echo "                        $time1 - $time2 - $time3 - $time4 - $time5"
      #echo "========================================="
    

      #average_time=` echo "(($time1+$time2+$time3+$time4+$time5)/$dividendo)*1000" | bc -l 2>/dev/null ` #Faz a média e já multiplica por 1000 gerando miliseconds
      average_time=`./calculator $time1 $time2 $time3 $time4 $time5`
      echo "$size,0$average_time" >> tmp
      #echo "[$size, 0$average_time , $dividendo]" 
      
    
    done
    
    T="$(($(date +%s)-T))"
    echo "Tempo gasto: ${T} segundos"
    echo ""
    
    echo ${PASS:1} >> in
    
    sort -n tmp >> in
    
    php5 generate_big.php 2>/dev/null >> IMGS/$PASTA/${PASS:1}.png
    php5 generate_small.php 2>/dev/null >> IMGS/$PASTA/${PASS:1}_small.png
    
    
    mkdir LOGS/$PASTA/${PASS:1}
    mv LOGS/$PASTA/*.log LOGS/$PASTA/${PASS:1}

    mv in LOGS/$PASTA/${PASS:1}/pares_ordenado.txt
    mv tmp LOGS/$PASTA/${PASS:1}/pares.txt

    let COUNTER=COUNTER+1 
done


