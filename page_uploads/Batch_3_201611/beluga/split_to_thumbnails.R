# Cut the Beluga images into individual page files.
#  rotated, sized and comnpressed for oW-Whaling

photos<-Sys.glob(sprintf("%s/oW4_logbooks/Batch_3_201611/beluga/logbookofbelugastea00unse_orig_jp2/*",
                         Sys.getenv('SCRATCH')))

uploads.dir<-sprintf("%s/oW4_logbooks/Batch_3_201611/beluga/thumbnails_for_upload",
                     Sys.getenv('SCRATCH'))

p1.coords<-list(x=c(0,5616),y=c(0,3744)) # No crop

scale.factor<-174/(p1.coords$x[2]-p1.coords$x[1])
quality.control<-'-strip -sampling-factor 4:2:0 -quality 50'

for(i in seq_along(photos)) {
  if(i>75) break # Blank after this
  pic<-photos[i]
  up.dir<-sprintf("%s_pt%d",uploads.dir,as.integer(i/50)+1)
  if(!file.exists(up.dir)) dir.create(up.dir,recursive=TRUE)
 p1.name<-sprintf("%s/%s.jpg",up.dir,substr(basename(pic),0,nchar(basename(pic))-4))
 rotate=270
 if(i%%2==0) rotate=90 # even pages are the other way up
 system(sprintf("convert -resize %dx%d -rotate %d %s '%s' %s",
      as.integer((p1.coords$x[2]-p1.coords$x[1])*scale.factor),
      as.integer((p1.coords$y[2]-p1.coords$y[1])*scale.factor),
      rotate,
      quality.control,
      pic,p1.name))
}       

