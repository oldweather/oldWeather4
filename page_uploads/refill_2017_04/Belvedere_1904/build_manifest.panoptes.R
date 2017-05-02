# Make the manifest CSV files for the Belvedere 1904 images

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

log.files<-Sys.glob(sprintf("%s/for_upload/Belvedere_1904/*.jpg",base.dir))

# Redirect ouput to the manifest file
sink(sprintf("%s/for_upload/Belvedere_1904/manifest.csv",base.dir))
cat('subject_id,image_name_1,origin,ship,port,year\n')
for(i in seq_along(log.files)) {
  cat(i,',',sep="")
  cat(basename(log.files[i]),',',sep="")
  cat('Providence Public Library,')
  cat('Belvedere,')
  cat('San Francisco,')
  cat('1904\n')
}
sink() # Output back to default
  
  

