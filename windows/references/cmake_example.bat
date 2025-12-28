@REN NMake
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64

cd build
cmake -G "NMake Makefiles" ..
NMake
NMake install

@REM Use Native
cmake -A x64 ..
cmake --build . --config Release
cmake --install . --prefix "./install"
