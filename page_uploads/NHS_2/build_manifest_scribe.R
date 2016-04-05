# Make the scribe CSV files for the Albion of Fairhaven images

library(jpeg)

# Get the panoptes data for these images
panoptes<-readLines('./panoptes_details.csv')
thumbnails<-readLines('./panoptes_thumbnails.csv')

for(part in c(1,2,3,4)) {

    log.files<-Sys.glob(sprintf("/Users/philip/LocalData/oW4.uploads/NHS_2/for_upload_pt%d/*.jpg",part))

    # Redirect ouput to the manifest file
    sink(sprintf("Albion_pt%d.csv",part))
    cat('order,set_key,file_path,thumbnail,width,height,date_created,zooniverse_id\n')
    for(i in seq_along(log.files)) {

     im<-readJPEG(log.files[i])
      cat(i,',',sep="")
      cat(sprintf ('Albion %d,',part))
      cat(substr(panoptes[i],180,288),',',sep="")
      cat(substr(panoptes[i],180,288),',',sep="")
      cat(dim(im)[2],',',sep="")
      cat(dim(im)[1],',',sep="")
      cat(format(Sys.time(), "%a %b %d %H:%M:%S %Y",tz="UTC"),',',sep="")
      cat(substr(panoptes[i],1,7),'\n',sep="")
    }
    sink() # Output back to default
}
  
  

