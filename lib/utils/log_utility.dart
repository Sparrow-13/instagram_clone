import 'dart:developer' as developer;

class LoggingService {
  /// Logs a statement with class and method information.
  static void logStatement(String statement) {
    final classNameAndMethodName = _getClassNameAndMethodName();
    developer.log('$classNameAndMethodName: $statement');
  }

  /// Retrieves the class and method names from the current stack trace.
  static String _getClassNameAndMethodName() {
    // Get the current stack trace
    final trace = StackTrace.current.toString().split('\n');

    // Extract the relevant line (ignoring the first one since it is this method itself)
    final frame = trace[2];

    // Extract class and method name using a RegExp
    final match = RegExp(r'[#](.+)[.]([^.]+)[.]').firstMatch(frame);

    if (match != null) {
      final className = match.group(1);
      final methodName = match.group(2);
      return '$className - $methodName';
    }

    return 'UnknownClass - UnknownMethod';
  }
}
