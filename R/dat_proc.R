library(tidyverse)
library(readxl)
library(lubridate)

# data processing ---------------------------------------------------------

fl <- 'data/raw/TBEP_TBERF_Oyster_Data_Year1.xlsx'

# preproc issues because other sheets are inconsistent
# issues to rectify:
# FI bags in 2016 here labelled as spring, data sheet says fall
# 2D bags in 2016 here labelled as spring, data sheet says fall
# MB bags in 2016 here labelled as spring, data sheet says fall
# FI dome in 2016 here labelled as spring, data sheet says fall (and 2016-2017)
# MD dome in 2007 here labelled as spring, data sheet says fall
mandat <- read_excel(fl, sheet = 'Site data') %>% 
  rename(
    site = Location,  
    type = `Reef type`, 
    inst_year = `Year of install`, 
    inst_seas = `Season of install`,
    date = `Date sampled`
    ) %>% 
  mutate(
    type = gsub('^Dome$', 'Domes', type), 
    site = gsub('^Macdill$', 'MacDill', site),
    inst_year = as.numeric(inst_year),
    inst_seas = case_when(
      site == 'Fantasy Island' & type == 'Bags' & inst_year == 2016 ~ 'Fall', 
      site == '2D Island' & type == 'Bags' & inst_year == 2016 ~ 'Fall', 
      site == 'McKay Bay' & type == 'Bags' & inst_year == 2016 ~ 'Fall',
      site == 'Fantasy Island' & type == 'Domes' & inst_year == 2016 ~ 'Fall',
      site == 'MacDill' & type == 'Domes' & inst_year == 2007 ~ 'Fall',
      type == 'Natural' ~ NA_character_, 
      T ~ inst_seas
    ),
    date = ymd(date),
    site_code = factor(site, 
      levels = c('2D Island', 'Fantasy Island', 'Hillsborough Bay', 'MacDill', 'McKay Bay', 'Perico Preserve', 'Port Manatee'), 
      labels = c('2D', 'FI', 'HB', 'MD', 'MB', 'PP', 'PM')
    ), 
    type_code = factor(type, 
      levels = c('Bags', 'Domes', 'Natural', 'Shell'),
      labels = c('bg', 'dm', 'nt', 'sh')
    ), 
    inst_year_code = gsub('^20', '', inst_year), 
    inst_seas_code = factor(inst_seas, 
      levels = c('Spring', 'Fall'), 
      labels = c('sp', 'fa')
    )
  ) %>%
  unite('id', site_code, type_code, inst_year_code) %>% 
  unite('id', id, inst_seas_code, sep = '') 

# site codes
sitdat <- mandat %>% 
  select(id, site, type, inst_year, inst_seas) %>% 
  unique %>% 
  arrange(site, type)

# wq measurements averaged across start/stop times, secchi not used because on bottom in all cases (same as depth)
wqmdat <- mandat %>% 
  select(
    id, 
    date, 
    Time, 
    do_perc = `DO%`, 
    do_mgl = `DO mg/L`, 
    sal_psu = Salinity, 
    temp_c = `Temp C`, 
    ph = pH, 
    depth_m = `Depth (m)`, 
    secchi_m = `Secchi depth (m)`
    ) %>% 
  filter(!is.na(do_perc)) %>% 
  group_by(id, date) %>% 
  summarise_if(is.numeric, mean, na.rm = T) %>% 
  ungroup()

# all oyster data
bgdat <- read_excel(fl, sheet = 'Bag', na = c('n/a', '')) 
dmdat <- read_excel(fl, sheet = 'Dome', na = c('n/a', ''))
shdat <- read_excel(fl, sheet = 'Shell', na = c('n/a', '')) 
ntdat <- read_excel(fl, sheet = 'Natural', na = c('n/a', '')) 

# kludge fixes for bind_rows
dmdat <- dmdat %>% 
  mutate(
    `Year of install` = gsub('^2016\\-2017$', '2016', `Year of install`), 
    `Year of install` = as.numeric(`Year of install`)
  )
ntdat <- ntdat %>% 
  mutate(
    `Photo #` = as.character(`Photo #`)
  )
shdat <- shdat %>% 
  rename(
    Season = `Season of install`
  )

# combine all oyster data, average lenghts
oysdat <- bind_rows(bgdat, dmdat, shdat, ntdat) %>% 
  rename(
    site = Location,  
    type = `Reef type`, 
    inst_year = `Year of install`, 
    inst_seas = Season,
    date = `Date sampled`
  ) %>% 
  mutate(
    inst_year = as.numeric(inst_year),
    date = ymd(date), 
    type = case_when(
      type == 'Bag' ~ 'Bags', 
      type == 'Dome' ~ 'Domes',
      T ~ type
    )
  ) %>%
  left_join(sitdat, by = c('site', 'type', 'inst_year', 'inst_seas')) %>% 
  select(id, date, plot = `Plot #`, live = `Live #`, dead = `Dead #`, spat = `Spat #`, shell_mm = `Shell height (mm)`) %>% 
  group_by(id, date, plot) %>%
  summarise(
    live = ifelse(length(na.omit(live)) == 0, NA, unique(live)),
    dead = ifelse(length(na.omit(dead)) == 0, NA, unique(dead)),
    spat = ifelse(length(na.omit(spat)) == 0, NA, unique(spat)),
    aveshell_mm = mean(shell_mm, na.rm = T),
    cntshell_mm = length(na.omit(shell_mm)),
    .groups = 'drop'
  )

# save all data objects
save(sitdat, file = 'data/sitdat.RData', compress = 'xz')
save(wqmdat, file = 'data/wqmdat.RData', compress = 'xz')
save(oysdat, file = 'data/oysdat.RData', compress = 'xz')


  