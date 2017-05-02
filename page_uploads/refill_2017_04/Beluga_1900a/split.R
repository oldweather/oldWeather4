# Cut the Beluga 1900a into individual page files.
#  rotated, sized and comnpressed for oW-Whaling

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

photos<-Sys.glob(sprintf("%s/originals/logbookofbelugas00unse_orig_jp2/*",
                         base.dir))

uploads.dir<-sprintf("%s/for_upload/Beluga_1900a",
                     base.dir)

p1.coords<-list(x=c(0,5616),y=c(0,3744)) # No crop

scale.factor<-1400/(p1.coords$x[2]-p1.coords$x[1])
quality.control<-'-strip -sampling-factor 4:2:0 -quality 50'

# 1900a is images 1-41 from this log (image 0 is a calibration pic)
for(i in seq(1,41)) {
  pic<-photos[i+1]
  up.dir<-uploads.dir
  if(!file.exists(up.dir)) dir.create(up.dir,recursive=TRUE)
 p1.name<-sprintf("%s/%s.jpg",up.dir,substr(basename(pic),0,nchar(basename(pic))-4))
 rotate=270
 if(i%%2==1) rotate=90 # even pages are the other way up
 system(sprintf("convert -resize %dx%d -rotate %d %s '%s' %s",
      as.integer((p1.coords$x[2]-p1.coords$x[1])*scale.factor),
      as.integer((p1.coords$y[2]-p1.coords$y[1])*scale.factor),
      rotate,
      quality.control,
      pic,p1.name))
}       

