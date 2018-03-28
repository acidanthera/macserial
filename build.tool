#!/bin/bash

cd "$(dirname "$0")" || exit 1

rm -rf bin
mkdir -p bin || exit 1

if [ "$DEBUG" != "" ]; then
  clang -std=c11 -Wall -Wextra -pedantic -Wl,-framework,IOKit -Wl,-framework,CoreFoundation -m32 -mmacosx-version-min=10.4 -O0 -g src/macserial.c -o bin/macserial32 || exit 1
  clang -std=c11 -Wall -Wextra -pedantic -Wl,-framework,IOKit -Wl,-framework,CoreFoundation -m64 -mmacosx-version-min=10.4 -O0 -g src/macserial.c -o bin/macserial64 || exit 1
else
  clang -std=c11 -Wall -Wextra -pedantic -Wl,-framework,IOKit -Wl,-framework,CoreFoundation -m32 -flto -mmacosx-version-min=10.4 -O3 src/macserial.c -o bin/macserial32 || exit 1
  clang -std=c11 -Wall -Wextra -pedantic -Wl,-framework,IOKit -Wl,-framework,CoreFoundation -m64 -flto -mmacosx-version-min=10.4 -O3 src/macserial.c -o bin/macserial64 || exit 1
  strip -x bin/macserial32 || exit 1
  strip -x bin/macserial64 || exit 1
fi

lipo -create bin/macserial32 bin/macserial64 -output bin/macserial || exit 1

rm -f bin/macserial32 bin/macserial64

if [ "$(which i686-w64-mingw32-gcc)" != "" ]; then
  if [ "$DEBUG" != "" ]; then
    i686-w64-mingw32-gcc -std=c11 -Wall -Wextra -pedantic -O0 -g src/macserial.c -o bin/macserial32.exe || exit 1
  else
    i686-w64-mingw32-gcc -s -std=c11 -Wall -Wextra -pedantic -O3 src/macserial.c -o bin/macserial32.exe || exit 1
  fi
fi

exit 0
