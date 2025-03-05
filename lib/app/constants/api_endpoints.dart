class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 10000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String ipAddress = "192.168.1.6";

  // static const String baseUrl = "http://10.0.2.2:3000/api/" ;
  // static const String baseUrl = "http://192.168.1.4:3000/api/" ;
  static String get baseUrl => "http://$ipAddress:3000/api/";

  // For iPhone
  //static const String baseUrl = "http://localhost:3000/api/v1/";

  // ====================== Auth Routes ======================
  static const String login = "creds/login";
  static const String signup = "creds/signup";

  // static const String imageUrl = "http://10.0.2.2:3000/profile/";
  static const String imageUrl = "http://$ipAddress:3000/profile/";
  static const String uploadImage = "creds/uploadImage";

  // ==================================================================
  static const String items = "items";
  static const String cart = "cart";
  static const String cartByUserId =
      "cart/user"; // Matches /cart/:id or adjust to exact route
  static const String cartById = "cart";
  // static const String itemImageUrl = "http://10.0.2.2:3000/uploads/";
  static const String itemImageUrl = "http://$ipAddress:3000/uploads/";
}
