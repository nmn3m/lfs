

mkdir -v build
cd build 

../libstdc++-v3/configure \
    --host=$LFS_TGT \
    --build=$(../config.guess)\
    --prefix=/usr \
    --disable-nls \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$VERSION \
&& make \ 
&& make DESTDRIR=$LFS install 