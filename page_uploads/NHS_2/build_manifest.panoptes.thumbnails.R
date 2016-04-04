# Make the manifest CSV files for the Albion of Fairhaven thumbnails

for(part in c(1,2,3,4)) {

    log.files<-Sys.glob(sprintf("/data/local/hadpb/oW4.uploads/NHS_2/thumbnails_for_upload_pt%d/*.jpg",part))

    # Redirect ouput to the manifest file
    sink(sprintf("/data/local/hadpb/oW4.uploads/NHS_2/thumbnails_for_upload_pt%d/manifest.csv",part))
    cat('subject_id,image_name_1,origin,ship,port,year\n')
    for(i in seq_along(log.files)) {
      cat(i,',',sep="")
      cat(basename(log.files[i]),',',sep="")
      cat('NARA,')
      cat('Albion,')
      cat('Fairhaven,')
      cat('1854-1857\n')
    }
    sink() # Output back to default
}
  
  

