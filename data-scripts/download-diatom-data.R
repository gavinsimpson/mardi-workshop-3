# Download the raw data

# Packages
library("googledrive")
library("fs")
library("here")

# Download


## MARDI data folders
if (!dir_exists(here("data"))) {
  dir_create(here("data"))
}
if (!dir_exists(here("data/raw"))) {
  dir_create(here("data/raw"))
}
if (!dir_exists(here("data/processed"))) {
  dir_create(here("data/processed"))
}

## MARDI metadata
drive_download("W3 MARDI_sites_metatada.xlsx",
    path = "data/mardi-site-metadata.xlsx")

## MARDI data set 1
data_dir <- "data/raw/01"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 NPI - Diatom SST_Calibration dataset 183_2016 _ Arto email 140123.xls",
  path = here(data_dir, "01-spp-data.xls")
)

## MARDI data set 2

## ---- No data ----

## MARDI data set 3
data_dir <- "data/raw/03"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 MARDI_SurfSedSet_CalibModern_Krawczyk.xlsx",
  path = here(data_dir, "03-spp-data.xlsx")
)

## MARDI data set 4
data_dir <- "data/raw/04"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 MARDI_Qaanaaq surface set_K Weckström.xlsx",
  path = here(data_dir, "04b-spp-data.xlsx")
)

drive_download(
  "W3 MARDI_several sites_Circum Greenland_M Oksman.xlsx",
  path = here(data_dir, "04c-spp-data.xlsx")
)

# only two in here are useful
drive_download(
  "W3 MARDI_Station North surface set_counts_K Weckström.xlsx",
  path = here(data_dir, "04d-spp-data.xlsx")
)

drive_download(
  "W3 MARDI_Young Sound surface set_K Weckström.xlsx",
  path = here(data_dir, "04e-spp-data.xlsx")
)

## MARDI data set 5
data_dir <- "data/raw/05"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 Bering and Chukchi Sites All Data.xlsx",
  path = here(data_dir, "05-spp-data.xlsx")
)

## MARDI data set 6
data_dir <- "data/raw/06"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 NPac.xlsx",
  path = here(data_dir, "06-spp-data.xlsx")
)

## MARDI data set 7
data_dir <- "data/raw/07"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 MARDI_surfdata_Lapointe.xlsx",
  path = here(data_dir, "07-spp-data.xlsx")
)

## MARDI data set 8
data_dir <- "data/raw/08"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 Okhotsk.xlsx",
  path = here(data_dir, "08-spp-data.xlsx")
)

## MARDI data set 9
data_dir <- "data/raw/09"
if (!dir_exists(here(data_dir))) {
  dir_create(here(data_dir))
}

drive_download(
  "W3 metadata-Emilie Arseneault.xlsx",
  path = here(data_dir, "09-spp-data.xlsx")
)
