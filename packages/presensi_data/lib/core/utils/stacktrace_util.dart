class StackTraceUtil {
  static StackTrace? fromListString(List<dynamic>? list) {
    if (list == null) return null;

    // Convert the list of strings to a single string
    String stackTraceString = list.join('\n');

    try {
      // Create a StackTrace from the string
      return StackTrace.fromString(stackTraceString);
    } catch (e) {
      return null;
    }
  }
}
