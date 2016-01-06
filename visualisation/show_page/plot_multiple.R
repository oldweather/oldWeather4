# R script to plot a set of pages

library(oldWeather4)

mongo <- mongo.create(host='localhost' , db='whaletales-production')

subj<-mongo.find.all(mongo,'whaletales-production.subjects',
                     query=list('classification_count' = list('$gte' = 10),
                                'flagged_bad_count' = list('$lte' = 2)))

choice<-sample.int(length(subj),size=5)
                   
page.width<-1080*4/3
page.height<-1080

c.set<-rep('',length(choice))
for(i in seq_along(choice)) c.set[i]<-subj[[choice[i]]][['_id']]

l1<-UpdateLayout(NULL,page.width,page.height,c.set)

png(filename='tst_multiple.png',width=page.width,height=page.height,
    bg='white',pointsize=24)
    pushViewport(viewport(xscale=c(0,page.width),yscale=c(0,page.height)))
    DrawLayout(l1,before=NULL)
    popViewport()
    DrawLabel(paste(c.set,collapse='\n'))
    dev.off()
                
