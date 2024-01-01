# onluaerror-sv-cl
Garry's Mod OnLuaError hook pure Lua implementation for Server and Client realms.

## Want to use this in your addon?

Keep the file in to `lua/autorun` and **never** change the file name. This is to keep it shared between addons.

### Note

With the exception of errors from `ProtectedCall()`, any error that does not halt the code will not call this hook as they aren't sent to the Error Handler.

**Notable errors that aren't sent to the handler:**

1. Errors from `Error()`
2. Errors from `ErrorNoHalt()`
3. Errors from `ErrorNoHaltWithStack()`
4. Compile fails from `CompileString()`
5. Compile fails from `CompileFile()`
6. Not a lua file or missing file fails from `include()`
