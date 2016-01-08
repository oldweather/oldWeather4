# Functions to render one or more classifications
#  For various markup videos and debugging.

#' Add a label to the presnet viewport.
#'
#' Often the date-time, but can be anything.
#'
#' In the bottom-right.
#'
#' @export
#' @param label - string used as label.
DrawLabel<-function(label) {
   label.gp<-grid::gpar(family='Helvetica',font=1,col='black')
   tg<-grid::textGrob(label,x=unit(0.99,'npc'),
                      y=unit(0.01,'npc'),
                      just=c('right','bottom'),
                      gp=label.gp)
   bg.gp<-grid::gpar(col=par('bg'),fill=par('bg'))
   h<-heightDetails(tg)
   w<-widthDetails(tg)
   xp<-grid::unit(0.99,'npc')
   yp<-grid::unit(0.01,'npc')
   b<-grid::unit(0.2,'char') # border
   grid::grid.polygon(x=unit.c(xp+b,xp-w-b,xp-w-b,xp+b),
                y=unit.c(yp+h+b,yp+h+b,yp-b,yp-b),
                gp=bg.gp)
   grid::grid.draw(tg)
}


# Positions of the page images on screen are controlled
# by a layout - a list with viewports and showing
# which classification is in each viewport.

#' Layout n pages on the screen
#'
#' Depends on page aspect ratio and screen size
#'
#' @export
#' @param x - screen width in pixels
#' @param y - screen height in pixels
#' @param n - how many pages to show at once
#' @param aspect - aspect ratio of page images.
#' @param border - fraction of page to be allocated
#'                 to border around each viewport
#' @return list with components: nx and ny - number of
#'   pages wide by height; contents - vector length nx*ny
#'   showing which classification is in each viewport;
#'   viewports - list length nx*ny giving x,y, width and height
#'   for each page viewport.
Layout<-function(x,y,n,aspect=1.33,border=0.05) {
  if(n==0) n<-1
  layout<-c(n,1)
  scale<-min(x/layout[1],y/layout[2]*aspect)
  height.fraction<-layout[2]*aspect*scale/y
  while(height.fraction<layout[2]/(layout[2]+1)) {
    layout[2]<-layout[2]+1
    layout[1]<-ceiling(n/layout[2])
    scale<-min(x/layout[1],y/layout[2]*aspect)
    height.fraction<-layout[2]*aspect*scale/y
  }
    viewports<-list()
    vp<-1
    x.range<-(1/layout[1]*(1-border))*x
    y.range<-(1/layout[2]*(1-border))*y
    for(j in layout[2]:1) {
        y.offset<-((j-1)/layout[2]+border/4)*y
        for(i in 1:layout[1]) {
            x.offset<-((i-1)/layout[1]+border/4)*x
            viewports[[vp]]<-c(x.offset,y.offset,x.range,y.range)
            vp<-vp+1
        }
    }

  n.l<-list(nx=layout[1],ny=layout[2],contents=rep(NA,layout[1]*layout[2]),
            viewports=viewports)
  return(n.l)
}



#' Interpolate classification positions between two layouts
#'
#' When changing the number of pages shown at once, need
#' to shift between two layouts.
#'
#' @export
#' @param old.layout - starting layout
#' @param new.layout - ending layout
#' @param fraction - 0-1, fraction of new layout
#' @param cls - vector of classification indices
#' @return interpolated layout
InterpolateLayout<-function(old.layout,new.layout,fraction) {
    i.layout<-new.layout
    for(i in seq_along(new.layout$contents)) {
        if(is.na(new.layout$contents[i])) next
        if(new.layout$contents[i] %in% old.layout$contents) {
            w<-which(old.layout$contents==new.layout$contents[i])
            i.layout$viewports[[i]]<-
                new.layout$viewports[[i]]*fraction+
                    old.layout$viewports[[w]]*(1-fraction)
        } else is.na(i.layout$contents[i])<-TRUE
    }
    return(i.layout)
}

#' Update a layout with a new set of classifications
#'
#' Keep the same classifications in the same viewports
#'   as far as possible
#'
#' @export
#' @param old.layout - previous layout to be updated,
#'   can be NULL, if so, start from scratch.
#' @param x - screen width in pixels
#' @param y - screen height in pixels
#' @param cls - vector of classification indices
#' @param aspect - aspect ratio of page images.
#' @param border - fraction of page to be allocated
#'                 to border around each viewport
#' @return list with components: nx and ny - number of
#'   pages wide by height; contents - vector length nx*ny
#'   showing which classification is in each viewport;
#'   viewports - list length nx*ny giving x,y, width and height
#'   for each page viewport.
UpdateLayout<-function(old.layout,x,y,cls,aspect=1.5,border=0.05) {

    n.new<-length(cls)
    # Dont reduce the layout length unless we really have to
    if(length(old.layout$contents)>length(cls) &&
       length(old.layout$contents)/length(cls)<2) {
        n.new<-length(old.layout$contents)
    }
    new.layout<-Layout(x,y,n.new,aspect,border)
    # Simple case - same size
    if(!is.null(old.layout) &&
       old.layout$nx==new.layout$nx &&
       new.layout$ny==new.layout$ny) {
        for(i in seq_along(new.layout$contents)) {
            if(old.layout$contents[i] %in% cls) {
                new.layout$contents[i]<-old.layout$contents[i]
            } else {
                is.na(new.layout$contents[i])<-TRUE
            }
        }
        for(i in cls) {
            if(i %in% new.layout$contents) next
            w<-which(is.na(new.layout$contents))
            new.layout$contents[w[1]]<-i
        }
    } else { # Different sizes - repack
        for(i in seq_along(cls)) {
            new.layout$contents[i]<-cls[i]
        }
     }
    return(new.layout)
 }

#' Draw a single page
#'
#' Call from inside a viewport of the size given in the call
#'
#' @export
#' @param subject_index index of page to be drawn
#' @param pg.width - viewport width in pixels
#' @param pg.height - viewport height in pixels
#' @param before - string date-time, if not NULL (default), draw
#'     only annotations from this time or earlier.
DrawPage<-function(subject_id,pg.width, pg.height,before=NULL) {

img<-GetPageImage(subject_id)
img.height<-dim(img)[1]
img.width<-dim(img)[2]

img.scale<-1/max(img.width/pg.width,img.height/pg.height)

  # Set up a viewport giving only the image, centred on the page
   pushViewport(viewport(width=unit(img.width*img.scale,'native'),
                         xscale=c(0,img.width),
                         height=unit(img.height*img.scale,'native'),
                         yscale=c(0,img.height),
                         x=unit((pg.width-img.width*img.scale)/2,'native'),
                         y=unit((pg.height-img.height*img.scale)/2,'native'),
                         just=c("left","bottom"),name="vp_page"))

  # Draw the background image
   grid.raster(img)

  # Find all the drawable classifications
  q<-mongo.bson.from.list(list('subject_id' = mongo.oid.from.string(subject_id)))
  ann <- mongo.find.all(mongo, "whaletales-production.classifications",q)
  for(i in seq_along(ann)) {
       if(is.null(ann[[i]]$annotation$color)) next # Not drawable
       timestamp<-ann[[i]]$finished_at # String format
       if(!is.null(before) && timestamp>before) next
       crgb<-c(0,0,0)
       if(nchar(ann[[i]]$annotation$color)>0) {
           crgb<-col2rgb(ann[[i]]$annotation$color)/255
       }
       gp<-gpar(col=rgb(crgb[1],crgb[2],crgb[3],0),
                fill=rgb(crgb[1],crgb[2],crgb[3],0.5))
       b<-ann[[i]]$annotation
       if(!is.null(b$x) && !is.null(b$y) &&
          !is.null(b$width) && !is.null(b$height)) {
           b$x<-as.numeric(b$x)*0.58
           b$y<-as.numeric(b$y)*0.58
           b$width<-as.numeric(b$width)*0.58
           b$height<-as.numeric(b$height)*0.58
           grid.polygon(x=unit(c(b$x,b$x+b$width,b$x+b$width,b$x),'native'),
                        y=unit(img.height-c(b$y,b$y,b$y+b$height,b$y+b$height),'native'),
                        gp=gp)
       }
   }

   popViewport()

}

#' Draw a Layout
#'
#' Call from inside a viewport of the size given in the call
#'
#' @export
#' @param classifications - list of classifications from
#'       \code{\link{ReadClassifications}}
#' @param subjects - list of subjects from
#'       \code{\link{ReadSubjects}}
#' @param layout layout to be drawn \code{\link{Layout}}
#' @param pg.width - viewport width in pixels
#' @param pg.height - viewport height in pixels
#' @param before - POSIXt date-time, if not NULL (default), draw
#'     only annotations from this time or earlier.
DrawLayout<-function(layout,before=NULL) {
    for(i in seq_along(layout$contents)) {
        if(is.na(layout$contents[i])) next
        pushViewport(viewport(width=unit(layout$viewports[[i]][3],'native'),
                              xscale=c(0, layout$viewports[[i]][3]),
                              height=unit(layout$viewports[[i]][4],'native'),
                              yscale=c(0,layout$viewports[[i]][4]),
                             x=unit(layout$viewports[[i]][1],'native'),
                             y=unit(layout$viewports[[i]][2],'native'),
                             just=c("left","bottom")))

           DrawPage(layout$contents[i],
                           layout$viewports[[i]][3],
                           layout$viewports[[i]][4],before=before)

        popViewport()
    }
}


