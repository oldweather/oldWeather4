# Make the manifest CSV files for the John and Winthrop images

for(part in c(1)) {

    log.files<-Sys.glob(sprintf("%s/oW4_logbooks/Batch_3_201611/john_winthrop/for_upload_pt%d/*.jpg",Sys.getenv('SCRATCH'),part))

    # Redirect ouput to the manifest file
    sink(sprintf("%s/oW4_logbooks/Batch_3_201611/john_winthrop/for_upload_pt%d/manifest.csv",Sys.getenv('SCRATCH'),part))
    cat('subject_id,image_name_1,origin,ship,port,year\n')
    for(i in seq_along(log.files)) {
      cat(i,',',sep="")
      cat(basename(log.files[i]),',',sep="")
      cat('New Bedford,')
      cat('John & Winthrop,')
      cat('San Francisco,')
      cat('1912\n')
    }
    sink() # Output back to default
}
  
  

