# This script will take the combined raw data set and add
# a MARDI CODE for each taxon

# packages
library("readr")
library("fs")
library("googledrive")
library("stringr")

# check if we have the Mardi code translation file
# if we don't, download it
dict_fn <- here("data/mardi-species-dictionary-long.xlsx")
if (!fs::file_exists(dict_fn)) {
  ## MARDI species dictionary
  drive_download("W3 species-dictionary-long.xlsx",
      path = dict_fn)
}

# Load the dictionary
mardi_dict <- read_excel(dict_fn, na = c("", "NA"))

# Need to clean the dictionary a bit

# dataset_id was numeric in the xlsx file, delete the ".0"
mardi_dict <- mardi_dict |>
  mutate(
    dataset_id = str_replace_all(dataset_id, ".0", "")
  )
# Data set 9 was deleted so those have blank codes
mardi_dict <- mardi_dict |>
  filter(!is.na(mardi_code))
# Data set 4 was split to 4A and 4B, so we can delete any row
# with dataset_id == 4
mardi_dict <- mardi_dict |>
  filter(!dataset_id == "4")
# Standardise to 4a, 4b, 5a, etc
mardi_dict <- mardi_dict |>
  mutate(
    dataset_id = str_to_lower(dataset_id)
  )
# Remove all the NA in dataset_code
mardi_dict <- mardi_dict |>
  filter(
    !is.na(dataset_code)
  )
# Remove any "\n" in dataset_code
mardi_dict <- mardi_dict |>
  mutate(
    dataset_code = str_replace_all(dataset_code, "[\n]", "")
  )

# load the combined data
diat_fn <- here("data/processed/combined-diatom-data-long.csv")
mardi_diatom <-
  readr::read_csv(
    diat_fn,
    col_types = "cccdd"
  )

mardi_diatom |>
  anti_join(
    mardi_dict,
    by = join_by(taxon_code == dataset_code)
  ) |>
  distinct(
    taxon_code, .keep_all = TRUE
  ) |>
  arrange(
    dataset, taxon_code
  )

# for the workshop quickly add a map for some taxa
# move this to it's own script soon

# packages
library("janitor")
library("dplyr")
library("readxl")
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
library("stringr")
library("ggplot2")

# load the site metadata
mardi_meta <- read_excel(here("data/mardi-site-metadata.xlsx"))

# right now there is a ...19 column, delete it is it exists
if ("...19" %in% names(mardi_meta)) {
  mardi_meta <- mardi_meta |>
    select(
      !`...19`
    )
}

# clean the column names
mardi_meta <- mardi_meta |>
  janitor::clean_names() |>
  mutate(
    diatom_dataset = str_replace(diatom_dataset, "\\.0", "")
  ) |>
  mutate(
    site_id_in_dataset = case_when(
      diatom_dataset == "9" ~ str_replace(site_id_in_dataset, "\\.0$", ""),
      .default = site_id_in_dataset
    ),
    diatom_dataset = str_to_lower(diatom_dataset)
  )

# check which sites/samples are in the diatom data
mardi_diatom |>
  anti_join(
    mardi_meta,
    by = join_by(sample == site_id_in_dataset, dataset == diatom_dataset)
  ) |>
  distinct(
    sample, .keep_all = TRUE
  ) |>
  select(
    dataset, sample
  )

mardi_diatom_harmon <- mardi_diatom |>
  left_join(
    mardi_dict,
    by = join_by(taxon_code == dataset_code, dataset == dataset_id)
  ) |>
  select(
    !taxon_code
  )

# map of relative abundance of some taxa
mardi_diatom_harmon_sf <- mardi_diatom_harmon |>
  select(
    -count
  ) |>
  filter(
    mardi_code %in% c("THA ARS", "FRS OCE")
  ) |>
  pivot_wider(
    names_from = "mardi_code",
    values_from = "percentage",
    values_fn = \(x) sum(x, na.rm = TRUE),
    values_fill = 0
  ) |>
  left_join(
    mardi_meta |>
      select(c(site_id_in_dataset, lat_dec, lon_dec, diatom_dataset)),
    by = join_by(sample == site_id_in_dataset, dataset == diatom_dataset)
  ) |>
  st_as_sf(
    coords = c("lon_dec", "lat_dec"),
    crs = "EPSG:4326"
  )

world <- ne_countries(scale = "medium", returnclass = "sf")

mardi_diatom_harmon_sf |>
  ggplot() +
  geom_sf(aes(size = `THA ARS`)) +
  geom_sf(data = world) +
  coord_sf(
    xlim = c(-180, 180),
    ylim = c(29.9, 90)
  )
