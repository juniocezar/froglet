# Froglet

Froglet was a simple project to measure the impact of source code size (in lines of code) on the runtime performance of LLVM optimizations. 

The general idea of the project was to generate hundreds/thousands of generic C code using the tool [CSmith ](https://embed.cs.utah.edu/csmith/), compile them with clang, and run a single analysis or optimization at a time (using OPT).

You can read more about this project in the following report:
[An Empirical Study on the Asymptotic Complexity of
LLVM Optimizations](https://homepages.dcc.ufmg.br/~juniocezar/projects/empirical.pdf).

Images can be found at: [http://juniocezar.github.io/froglet](http://juniocezar.github.io/froglet)



## Usage
If you want to reproduce the experiment you just need to set up LLVM 3.6, adjust its path in the run.sh script and use:

```bash
./run.sh # for running optimizations and generate result files.

./genImages.sh # to generate charts of timeXsize.
```


## License
[GPL](https://en.wikipedia.org/wiki/GNU_General_Public_License)