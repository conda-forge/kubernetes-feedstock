MKDIR %LIBRARY_BIN%
XCOPY node\bin\*.exe %LIBRARY_BIN%
DEL %LIBRARY_BIN%\kubectl.exe
