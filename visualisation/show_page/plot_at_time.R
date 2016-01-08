# R script to plot the set of pages active at a particular time

library(oldWeather4)

mongo <- mongo.create(host='localhost' , db='whaletales-production')

# Get all the start and end times for fast indexing
n.classifications <- mongo.count(mongo, "whaletales-production.classifications")
ids<-rep('',n.classifications)
started_at<-rep('',n.classifications)
finished_at<-rep('',n.classifications)
anns<-list()
count<-1
cursor <- mongo.find(mongo, "whaletales-production.classifications")
while (mongo.cursor.next(cursor)) {
    ann<-mongo.cursor.value(cursor)
    ann<-mongo.bson.to.list(ann)
    #anns[[count]]<-ann
    if(is.null(ann$subject_id)) next
    started_at[count]<-ann$started_at
    finished_at[count]<-ann$finished_at
    ids[count]<-as.character(ann$subject_id)
    count<-count+1
}

p1.time<-'2015-12-06T02:00:000Z'
p2.time<-'2015-12-06T02:41:000Z'

w<-which(finished_at<=p2.time & finished_at> p1.time)
c.set<-unique(ids[w])                   

page.width<-1080*4/3
page.height<-1080

l1<-UpdateLayout(NULL,page.width,page.height,c.set)

png(filename='tst_by_date.png',width=page.width,height=page.height,
    bg='white',pointsize=24)
    pushViewport(viewport(xscale=c(0,page.width),yscale=c(0,page.height)))
    DrawLayout(l1,before=NULL)
    popViewport()
    DrawLabel(as.character(p2.time))
    dev.off()
                
