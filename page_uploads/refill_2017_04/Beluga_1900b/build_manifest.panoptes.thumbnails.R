# Make the manifest CSV files for the Beluga thumbnails

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

log.files<-Sys.glob(sprintf("%s/thumbnails/Beluga_1900b/*.jpg",base.dir))

# Redirect ouput to the manifest file
sink(sprintf("%s/thumbnails/Beluga_1900b/manifest.csv",base.dir))
cat('subject_id,image_name_1,origin,ship,port,year\n')
for(i in seq_along(log.files)) {
  cat(i,',',sep="")
  cat(basename(log.files[i]),',',sep="")
  cat('New Bedford,')
  cat('Beluga,')
  cat('San Francisco,')
  cat('1900\n')
}
sink() # Output back to default
  
  

