# gym lokal

setwd("~/Documents/Sumut_Graber/Google Maps/Finder")

source("finde.R")

library(readxl)
data = read_excel("~/Documents/Sumut_Graber/Google Maps/Finder/uji coba gym lokal/gym_lokal.xlsx",
                  sheet = "Database gym jateng") %>% janitor::clean_names()

cari =
  data %>% 
  mutate(cari = paste(nama_gym,area_kota_kab)) %>% 
  .$cari

data_final = vector("list",length(cari))

for(i in 1:length(cari)){
  data_final[[i]] = cari_tempat(cari[i])
  Sys.sleep(2)
  print(i)
}

# simmilarity
simi_simi = data.frame(ig = NA,
                       maps = NA,
                       similarity = NA)

# looping menghitung kesamaan
for(i in 1:length(cari)){
  # bersihin nama dari Lenny
  tes_1 = bersihin(cari[i])
  # bersihin nama dari google maps
  if(nrow(data_final[[i]]) > 0){tes_2 = bersihin(data_final[[i]]$nama_tempat)}
  if(nrow(data_final[[i]]) == 0){tes_2 = "="}
  # hasilnya
  simi_simi[i,] = list(tes_1,
                       tes_2,
                       kesamaan(tes_1,tes_2))
}

simi_simi %>% 
  mutate(keterangan = case_when(
    similarity < 0.65 ~ "IG tidak ditemukan di Gmaps",
    similarity >= 0.65 & similarity < 0.75 ~ "Dipertimbangkan",
    similarity >= 0.75 ~ "IG ditemukan di Gmaps"
  )
         ) %>% 
  write.csv("hasil gym.csv")
