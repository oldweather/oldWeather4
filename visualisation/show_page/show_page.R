# Draw a single whaling page, overlain with all its annotations.

library(oldWeather4)

mongo <- mongo.create(host='localhost' , db='whaletales-production')

subject_id<-'5604665e3937640006a70800'

page.width<-1080*4/3
page.height<-1080

png(filename='tst_single.png',width=page.width,height=page.height,
    bg='white',pointsize=24)
    pushViewport(viewport(xscale=c(0,page.width),yscale=c(0,page.height)))
    DrawPage(subject_id,page.width,page.height,
                        before=NULL)
    popViewport()
    #DrawLabel(as_character(subject_id))
    dev.off()

