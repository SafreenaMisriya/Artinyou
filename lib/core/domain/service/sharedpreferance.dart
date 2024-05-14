import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  static String useridKey="USERKEY";
  static String usernameKey="USERNAME";
  static String useremailKey="USEREMAIL";
  static String userPicKey="USERPICKEY";
  static String userdisplayname="USERDISPLAYNAME";
  Future<bool>saveId(String getuserid)async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.setString(useridKey, getuserid);
  }
   Future<bool>saveUsername(String getusername)async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.setString(useridKey, getusername);
  }
   Future<bool>saveEmail(String getuseremail)async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.setString(useridKey,getuseremail);
  }
   Future<bool>savePic(String getuserPic)async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.setString(useridKey, getuserPic);
  }
  Future<bool>saveDisplayname(String getuserdisplayname)async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.setString(userdisplayname, getuserdisplayname);
  }
  Future<String ?>getuserid()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString(useridKey);
  }
  Future<String ?>getusername()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString(usernameKey);
  }
  Future<String ?>getuseremail()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString(useremailKey);
  }
  Future<String ?>getuserpic()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString(userPicKey);
  }
  Future<String ?>getuserdisplayname()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString(userdisplayname);
  }
  
}