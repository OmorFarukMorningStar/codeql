private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary

/** Defines calls to  `ActiveStorage::Filename#sanitized` as path sanitizers. */
class ActiveStorageFilenameSanitizedCall extends Path::PathSanitization::Range, DataFlow::CallNode {
  ActiveStorageFilenameSanitizedCall() {
    this.getReceiver() =
      API::getTopLevelMember("ActiveStorage").getMember("Filename").getAnInstantiation() and
    this.asExpr().getExpr().(MethodCall).getMethodName() = "sanitized"
  }
}

/** Taint summary for `ActiveStorage::Filename.new`. */
class ActiveStorageFilenameNewSummary extends SummarizedCallable {
  ActiveStorageFilenameNewSummary() { this = "ActiveStorage::Filename.new" }

  override MethodCall getACall() {
    result =
      API::getTopLevelMember("ActiveStorage")
          .getMember("Filename")
          .getAnInstantiation()
          .asExpr()
          .getExpr()
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = false
  }
}

/** Taint summary for `ActiveStorage::Filename#sanitized`. */
class ActiveStorageFilenameSanitizedSummary extends SummarizedCallable {
  ActiveStorageFilenameSanitizedSummary() { this = "ActiveStorage::Filename#sanitized" }

  override MethodCall getACall() {
    result =
      API::getTopLevelMember("ActiveStorage")
          .getMember("Filename")
          .getInstance()
          .getAMethodCall("sanitized")
          .asExpr()
          .getExpr()
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[-1]" and
    output = "ReturnValue" and
    preservesValue = false
  }
}
