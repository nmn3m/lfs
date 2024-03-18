


cat packages.csv | while read line; do
    # extracting process
    NAME="`echo $line | cut -d\; -f1`"
    VERSION="`echo $line | cut -d\; -f2`"
    # using sed to replace @ with the suitable version
    URL="`echo $line | cut -d\; -f3 | sed "s/@/$VERSION/g"`"
    MD5SUM="`echo $line | cut -d\; -f4`"

    # extract the filename from the url
    CACHEFILE="$(basename "$URL")"

    # echo NAME $NAME
    # echo VERSION $VERSION
    # echo URL $URL
    # echo MD5SUM $MD5SUM
    # echo CACHEFILE $CACHEFILE

    # check if the file is on system or not if not proceed'
    # check for wget (is it temp or not) // add the condition for md5 sum 
    if [ ! -f "$CACHEFILE" ]; then 
        echo " Downloading $URL"
        wget "$URL"
        if ! echo "$MD5SUM $CACHEFILE" | md5sum -c >/dev/null; then
            rm -f "$CACHEFILE"
            echo "Verification of $CACHEFILE failed! MD5 mismatch!"
            exit 1
        fi
    fi
done 