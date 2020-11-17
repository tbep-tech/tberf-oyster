library(tidyverse)
library(readxl)
library(lubridate)

# data processing ---------------------------------------------------------

fl <- 'data/raw/TBEP_TBERF_Oyster_Data_Year1.xlsx'

# site data codes
sitdat <- read_excel(fl, sheet = 'Site data') %>% 
  select(
    site = Location,  
    type = `Reef type`, 
    inst_year = `Year of install`
    ) %>% 
  mutate(
    inst_year = as.numeric(inst_year),
    type = gsub('^Dome$', 'Domes', type)
    ) %>%
  unique %>% 
  arrange(site, type) %>% 
  mutate(
    site_code = factor(site, 
      levels = c('2D Island', 'Fantasy Island', 'Hillsborough Bay', 'MacDill', 'McKay Bay', 'Perico Preserve', 'Port Manatee'), 
      labels = c('2D', 'FI', 'HB', 'MD', 'MB', 'PP', 'PM')
      ), 
    type_code = factor(type, 
      levels = c('Bags', 'Domes', 'Natural', 'Shell'),
      labels = c('bg', 'dm', 'nt', 'sh')
      ), 
    inst_year_code = gsub('^20', '', inst_year)
  ) %>% 
  unite('id', site_code, type_code, inst_year_code) %>% 
  select(id, everything())

# wq measurements averaged across start/stop times, secchi not used because on bottom in all cases (same as depth)
wqdat <- read_excel(fl, sheet = 'Site data', na = c('n/a', '')) %>% 
  rename(
    site = Location,  
    type = `Reef type`, 
    inst_year = `Year of install`, 
    date = `Date sampled`
    ) %>% 
  mutate(
    inst_year = as.numeric(inst_year),
    type = gsub('^Dome$', 'Domes', type), 
    date = ymd(date)
  ) %>%
  left_join(sitdat, by = c('site', 'type', 'inst_year')) %>% 
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
  summarise_if(is.numeric, mean, na.rm = T)
  