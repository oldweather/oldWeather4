# Do the image processing 
# Still need to do the uploads manually and make the SCRIBE
#  manifests later with the updated panoptes subject list.

R --no-save < split.R
R --no-save < split_to_thumbnails.R
R --no-save < build_manifest.panoptes.R
R --no-save < build_manifest.panoptes.thumbnails.R
