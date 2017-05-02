# Cut the Barstow 1893 into individual page files.
#  rotated, sized and comnpressed for oW-Whaling

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

photos<-Sys.glob(sprintf("%s/originals/Barstow_1893/*",
                         base.dir))

uploads.dir<-sprintf("%s/thumbnails/Barstow_1893",
                     base.dir)

p1.coords<-list(x=c(0,1300),y=c(940,3000))
p2.coords<-list(x=c(1100,3612),y=c(940,3000))

scale.factor<-174/(p1.coords$x[2]-p1.coords$x[1])
quality.control<-'-strip -sampling-factor 4:2:0 -quality 50'

for(i in seq_along(photos)) {
  pic<-photos[i]
  up.dir<-uploads.dir
  if(!file.exists(up.dir)) dir.create(up.dir,recursive=TRUE)
 p1.name<-sprintf("%s/%s.p1.jpg",up.dir,substr(basename(pic),0,nchar(basename(pic))-4))
 system(sprintf("convert -crop %dx%d+%d+%d -resize %dx%d %s '%s' %s",
      as.integer((p1.coords$x[2]-p1.coords$x[1])),
      as.integer((p1.coords$y[2]-p1.coords$y[1])),
      p1.coords$x[1],
      p1.coords$y[1],
      as.integer((p1.coords$x[2]-p1.coords$x[1])*scale.factor),
      as.integer((p1.coords$y[2]-p1.coords$y[1])*scale.factor),
      quality.control,
      pic,p1.name))
 p2.name<-sprintf("%s/%s.p2.jpg",up.dir,substr(basename(pic),0,nchar(basename(pic))-4))
 system(sprintf("convert -crop %dx%d+%d+%d -resize %dx%d %s '%s' %s",
      as.integer((p2.coords$x[2]-p2.coords$x[1])),
      as.integer((p2.coords$y[2]-p2.coords$y[1])),
      p2.coords$x[1],
      p2.coords$y[1],
      as.integer((p2.coords$x[2]-p2.coords$x[1])*scale.factor),
      as.integer((p2.coords$y[2]-p2.coords$y[1])*scale.factor),
      quality.control,
      pic,p2.name))
}       

