PKG="app"
PKG_SRC="$PROJ_ROOT/app"
build(){
if [ -e $PROJ_OUT/app-release.apk ]; then
 echo 'skipping build'
else
 # 安装toolkit
 cp $PROJ_ROOT/toolkit/toolkit.sh $PROJ_ROOT/app/app/src/main/assets/usr/
 # 兼容app架构分类方式
 for arch in aarch64 arm x86_64; do
  if [[ "$arch" = "aarch64" ]];then
   mv $PROJ_OUT/bin/aarch64  $PROJ_OUT/bin/aa64
   mv $PROJ_OUT/lib/aarch64  $PROJ_OUT/lib/aa64
   unset arch
   export arch=aa64
  fi
  if [[ "$arch" = "x86_64" ]];then
   mv $PROJ_OUT/bin/x86_64  $PROJ_OUT/bin/x64
   mv $PROJ_OUT/lib/x86_64  $PROJ_OUT/lib/x64
   unset arch
   export arch=x64
  fi
  # 安装运行环境相关
  cp $PROJ_OUT/bin/$arch/* $PROJ_ROOT/app/app/src/main/assets/usr/preload/bin/$arch/
  cp $PROJ_OUT/lib/$arch/libloader.so $PROJ_ROOT/app/app/src/main/assets/usr/preload/lib/$arch/libloader.so
  # for 64bit
  if [ -e $PROJ_OUT/lib/$arch/libloader32.so ]; then
    cp $PROJ_OUT/lib/$arch/libloader32.so $PROJ_ROOT/app/app/src/main/assets/usr/preload/lib/$arch/libloader32.so
  fi
 done
 # 编译
 chmod +x ./gradlew
 ./gradlew build
 install -Dm644 app/build/outputs/apk/release/app-release.apk $PROJ_OUT/app-release.apk
fi
}