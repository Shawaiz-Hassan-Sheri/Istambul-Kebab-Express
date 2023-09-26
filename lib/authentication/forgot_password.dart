
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:users_food_app/authentication/services/appcontroller.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //LOGIN METHODS
  void submitPressed() async {
    if (email.text.isEmpty)
      showAlertDialog("Please enter email address");
    else
    {
      dynamic result = await forgotPassword(email.text);

      if (result['Status'] == "Success")
      {
        Navigator.of(context).pop();
        showAlertDialog("We have emailed you password reset email. Please use it to change your password.\nThanks");
      }
      else {
        //Fail Cases Show String
        showAlertDialog(result['ErrorMessage'],);
      }
    }
  }
  //FORGOT PASSWORD
  Future forgotPassword(String email) async {
    try {
      String result = "";
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email).then((_) async {
        result = "Success";
      }).catchError((error) {
        result = error.toString();
        print("Failed emailed : $error");
      });

      if (result == "Success") {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = result;
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.code;
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  Map setUpFailure() {
    Map finalResponse = <dynamic, dynamic>{}; //empty map
    finalResponse['Status'] = "Error";
    finalResponse['ErrorMessage'] = "Please try again later. Server is busy.";
    return finalResponse;
  }
  void showAlertDialog(String message){
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Try Again'),
        content: Text(message),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  Colors.amber[700],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        //brightness: Brightness.dark,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: (height/100) * 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Image.asset('images/logo.png'),
              ),

              Container(
                margin: EdgeInsets.only(top: (height/100) * 5),
                child: Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.01 * 2.5,
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: (height/100) * 1, left: 30, right: 30),
                child: Text(
                  'Please enter your email to receive password reset link',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.01 * 2.0,
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: (height/100) * 5),
                height: (height/100) * 8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.grey,),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),

              Container(
                height: (height/100)* 8,
                margin: EdgeInsets.only(top: (height/100) * 4, left: 30, right: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    primary: Colors.white,
                  ),
                  onPressed: (){
                    submitPressed();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                          color:  Colors.black,
                          fontSize: height * 0.01 * 2.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}