hugo --cleanDestinationDir --gc
rsync -avz --delete public sjm.io:~/www/sjm.io
