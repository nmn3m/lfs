
CHAPTER="$1"
PACKAGE="$2"
echo "$CHAPTER"
echo "$PACKAGE"

echo "starting the script"
cat packages.csv | grep -i "^$PACKAGE;" | grep -i -v "\.patch;" | while read line; do
    export VERSION="`echo $line | cut -d\; -f2`"
    URL="`echo $line | cut -d\; -f3 | sed "s/@/$VERSION/g"`"

    CACHEFILE="$(basename "$URL")" 

    DIRNAME="$(echo $CACHEFILE | sed 's/\(.*\)\.tar\..*/\1/')"  # echo foo-1.2.2.tar.xz | sed 's/\(.*\)\.tar\..*/\1/' -> foo-1.2.2

    mkdir -pv "$DIRNAME"

    echo "Extracting $CACHEFILE"

    tar -xf  "$CACHEFILE" -C "$DIRNAME"

    # we cd in dir but keep our directory in stack 
    pushd "$DIRNAME"
        # if not all in 1 folder move them under 1 folder
        if [ "$(ls -1A | wc -l )" == "1" ]; then
            # move everthing from subdirectory to the current directory 
            mv $(ls -1A)/* ./
        fi 

        echo "Compiling $PACKAGE"
        # give me time to check what happens 
        sleep 5 
        # make dir to store logs for every compilation.
        mkdir -pv "../log/chapter$CHAPTER/"
            # 2>&1 direct error from std err to std out 
        if ! source "../chapter$CHAPTER/$PACKAGE.sh" 2>&1 | tee "../log/chapter$CHAPTER/$PACKAGE.log" ; then
            echo "Compiling $PACKAGE failed"
            popd
            exit 1
        fi 

        echo "Done compiling $PACKAGE"

    popd

done