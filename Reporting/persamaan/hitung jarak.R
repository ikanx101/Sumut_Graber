# functions ini untuk di-run sekaligus

# load libraries
library(stringdist)

# fungsi untuk menghitung simmilarity
kesamaan = function(a,b){
  jarak_1 = stringdist(a,b,method = "jaccard")
  jarak_2 = stringdist(a,b,method = "cosine")
  output = mean(jarak_1,jarak_2)
  return(output)
}

# fungsi untuk membersihkan string
bersihin = function(text){
  text %>% 
    unique() %>% 
    janitor::make_clean_names() %>% 
    gsub("\\_"," ",.)
}
