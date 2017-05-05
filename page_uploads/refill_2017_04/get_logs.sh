# get the logbook images from Archive.org and Kevin's GDrive

cd $SCRATCH/oW4_logbooks/refill_2017_04

wget https://archive.org/download/logbookofbelugas00unse/logbookofbelugas00unse_orig_jp2.tar
tar xf ../logbookofbelugas00unse_orig_jp2.tar
#rm logbookofbelugas00unse_orig_jp2.tar

wget https://archive.org/download/logbookofbelugaste00unse/logbookofbelugaste00unse_orig_jp2.tar
tar xf logbookofbelugaste00unse_orig_jp2.tar
#rm logbookofbelugaste00unse_orig_jp2.tar

wget https://archive.org/download/logbookofwilliam00will_1/logbookofwilliam00will_1_orig_jp2.tar
tar xf logbookofwilliam00will_1_orig_jp2.tar
#rm logbookofwilliam00will_1_orig_jp2.tar

wget https://archive.org/download/logbookofwilliam00will_3/logbookofwilliam00will_3_orig_jp2.tar
tar xf logbookofwilliam00will_3_orig_jp2.tar
#rm logbookofwilliam00will_3_orig_jp2.tar

wget https://archive.org/download/williambayliesst00will/williambayliesst00will_orig_jp2.tar
tar xf williambayliesst00will_orig_jp2.tar
#rm williambayliesst00will_orig_jp2.tar

moo get moose:/adhoc/users/philip.brohan/logbook_images/oW_Whaling/OWW2-20170428T092040Z-001.zip .
unzip -DD OWW2-20170428T092040Z-001.zip
