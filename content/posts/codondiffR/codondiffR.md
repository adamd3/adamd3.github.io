---
title: "Introducing codondiffR"
date: 2022-09-01T14:15:45+01:00
draft: false
---

![codondiffR](/images/codondiffR.png)

codondiffR is an R package for the calculation, visualisation, and comparative analysis of codon usage metrics in user-supplied protein-coding nucleotide sequences.

Pre-defined codon usage statistics for reference taxa come from the RefSeq subset of the latest release of the Codon Usage Table Database made by [Athey et al. (2017)](https://www.ncbi.nlm.nih.gov/pubmed/28865429). Mean codon usage frequency difference (MCUFD) metric is calculated as described in [Stedman et al. (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23308027), and linear discriminant analysis is performed using the implementation in the [MASS package](https://cran.r-project.org/web/packages/MASS/index.html).

Here, the functionality of codondiffR is explored with a walkthrough of the various steps involved in a typical analysis.

## Installation

To install and load codondiffR, run the following commands in R:

```r
## install.packages("devtools")
devtools::install_github("adamd3/codondiffR")
library(codondiffR)
```

## Reading in data

To read in one or more sequences from a fasta-format file, we use the `readSeq()` function from the Biostrings package, as shown below. The `DNAStringSet` object can then be used to generate a codonFreq object:

```r
fastaFile <- system.file(
    "extdata", "example_viruses.fna", package="codondiffR"
)
virusSet <- readSeq(file = fastaFile)

class(virusSet)
## [1] "DNAStringSet"
## attr(,"package")
## [1] "Biostrings"

## Create a codonFreq object from the DNAStringSet.
virusCF <- codonFreq(virusSet)

class(virusCF)
## [1] "codonFreq"
## attr(,"package")
## [1] "codondiffR"
```


The relative codon frequencies, along with the names and lengths (in codons) of each sequence, are stored in the codonFreq object, which is the main container for all subsequent analytical procedures. We can access the identifiers, lengths of sequences, and codon frequencies as follows:

```r
nseq(virusCF)
## [1] 16

head(seqID(virusCF))
## [1] "NC_002509.2_Turnip_mosaic_virus"         
## [2] "NC_003628.1_Parsnip_yellow_fleck_virus"  
## [3] "NC_004830.2_Deformed_wing_virus"         
## [4] "NC_003924.1_Cricket_paralysis_virus"     
## [5] "NC_001545.2_Rubella_virus"               
## [6] "NC_004102.1_Hepatitis_C_virus_genotype_1"

head(seqlen(virusCF))
## [1] 3165 3028 2894 2668 3181 3012

head(getFreqs(virusCF)[,1:6])
##              AAA         AAC        AAG         AAT         ACA         ACC
## [1,] 0.030963665 0.031279621 0.04107425 0.016745656 0.024644550 0.011690363
## [2,] 0.029392338 0.015521797 0.03236460 0.022126816 0.018163804 0.018824306
## [3,] 0.028913963 0.005641749 0.02715092 0.040197461 0.014456982 0.007052186
## [4,] 0.045352324 0.018365817 0.02061469 0.027361319 0.031109445 0.013118441
## [5,] 0.004086765 0.011631562 0.01005973 0.005658598 0.003458032 0.037409620
## [6,] 0.009960159 0.020252324 0.02091633 0.008300133 0.010956175 0.029548473
```

## Subset a codonFreq object

Subsetting functionality for a codonFreq object essentially works the same as `Base::Extract` - you pass the numeric indices of the subset in the format: `x[i, j]`; where `x` is the codonFreq object, `i` are the indices of rows (sequences) in the object to be included in the subset, and `j` are the columns (codons) to be included.

```r
## Subset to the first 10 sequences, including all 64 codons:
virusCF_sub_1 <- virusCF[1:10,1:64]

nseq(virusCF_sub_1)
## [1] 10

## Subset to specific codons and the first 10 sequences:
codIdx <- which(colnames(getFreqs(virusCF)) %in% c("ATC", "AAT", "GCC"))
virusCF_sub_2 <- virusCF[1:10,codIdx]
```

## Visualise codon frequency and GC3 content

To plot the relative codon frequencies, call the codonPlot() function on the codonFreq object as shown below. Various attributes of the output figure can be specified using the parameters `height`, `width`, `dpi`, and `fname`. See the function’s help page for more information. If a groups vector is supplied, then codon frequencies will be plotted by group. Note that all plotting functions in the package will return a ggplot object, which can be used to modify or combine figures.

```r
codonPlot(virusCF)
## Using Taxon as id variables
```
![](/images/codondiffR-chunk-5-1.png)


For these and all other plots, it is possible to save the plot to file when calling the function, by setting `save = TRUE` when calling `codonPlot` (or any other plot-producing function), and the height, width, file name and dpi of the saved figure can be specified. See the help pages for each function.

It is also possible to make grouped codon plots as follows:

```r
groups <- c(
    rep("Non-mammalian virus", 4),
    rep("Mammalian virus", 10), rep("Non-mammalian virus", 2)
)

codonPlot(virusCF, groups = groups, width = 40, height = 7)
## Using Taxon, groups as id variables
```
![](/images/codondiffR-chunk-6-1.png)



It is also possible to plot the GC3 content (i.e. proportion of codons with a G or a C residue at the third position) across the sequences. A groups vector is required here; and it must be the same length as the number of sequences in the codonFreq object.

```r
groups <- c(
    rep("Plant virus", 2), rep("Insect virus", 2),
    rep("Mammal-specific virus", 6), rep("Mammalian and Insect virus", 4), rep("Insect-specific virus", 2)
)

gcPlot(virusCF, groups = groups, width = 40, height = 7)
## Using Taxon, groups as id variables
```
![](/images/codondiffR-chunk-7-1.png)


## Normalisation and codon bias calculation

Normalisation of codon frequencies transforms the raw frequencies of individual codons into the relative proportions for each amino acid. For example, if half of all alanine-encoding codons are GCC and the other half are GCG, then the normalised abundances of these two codons will both be 0.5, and the abundances of the other two alanine-encoding codons (GCT and GCA) will be 0. When an amino acid is not found in a given sequence, then the proportions of each of the corresponding codons will be NA.

```r
virusCF_norm <- normalise(virusCF)

head(getFreqs(virusCF_norm)[,1:6])
##          AAA       AAC       AAG       AAT        ACA       ACC
## X1 0.4298246 0.6513158 0.5701754 0.3486842 0.40414508 0.1917098
## X2 0.4759358 0.4122807 0.5240642 0.5877193 0.29411765 0.3048128
## X3 0.5157233 0.1230769 0.4842767 0.8769231 0.25625000 0.1250000
## X4 0.6875000 0.4016393 0.3125000 0.5983607 0.41919192 0.1767677
## X5 0.2888889 0.6727273 0.7111111 0.3272727 0.05699482 0.6165803
## X6 0.3225806 0.7093023 0.6774194 0.2906977 0.15277778 0.4120370
```

## Codon bias plots

Codon bias can be plotted using normalised frequencies per amino acid:

```r
groups <- c(
    rep("Non-mammalian virus", 4),
    rep("Mammalian virus", 10), rep("Non-mammalian virus", 2)
)

biasPlot(
    virusCF_norm, groups = groups, aa = "L",
    label = "Leucine", colours = c(1,2), ylim = c(0,0.5), width = 40, height = 7
)
## Using Taxon, groups as id variables
```
![](/images/codondiffR-chunk-9-1.png)


## Comparison with codon usage in other taxa

Mean codon usage frequency divergence (MCUFD) between the sequences in the codonFreq object and those in the Codon Usage Table Database (CUTD) (PMID: 23308027) can be calculated using the `MCUFD` function. Specific codons can be excluded from the comparison by passing a vector to exclude, and a minimum number of codons required in both the codonFreq sequences and the CUTD database entries (using the minlen parameter; default = 600 codons).

The results can then be plotted using the `MCUFD_plot` function, and the type argument accepts either bar (bar plots) or line (line plots). Moreover, the phylogenetic rank of interest can be specified using the rank parameter, which accepts `Phylum` (default), `Domain`, or `Kingdom`. The five most common overall levels of this rank will be plotted per sequence.

Enrichment testing allows an assessment of the relative over- or under-representation of specific taxonomic ranks in the top n hits. Enrichment plot type is determined by the ptype parameter, which accepts either `heatmap` (default) or `dotplot`. An optional p-value threshold, based on the results of Fisher’s exact test, can also be applied using pthresh. The results of the enrichment testing can also be saved in tab-delimited format to a file, via `outtab`.

```r
exclCod <- c("TAA", "TAG", "TGA")
MCUFD_virus <- MCUFD(virusCF_norm, exclude = exclCod, minlen = 600)

class(MCUFD_virus)
## [1] "list"

## Range of MCUFD values for the first sequence in the `codonFreq` object:
range(MCUFD_virus[[1]]$MCUFD)
## [1] 0.05668745 0.31468838

## Taxonomic ranks of the 100 most similar database entries:
table(MCUFD_virus[[1]]$Kingdom[1:100], useNA = "always")
##         Fungi       Metazoa Viridiplantae          <NA>
##            20            45             7            28

MCUFD_enrich(
    MCUFD_virus, n = 100, rank = "Phylum", ptype = "heatmap",
    pthresh = 0.05,
    dpi = 200, width = 40, height = 7
)
```
![](/images/codondiffR-chunk-10-1.png)


Note that the MCUFD enrichment values can be saved to file by using the `outtab` parameter - see the help page for the `MCUFD_enrich` function.

## Principal component analysis (PCA)

PCA of entries in the Codon Usage Table Database (CUTD) (PMID: 23308027) can be calculated using the `PCA()` function. A subset of specific taxonomic groups can be included using includeTax. The `predict_PCA()` function will apply the principal components defined with `PCA()` to the sequences in the codonFreq object, and produce a plot of the first two components (PC1 and PC2).

```r
includeTax <- c(
    "Arthropoda", "Streptophyta",  "Chordata"
)
exclCod <- c("TAA", "TAG", "TGA")

PCA_dat <- PCA(
    exclude = exclCod, rank = "Phylum",
    corCut = 1, minlen = 600, includeTax = includeTax
)

class(PCA_dat)
## [1] "prcomp"

identifiers <- c(
    rep("Non-mammalian virus", 4),
    rep("Mammalian virus", 10), rep("Non-mammalian virus", 2)
)
predict_PCA(
    virusCF_norm, PCA_dat, rank = "Phylum",
    minlen = 600, identifier = identifiers, includeTax = includeTax,
    dpi = 200, width = 40, height = 7
)
```
![](/images/codondiffR-chunk-11-1.png)


## Session info
```r
sessionInfo()
## R version 4.1.3 (2022-03-10)
## Platform: x86_64-redhat-linux-gnu (64-bit)
## Running under: Fedora Linux 35 (Workstation Edition)
##
## Matrix products: default
## BLAS/LAPACK: /usr/lib64/libflexiblas.so.3.2
##
## locale:
##  [1] LC_CTYPE=en_GB.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_GB.UTF-8        LC_COLLATE=en_GB.UTF-8    
##  [5] LC_MONETARY=en_GB.UTF-8    LC_MESSAGES=en_GB.UTF-8   
##  [7] LC_PAPER=en_GB.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_GB.UTF-8 LC_IDENTIFICATION=C       
##
## attached base packages:
## [1] grid      stats     graphics  grDevices utils     datasets  methods  
## [8] base     
##
## other attached packages:
## [1] scales_1.2.1     plyr_1.8.7       ggplot2_3.3.6    codondiffR_0.1.0
##
## loaded via a namespace (and not attached):
##   [1] nlme_3.1-155           bitops_1.0-7           fs_1.5.2              
##   [4] usethis_2.1.5          lubridate_1.8.0        devtools_2.4.3        
##   [7] RColorBrewer_1.1-3     GenomeInfoDb_1.30.1    ggbiplot_0.55         
##  [10] tools_4.1.3            utf8_1.2.2             R6_2.5.1              
##  [13] rpart_4.1.16           BiocGenerics_0.40.0    colorspace_2.0-3      
##  [16] nnet_7.3-17            withr_2.5.0            tidyselect_1.1.2      
##  [19] prettyunits_1.1.1      processx_3.7.0         curl_4.3.2            
##  [22] compiler_4.1.3         factoextra_1.0.7       cli_3.3.0             
##  [25] labeling_0.4.2         callr_3.7.2            proxy_0.4-27          
##  [28] stringr_1.4.1          digest_0.6.29          rmarkdown_2.16        
##  [31] XVector_0.34.0         pkgconfig_2.0.3        htmltools_0.5.3       
##  [34] parallelly_1.32.1      sessioninfo_1.2.2      highr_0.9             
##  [37] fastmap_1.1.0          rlang_1.0.5            farver_2.1.1          
##  [40] generics_0.1.3         dplyr_1.0.10           ModelMetrics_1.2.2.2  
##  [43] RCurl_1.98-1.6         magrittr_2.0.3         GenomeInfoDbData_1.2.7
##  [46] Matrix_1.4-0           S4Vectors_0.32.3       Rcpp_1.0.9            
##  [49] munsell_0.5.0          fansi_1.0.3            lifecycle_1.0.1       
##  [52] stringi_1.7.8          pROC_1.18.0            yaml_2.3.5            
##  [55] zlibbioc_1.40.0        MASS_7.3-55            pkgbuild_1.3.1        
##  [58] recipes_1.0.1          ggrepel_0.9.1          parallel_4.1.3        
##  [61] listenv_0.8.0          crayon_1.5.1           lattice_0.20-45       
##  [64] Biostrings_2.62.0      splines_4.1.3          knitr_1.40            
##  [67] ps_1.7.1               pillar_1.8.1           future.apply_1.9.0    
##  [70] reshape2_1.4.4         codetools_0.2-18       stats4_4.1.3          
##  [73] pkgload_1.3.0          glue_1.6.2             evaluate_0.16         
##  [76] data.table_1.14.2      remotes_2.4.2          vctrs_0.4.1           
##  [79] foreach_1.5.2          gtable_0.3.1           purrr_0.3.4           
##  [82] future_1.27.0          cachem_1.0.6           xfun_0.32             
##  [85] gower_1.0.0            prodlim_2019.11.13     e1071_1.7-11          
##  [88] class_7.3-20           survival_3.2-13        timeDate_4021.104     
##  [91] tibble_3.1.8           iterators_1.0.14       IRanges_2.28.0        
##  [94] memoise_2.0.1          hardhat_1.2.0          lava_1.6.10           
##  [97] globals_0.16.1         ellipsis_0.3.2         caret_6.0-93          
## [100] ipred_0.9-13
```
