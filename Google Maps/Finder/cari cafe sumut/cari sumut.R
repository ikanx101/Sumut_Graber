# pencarian cafe sumut

# ambil semua skrip
source("~/Documents/Sumut_Graber/Google Maps/Finder/finde.R")

# set working directory
setwd("~/Documents/Sumut_Graber/Google Maps/Finder/cari cafe sumut")

# load data merchant grab
load("~/Documents/Sumut_Graber/Reporting/grab vs maps/siap_cari.rda")

# ambil hanya nama saja
nama = df_grab$keywords %>% unique() 

# siapin rumah untuk data
data_final = vector("list",length(nama))

# proses scraping
for(i in 1:length(nama)){
  nama_clean = iconv(nama[i],"latin1","ASCII",sub = "")
  data_final[[i]] = cari_tempat(nama_clean)
  Sys.sleep(3)
  print(paste0("Scrape ke-",i," == DONE"))
}

# simmilarity
simi_simi = data.frame(grab = NA,
                       maps = NA,
                       similarity = NA)

# looping menghitung kesamaan
for(i in 1:length(nama)){
  # bersihin nama dari grab
  tes_1 = bersihin(nama[i])
  # bersihin nama dari google maps
  if(nrow(data_final[[i]]) > 0){tes_2 = bersihin(data_final[[i]]$nama_tempat)}
  if(nrow(data_final[[i]]) == 0){tes_2 = "="}
  # hasilnya
  simi_simi[i,] = list(tes_1,
                       tes_2,
                       kesamaan(tes_1,tes_2))
}

simi_simi = 
  simi_simi %>% 
  mutate(keterangan = case_when(
    similarity < 0.65 ~ "IG tidak ditemukan di Gmaps",
    similarity >= 0.65 & similarity < 0.75 ~ "Dipertimbangkan",
    similarity >= 0.75 ~ "IG ditemukan di Gmaps"
  )
  )

save(data_final,simi_simi,file = "gmaps cari di grab done.rda")
