# Make the manifest CSV files for the Belvedere 1894 images

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

log.files<-Sys.glob(sprintf("%s/thumbnails/Belvedere_1894/*.jpg",base.dir))

# Redirect ouput to the manifest file
sink(sprintf("%s/thumbnails/Belvedere_1894/manifest.csv",base.dir))
cat('subject_id,image_name_1,origin,ship,port,year\n')
for(i in seq_along(log.files)) {
  cat(i,',',sep="")
  cat(basename(log.files[i]),',',sep="")
  cat('Providence Public Library,')
  cat('Belvedere,')
  cat('San Francisco,')
  cat('1894\n')
}
sink() # Output back to default
  
  

