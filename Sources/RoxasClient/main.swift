import Roxas

@RSTLocalizedError
struct TestError
{
}

var error = TestError()
error.errorFailure = ""
error.sourceFile = #fileID
error.sourceLine = #line
