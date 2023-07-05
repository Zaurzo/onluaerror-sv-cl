# onluaerror-sv-cl
Garry's Mod OnLuaError hook pure-lua implementation for Server and Client realms.

**Note**

With the exception of errors from `ProtectedCall()`, any error that does not halt the code will not call this hook as they aren't sent to the Error Handler.

**Notable errors that aren't sent to the handler:**
```
Error() - call
ErrorNoHalt() - call
ErrorNoHaltWithStack() - call
CompileString() - compile fail
CompileFile() - compile fail
include() - not a lua file or missing file fail
```
