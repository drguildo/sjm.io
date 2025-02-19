hugo --cleanDestinationDir --gc
pushd public
rsync -avz --delete . sjm.io:~/www/sjm.io
popd
