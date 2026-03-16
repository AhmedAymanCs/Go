class ApiConstant {
  static const String baseUrl = 'https://dummyjson.com/';
  static const String productEndPoint = 'products';
  static const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "User-Agent": "Mozilla/5.0",
  };
  static const int receiveTimeout = 30;
  static const int connectTimeout = 10;
}
