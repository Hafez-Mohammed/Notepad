String? customValidator(String? val, String type) {
  if (val!.isEmpty) {
    return type + " can not be empty";
  }
  if (type == "password" && val.trim().length < 8 || type == "confirm password" && val.trim().length < 8) {
    return type + " can not be less than 8 letter";
  }
  if (type == "user name" && val.trim().length < 4) {
    return type + " can not be less than 4 letter";
  }
  return null;
}
