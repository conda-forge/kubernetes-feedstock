MKDIR %LIBRARY_BIN%
XCOPY node\bin\*.exe %LIBRARY_BIN%
RM %LIBRARY_BIN%\kubectl.exe
