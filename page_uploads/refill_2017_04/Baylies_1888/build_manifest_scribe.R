# Make the scribe CSV files for the Baylies 1888 images
# Need to have uploaded them to panoptes and extracted the subjects first

library(jpeg)

# Get the panoptes subject data
panoptes<-read.csv('../../old-weather-subjects.csv')


log.files<-Sys.glob(sprintf("%s/oW4_logbooks/refill_2017_04/for_upload/Baylies_1888/*.jpg",
                            Sys.getenv('SCRATCH')))

# Redirect ouput to the manifest file
sink(sprintf("group_Baylies_1888.csv",part))
cat('order,set_key,file_path,thumbnail,width,height,date_created,zooniverse_id\n')
for(i in seq_along(log.files)) {

 im<-readJPEG(log.files[i])
 w<-grep(basename(log.files[i]),panoptes$metadata)
 if(length(w)!=2) stop ("Can't find images in panoptes")
 r<-regexpr('https://panoptes-uploads.*.jpeg',
               panoptes$locations[w[1]])
 p.main<-regmatches(panoptes$locations[w[1]],r)
 r<-regexpr('https://panoptes-uploads.*.jpeg',
            panoptes$locations[w[2]])
 p.thumb<-regmatches(panoptes$locations[w[2]],r)
  cat(i,',',sep="")
  cat('Baylies 1888')
  cat(p.main,',',sep="")
  cat(p.thumb,',',sep="")
  cat(dim(im)[2],',',sep="")
  cat(dim(im)[1],',',sep="")
  cat(format(Sys.time(), "%a %b %d %H:%M:%S %Y",tz="UTC"),',',sep="")
  cat(panoptes$subject_id[w[1]],'\n',sep="")
}
sink() # Output back to default


