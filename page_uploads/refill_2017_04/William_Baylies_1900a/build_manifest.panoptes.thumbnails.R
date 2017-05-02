# Make the manifest CSV files for the  William Baylies 1900a thumbnails

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

log.files<-Sys.glob(sprintf("%s/thumbnails/William_Baylies_1900a/*.jpg",base.dir))

# Redirect ouput to the manifest file
sink(sprintf("%s/thumbnails/William_Baylies_1900a/manifest.csv",base.dir))
cat('subject_id,image_name_1,origin,ship,port,year\n')
for(i in seq_along(log.files)) {
  cat(i,',',sep="")
  cat(basename(log.files[i]),',',sep="")
  cat('New Bedford,')
  cat('William Baylies,')
  cat('San Francisco,')
  cat('1900\n')
}
sink() # Output back to default
  
  

