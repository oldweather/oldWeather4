# Make the manifest CSV files for the  William Baylies 1899 thumbnails

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

log.files<-Sys.glob(sprintf("%s/thumbnails/William_Baylies_1899/*.jpg",base.dir))

# Redirect ouput to the manifest file
sink(sprintf("%s/thumbnails/William_Baylies_1899/manifest.csv",base.dir))
cat('subject_id,image_name_1,origin,ship,port,year\n')
for(i in seq_along(log.files)) {
  cat(i,',',sep="")
  cat(basename(log.files[i]),',',sep="")
  cat('New Bedford,')
  cat('William Baylies,')
  cat('San Francisco,')
  cat('1899\n')
}
sink() # Output back to default
  
  

