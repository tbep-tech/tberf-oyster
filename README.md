
# README

Materials for evaluating TBERF oyster restoration success. Raw data are
in `data/raw` and was processed in `R/dat_proc.R`. All data can be
joined by the common key `id`.

### Site metadata

``` r
data(sitdat)
head(sitdat)
```

    ##           id           site  type inst_year inst_seas
    ## 1 2D_bg_18sp      2D Island  Bags      2018    Spring
    ## 2 2D_bg_16fa      2D Island  Bags      2016      Fall
    ## 3 FI_bg_16fa Fantasy Island  Bags      2016      Fall
    ## 4 FI_bg_08fa Fantasy Island  Bags      2008      Fall
    ## 5 FI_dm_16fa Fantasy Island Domes      2016      Fall
    ## 6 FI_sh_NANA Fantasy Island Shell        NA      <NA>

``` r
str(sitdat)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    18 obs. of  5 variables:
    ##  $ id       : chr  "2D_bg_18sp" "2D_bg_16fa" "FI_bg_16fa" "FI_bg_08fa" ...
    ##  $ site     : chr  "2D Island" "2D Island" "Fantasy Island" "Fantasy Island" ...
    ##  $ type     : chr  "Bags" "Bags" "Bags" "Bags" ...
    ##  $ inst_year: num  2018 2016 2016 2008 2016 ...
    ##  $ inst_seas: chr  "Spring" "Fall" "Fall" "Fall" ...

### Water quality data

``` r
data(wqmdat)
head(wqmdat)
```

    ##           id       date do_perc do_mgl sal_psu temp_c    ph
    ## 1 2D_bg_16fa 2019-11-18  109.05  8.290  25.415  21.65 7.820
    ## 2 2D_bg_18sp 2019-04-02   76.45  5.870  23.235  21.70 7.815
    ## 3 2D_bg_18sp 2019-11-27   93.10  7.330  24.970  19.80 7.865
    ## 4 FI_bg_08fa 2019-10-01  101.95  6.985  22.680  28.25 8.040
    ## 5 FI_bg_16fa 2019-03-06   95.05  7.525  21.275  20.60 8.095
    ## 6 FI_dm_16fa 2019-03-06   95.05  7.525  21.275  20.60 8.095

``` r
str(wqmdat)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    22 obs. of  7 variables:
    ##  $ id     : chr  "2D_bg_16fa" "2D_bg_18sp" "2D_bg_18sp" "FI_bg_08fa" ...
    ##  $ date   : Date, format: "2019-11-18" "2019-04-02" ...
    ##  $ do_perc: num  109 76.4 93.1 102 95 ...
    ##  $ do_mgl : num  8.29 5.87 7.33 6.98 7.53 ...
    ##  $ sal_psu: num  25.4 23.2 25 22.7 21.3 ...
    ##  $ temp_c : num  21.6 21.7 19.8 28.2 20.6 ...
    ##  $ ph     : num  7.82 7.81 7.87 8.04 8.09 ...

### Oyster data

``` r
data(oysdat)
head(oysdat)
```

    ##           id       date plot live dead spat aveshell_mm cntshell_mm
    ## 1 2D_bg_16fa 2019-11-18    1   68    7    0      35.480          25
    ## 2 2D_bg_16fa 2019-11-18    2   92    7    0      38.000          25
    ## 3 2D_bg_16fa 2019-11-18    3   29   10    0      42.960          25
    ## 4 2D_bg_16fa 2019-11-18    4  147   34   20      49.920          25
    ## 5 2D_bg_16fa 2019-11-18    5   64   13    0      33.160          25
    ## 6 2D_bg_16fa 2019-11-18    6   16    7    0      37.375          16

``` r
str(oysdat)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    206 obs. of  8 variables:
    ##  $ id         : chr  "2D_bg_16fa" "2D_bg_16fa" "2D_bg_16fa" "2D_bg_16fa" ...
    ##  $ date       : Date, format: "2019-11-18" "2019-11-18" ...
    ##  $ plot       : num  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ live       : num  68 92 29 147 64 16 28 25 43 171 ...
    ##  $ dead       : num  7 7 10 34 13 7 7 15 15 18 ...
    ##  $ spat       : num  0 0 0 20 0 0 0 1 0 NA ...
    ##  $ aveshell_mm: num  35.5 38 43 49.9 33.2 ...
    ##  $ cntshell_mm: int  25 25 25 25 25 16 25 25 25 25 ...
