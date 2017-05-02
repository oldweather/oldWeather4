# Make the manifest CSV files for the Belugs 1893b images

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

log.files<-Sys.glob(sprintf("%s/for_upload/Beluga_1893b/*.jpg",base.dir))

# Redirect ouput to the manifest file
sink(sprintf("%s/for_upload/Belugs_1893b/manifest.csv",base.dir))
cat('subject_id,image_name_1,origin,ship,port,year\n')
for(i in seq_along(log.files)) {
  cat(i,',',sep="")
  cat(basename(log.files[i]),',',sep="")
  cat('Providence Public Library,')
  cat('Beluga,')
  cat('San Francisco,')
  cat('1893b\n')
}
sink() # Output back to default
  
  

