# Make the manifest CSV files for the William Baylies 1901 images

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

log.files<-Sys.glob(sprintf("%s/for_upload/William_Baylies_1901/*.jpg",base.dir))

# Redirect ouput to the manifest file
sink(sprintf("%s/for_upload/William_Baylies_1901/manifest.csv",base.dir))
cat('subject_id,image_name_1,origin,ship,port,year\n')
for(i in seq_along(log.files)) {
  cat(i,',',sep="")
  cat(basename(log.files[i]),',',sep="")
  cat('New Bedford,')
  cat('William Baylies,')
  cat('San Francisco,')
  cat('1901\n')
}
sink() # Output back to default
  
  

