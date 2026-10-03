class ApiKeys {
  // For Weather 
  static String get weatherAPIKEY => "fd5f65764b21427dbd0204608262109";
  static String get weatherBASEURL => "https://api.weatherapi.com/v1";
  static String get currentENDPOINT => "/current.json";
  static String get astronomyENDPOINT => "/astronomy.json";

  // For Products, Users
  static String get baseUrl => "https://dummyjson.com/";

  // For Products
  static String get productENDPOINT => "products";
  static String get addProductENDPOINT => "/add";

  // For Users
  static String get loginENDPOINT => "auth/login";
  static String get registerENDPOINT => "users/add";
  static String get profileENDPOINT => "auth/me";

  // For Restuarants
  static String get restuarantBaseUrl => "https://fakerestaurantapi.runasp.net/api";
  static String get restuarantENDPOINT => "/restaurant";
  static String get userENDPOINT => "/user";
  static String get orderENDPOINT => "/order";

}
