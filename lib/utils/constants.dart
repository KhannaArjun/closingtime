import 'package:fluttertoast/fluttertoast.dart';

class Constants
{
  //static const String BASE_URL = "http://127.0.0.1:5000";
  //static const String BASE_URL = "https://closingtime.herokuapp.com";
  // static const String BASE_URL = "https://closingtime-prod.herokuapp.com"; // Prod
  static const String BASE_URL = "https://closingtimeapi.onrender.com"; // Prod
  static const String DEFAULT_IMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/closingtime-e1fe0.appspot.com/o/prod%2Ffood_images%2Fdefault_image.jpeg?alt=media&token=2aa742d7-5d33-4f1a-bf69-57bbce5a22a1";
  static const Map<String, String> HEADERS = {'Content-Type': 'application/json'};

  static const String empty = "No data";
  static const String user_exists = "User already exists";
  static const String new_user = "new user";
  static const String user_id = "user_id";
  static const String role = "role";
  static const String name = "name";
  static const String business_name = "business_name";
  static const String serving_distance = "serving_distance";
  static const String email = "email";
  static const String contact = "contact";
  static const String address = "address";
  static const String lat = "lat";
  static const String lng = "lng";
  static const String firebase_token = "firebase_token";

  static const String ROLE_RECIPIENT = "Recipient";
  static const String ROLE_DONOR = "Donor";
  static const String ROLE_VOLUNTEER = "Volunteer";
  static const String STATUS_AVAILABLE = "Available";
  static const String success = "Success";
  static const String waiting_for_pickup = "Waiting for pickup";
  static const String pick_up_scheduled = "Pick up scheduled";
  static const String delivered = "Delivered";
  static const String expired = "Pick up date passed / No response";
  static const String prod = "prod";
  static const String dev = "dev";
  static const String updated = "updated";

  static const String something_went_wrong = "Something went wrong, please try again";

  static const String FB_FOOD_ADDED_TOPIC = "food_added";

  static void showToast(msg)
  {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
  }



  static List<String> getAllStatesList()
  {
    List<String> statesList = "Alabama,Alaska,American Samoa,Arizona,Arkansas,California,Colorado,Connecticut,Delaware,District Of Columbia,Federated States Of Micronesia,Florida,Georgia,Guam,Hawaii,Idaho,Illinois,Indiana,Iowa,Kansas,Kentucky,Louisiana,Maine,Marshall Islands,Maryland,Massachusetts,Michigan,Minnesota,Mississippi,Missouri,Montana,Nebraska,Nevada,New Hampshire,New Jersey,New Mexico,New York,North Carolina,North Dakota,Northern Mariana Islands,Ohio,Oklahoma,Oregon,Palau,Pennsylvania,Puerto Rico,Rhode Island,South Carolina,South Dakota,Tennessee,Texas,Utah,Vermont,Virgin Islands,Virginia,Washington,West Virginia,Wisconsin,Wyoming,".split(',');
    return statesList;
  }
}