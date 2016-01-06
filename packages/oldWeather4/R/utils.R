# Utility functions for oW4 data.

#' Get all the types of annotation
#'
#' Get the names of each type of classification in the database.
#'
#' @export
#' @param mongo database connection.
#' @return names for each classification type.
FindTypes<-function(mongo) {
    tasks<-list()
    cursor <- mongo.find(mongo, "whaletales-production.classifications")
    while (mongo.cursor.next(cursor)) {
        ann<-mongo.cursor.value(cursor)
        if(!is.null(ann$task_key)) tasks[[ann$task_key]]<-1
    }
    print(names(tasks))
}

#' Get a raster image of a selected page
#'
#' Download the image from the website (unless it's already cached).
#'
#' @export
#' @param mongo database connection.
#' @param subject_id index of the selected subject (as string)
#' @return raster of the image.
GetPageImage<-function(subject_id) {
  if(Sys.getenv('SCRATCH')=="") stop("Unspecified SCRATCH directory")
  cache.dir<-sprintf("%s/oW4.cache/",Sys.getenv('SCRATCH'))
  if(!file.exists(cache.dir)) dir.create(cache.dir,recursive=TRUE)
  local.name<-as.character(subject_id)
  local.filename<-sprintf("%s/%s",cache.dir,local.name)
  if(file.exists(local.filename) && file.info(local.filename)$size>0) {
    img<-readJPEG(local.filename,native=FALSE)
    return(img)
  }
  # Retrieve the image from the site
  subj<-mongo.find.all(mongo, "whaletales-production.subjects",
                      query=list('_id' =
                          mongo.oid.from.string(subject_id)))
  res<-download.file(subj[[1]]$location$standard,
                     local.filename,method='wget',quiet=TRUE)
  if(res!=0) stop(sprintf("Failed download of %s to $s",url,local.filename))
  img<-readJPEG(local.filename,native=FALSE)
  return(img)
}
