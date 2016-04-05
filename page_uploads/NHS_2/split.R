# Cut the Albion of Fairhaven images into individual page files.

photos<-Sys.glob('/Users/philip/LocalData/oW4.uploads/NHS_2/raw_images/*')

uploads.dir<-'/Users/philip/LocalData/oW4.uploads/NHS_2/for_upload'
if(!file.exists(uploads.dir)) dir.create(uploads.dir,recursive=TRUE)

p1.coords<-list(x=c(850,3225),y=c(100,3575))
p2.coords<-list(x=c(2900,5350),y=c(100,3575))

scale.factor<-1400/(3575-100)
quality.control<-'-strip -sampling-factor 4:2:0 -quality 50'

for(i in seq_along(photos)) {
  pic<-photos[i]
  up.dir<-sprintf("%s_pt%d",uploads.dir,as.integer(i/25)+1)
  if(!file.exists(up.dir)) dir.create(up.dir,recursive=TRUE)
 p1.name<-sprintf("%s/%s_p1.jpg",up.dir,
      substr(basename(pic),1,nchar(basename(pic))-4))
 system(sprintf("convert -crop %dx%d+%d+%d -resize %dx%d %s '%s' %s",
      as.integer((p1.coords$x[2]-p1.coords$x[1])),
      as.integer((p1.coords$y[2]-p1.coords$y[1])),
      p1.coords$x[1],
      p1.coords$y[1],
      as.integer((p1.coords$x[2]-p1.coords$x[1])*scale.factor),
      as.integer((p1.coords$y[2]-p1.coords$y[1])*scale.factor),
      quality.control,
      pic,p1.name))
 p2.name<-sprintf("%s/%s_p2.jpg",up.dir,
      substr(basename(pic),1,nchar(basename(pic))-4))
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

