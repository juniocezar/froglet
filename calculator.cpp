/*=========================================================
 Program that calculates the average between N input double
values. It multiplies the resultant value by 1000 to change
its unit.

Ex: Calculate the average: 0.0582381239012213 (in seconds)
    return 58.2381.... (in milliseconds)

==========================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv){
  if (argc < 2 )
    return -1;

  double sum = 0;
  double num = 0;
  int dividendo = argc - 1;

  for(int i = 0; i < argc; i++){
    num = atof(argv[i]);
    sum += num;
    if(!strcmp(argv[i],"0.000000000000000000000000")){
      dividendo--;
    }
  }

  //printf("Media = %.18lf\n\n", sum/(argc-1));
  printf("%.18lf", 1000*(sum/dividendo));



  return 0;
}
