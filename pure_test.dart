void main() {
  try {
    var result = DateTime.parse('17:00:00');
    print('DateTime.parse: \$result');
  } catch (e) {
    print('DateTime.parse error: \$e');
  }
}
