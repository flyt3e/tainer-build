# this file should be sourced and not executed



setenv(){
##### Android NDK #####
# https://developer.android.com/ndk/guides/other_build_systems
# https://android.googlesource.com/platform/ndk/+/master/docs/BuildSystemMaintainers.md


# NDK OS variant  host tag
# macOS           darwin-x86_64
# Linux           linux-x86_64
# 64-bit Windows  windows-x86_64
case "$(uname)" in
Linux)
    export HOST_TAG='linux-x86_64'
    ;;
Darwin)
    export HOST_TAG='darwin-x86_64'
    ;;
MSYS*|MINGW*)
    export HOST_TAG='windows-x86_64'
    ;;
*)
    export HOST_TAG="${HOST_TAG:-linux-x86_64}"
    ;;
esac

# name          arch     ABI          triple
# 32-bit ARMv7  arm      armeabi-v7a  arm-linux-androideabi
# 64-bit ARMv8  aarch64  arm64-v8a    aarch64-linux-android
# 64-bit Intel  x86_64   x86_64       x86_64-linux-android
export arch="${arch:-aarch64}"
if [ -z "$arch" ]; then
    export arch='unknown'
fi
export TARGET="${arch}-linux-android"
export ABI="$arch"
if [ "$arch" = 'aarch64' ]; then
    export ABI='arm64-v8a'
elif [ "$arch" = 'arm' ]; then
    export TARGET="${TARGET}eabi"
    export ABI="${arch}eabi-v7a"
elif [ "$arch" = 'x86' ]; then
    export TARGET='i686-linux-android'
fi

# minSdkVersion
export API="${API:-23}"

# set NDK variables
export TOOLCHAIN="${NDK}/toolchains/llvm/prebuilt/${HOST_TAG}"
if [ -z "$OLDPATH" ]; then
    export OLDPATH="$PATH"
fi
export PATH="${TOOLCHAIN}/bin:${PATH}"

export ADDR2LINE="llvm-addr2line"
export AR="llvm-ar"
export AS="llvm-as"
export CC="${TARGET}${API}-clang"
export CXX="${TARGET}${API}-clang++"
if [ "$arch" = 'arm' ]; then
    export CC="armv7a-linux-androideabi${API}-clang"
    export CXX="armv7a-linux-androideabi${API}-clang++"
fi
export CXXFILT="llvm-c++filt"
export DWP="llvm-dwp"
export LD="ld"
export NM="llvm-nm"
export OBJCOPY="llvm-objcopy"
export OBJDUMP="llvm-objdump"
export RANLIB="llvm-ranlib"
export READELF="llvm-readelf"
export SIZE="llvm-size"
export STRIP="llvm-strip"
export STRINGS="llvm-strings"

# arm vfpv3-d16 fix (disable NEON)
if [ "$arch" = 'arm' ]; then
    export CFLAGS="${CFLAGS} -mfloat-abi=softfp -mfpu=vfpv3-d16"
    export CXXFLAGS="${CXXFLAGS} -mfloat-abi=softfp -mfpu=vfpv3-d16"
    export ASMFLAGS="${ASMFLAGS} -mfloat-abi=softfp -mfpu=vfpv3-d16"
fi

# set optimization level
if [ "$APP_DEBUG" = "1" ]; then
    # debug
    export CFLAGS="${CFLAGS} -g -O1"
    export CXXFLAGS="${CXXFLAGS} -g -O1"
    export ASMFLAGS="${ASMFLAGS} -g -O1"
else
    # release
    export CFLAGS="${CFLAGS} -Os"
    export CXXFLAGS="${CXXFLAGS} -Os"
    export ASMFLAGS="${ASMFLAGS} -Os"
fi

# speed up compiling
export CFLAGS="-pipe ${CFLAGS}"
export CXXFLAGS="-pipe ${CXXFLAGS}"
export ASMFLAGS="-pipe ${ASMFLAGS}"

# check path
if [ ! -d "$NDK" ]; then
    echo 'WARN: $NDK path does not exist!'
fi
if [ ! -d "$TOOLCHAIN" ]; then
    echo 'WARN: $TOOLCHAIN path does not exist!'
fi
}

unsetenv(){
if [ -n "$OLDPATH" ]; then
    export PATH="$OLDPATH"
fi
#grep 'export ' $PROJ_ROOT/set-env.sh | sed -e 's/    //g' | sed -e 's/grep.*//g' | sed -e 's/export /unset /g' | sed -e 's/unset PATH.*//g' | sed -e 's/=.*//g' | sort | uniq | uniq -u > oldenv
#. ./oldenv && rm oldenv

unset ABI
unset ADDR2LINE
unset API
unset AR
unset AS
unset ASMFLAGS
unset CC
unset CFLAGS
unset CXX
unset CXXFILT
unset CXXFLAGS
unset DWP
unset HOST_TAG
unset LD
unset NM
unset OBJCOPY
unset OBJDUMP
unset OLDPATH
unset RANLIB
unset READELF
unset SIZE
unset STRINGS
unset STRIP
unset TARGET
unset TOOLCHAIN
unset arch

}

$@