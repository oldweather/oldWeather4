# Cut the Belvedere 1894 into individual page files.
#  rotated, sized and comnpressed for oW-Whaling

base.dir<-sprintf("%s/oW4_logbooks/refill_2017_04",Sys.getenv('SCRATCH'))

photos<-Sys.glob(sprintf("%s/originals/Belvedere_1894/*",
                         base.dir))

uploads.dir<-sprintf("%s/for_upload/Belvedere_1894",
                     base.dir)

p1.coords<-list(x=c(0,1200),y=c(700,2250))
p2.coords<-list(x=c(1000,2180),y=c(700,2250))

scale.factor<-1400/(max(p1.coords$x[2]-p1.coords$x[1],
                        p1.coords$y[2]-p1.coords$y[1],
                        p2.coords$x[2]-p2.coords$x[1],
                        p2.coords$y[2]-p2.coords$y[1]))
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

