import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Widgets/input.dart';
import 'dart:convert';
import 'package:e_360/Models/Staff.dart';
import 'package:e_360/Widgets/frame.dart';
import 'package:e_360/Screens/profile.dart';
import 'package:ota_update/ota_update.dart';
import 'dart:io' show Platform;
import 'package:package_info_plus/package_info_plus.dart';

class Login extends HookWidget {
  final String title;
  Login({super.key, required this.title});

  OtaEvent? event;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(debugLabel: '');
    final _usernameController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _newPasswordController = useTextEditingController();
    final _confirmPasswordController = useTextEditingController();
    final focussed = useState<bool>(false);
    final inputState = useState<String>('');
    final loading = useState<bool>(false);
    final updateState = useState<dynamic>('');
    final forgottenPassword = useState<bool>(false);
    final connectionError = useState<String?>(null);
    // final isValid = useState<bool>(_formKey.currentState!.validate());

    useEffect(() {
      inputState.value = _usernameController.text;
    }, [_usernameController, _passwordController]);

    validateUsername(String value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a Username';
      }
      return null;
    }

    validatePassword(String value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a Password';
      }
      return null;
    }

    Future<void> _showMyDialog(Map data) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: data['status'] == false
                ? const Text('Unsuccessful')
                : const Text('Success'),
            // title: Text('Unsuccessful'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // Text('Invalid details'),
                  Text(data['message'])
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    String getTime() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
    }

    void login() async {
      loading.value = true;
      Uri url =
          Uri.parse('http://10.0.0.184:8015/userservices/mobile/authenticatem');
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300"
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      final result = await http.post(url,
          headers: headers,
          body: jsonEncode({
            // 'UsN': _usernameController.text,
            // 'Pwd': _passwordController.text,
            'UsN': 'SN11536',
            'Pwd': 'Password6\$1',
            'xAppSource': "AS-IN-D659B-e3M"
          })).timeout(Duration(seconds: 10)).catchError((err) => {
            loading.value = false,
            connectionError.value = 'Check your internet connection'
          });
      if (result.statusCode == 200) {
        if (jsonDecode(result.body)?['status'] == false) {
          _showMyDialog(jsonDecode(result.body));
        }
        loading.value = false;
        final Staff data = Staff.fromJson(jsonDecode(result.body)['data']);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Frame(staff: data)));
      } else {
        loading.value = false;
      }
    }

    Future<void> resetPassword() async {
      loading.value = true;
      Uri url =
          Uri.parse('http://10.0.0.184:8015/userservices/passreset');
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300"
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      var body = {
        "rUsN": "SN11536",
  "rOldPwd": "Password6\$",
  "rNewPwd": _newPasswordController.value,
  "rONewPwdVrfy": _confirmPasswordController,
  "xAppSource": "AS-IN-D659B-e3M"
      };

      final result = http.post(url, headers: headers, body: body)
      .then((result) => {
        print(result)
      });
    }

    void checkForUpdate() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;

      Uri url = Uri.parse('http://10.0.0.94:5000/get_latest_version');
      // Uri url =
      //     Uri.parse('http://10.0.0.184:8015/updates/checkappversiondetails');

      // var token = {
      //   'br':
      //       "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300"
      // };
      // var headers = {
      //   'x-lapo-eve-proc': jsonEncode(token),
      //   'Content-type': 'text/json',
      // };
      // final result = await http.post(url,
      //     headers: headers,
      //     body: jsonEncode({
      //       "xTransRef": "string",
      //       "xTransScope": "129dekekddkffmf2sv25",
      //       "xAppTransScope": "9e9efefech009eee",
      //       "xAppSource": "AS-IN-D659B-e3M"
      //     }));
      // print(result.body);

      // if (result.statusCode == 200) {
      //   var data = jsonDecode(result.body);
      //   print('was successful');
      //   print(data);
      // }

      await http.get(url)
      .then((value) => print(value.body))
      .catchError((err) => print(err));
    }

      Future<void> tryOtaUpdate() async {
      try {
        //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
        OtaUpdate()
            .execute(
              'http://10.0.0.94:5000/apk/E360_alpha.apk',
          // 'https://internal1.4q.sk/flutter_hello_world.apk',
          destinationFilename: 'E360_alpha.apk',
          //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
          // sha256checksum: 'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
        )
            .listen(
          (OtaEvent event) {
            print(event.value);
            print(event.status);
            updateState.value = event;
          },
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print('Failed to make OTA update. Details: $e');
      }
    }

    // useEffect(() {
    //   tryOtaUpdate();
    //   // checkForUpdate();
    // }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.help, color: Color(0xff15B77C)))
        ],
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'images/lapo_360.png',
              width: 200,
              height: 150,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: Text(
              "$getTime() Boss",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                        width: 330,
                        child: CustomInput(
                          controller: _usernameController,
                          hintText: 'your username',
                          labelText: 'Username',
                          validation: validateUsername,
                          isPassword: false,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: forgottenPassword.value == false
                        ? SizedBox(
                            width: 330,
                            child: CustomInput(
                              controller: _passwordController,
                              hintText: 'your password',
                              labelText: 'Password',
                              validation: validatePassword,
                              isPassword: true,
                            ))
                        : SizedBox(
                            width: 330,
                            child: CustomInput(
                              controller: _passwordController,
                              hintText: 'Enter Old Password',
                              labelText: 'Enter Old Password',
                              validation: validatePassword,
                              isPassword: true,
                            )),
                  ),
                  Container(
                    margin: forgottenPassword.value == true ? const EdgeInsets.only(top: 20) : null,
                    height: forgottenPassword.value == true ? 160 : null,
                      child: forgottenPassword.value == true
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 330,
                                    child: CustomInput(
                                      controller: _newPasswordController,
                                      hintText: 'Enter New Password',
                                      labelText: 'Enter New Password',
                                      validation: validatePassword,
                                      isPassword: true,
                                    )),
                                SizedBox(
                                    width: 330,
                                    child: CustomInput(
                                      controller: _confirmPasswordController,
                                      hintText: 'Confirm New Password',
                                      labelText: 'Confirm New Password',
                                      validation: validatePassword,
                                      isPassword: true,
                                    )),
                              ],
                            )
                          : null),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        height: 64.0,
                        minWidth: 320.0,
                        color: const Color(0xff15B77C),
                        textColor: Colors.white,
                        disabledColor: const Color(0xffA6D2C2),
                        onPressed: () {
                          // if (_formKey.currentState!.validate() && forgottenPassword.value == false) {
                          //   login();
                          // }
                          // else if(_formKey.currentState!.validate() && forgottenPassword.value == true) {
                          //    resetPassword();
                          // }
                          login();
                        },
                        splashColor: Colors.redAccent,
                        child: loading.value == false &&
                                forgottenPassword.value == false
                            ? const Text("Sign in",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 22))
                            : loading.value == true &&
                                    forgottenPassword.value == false
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 5,
                                  )
                                : loading.value == false &&
                                        forgottenPassword.value == true
                                    ? const Text("Reset Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 22))
                                    : loading.value == true &&
                                            forgottenPassword.value == true
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 5,
                                          )
                                        : null),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                        onPressed: () {
                          forgottenPassword.value = !forgottenPassword.value;
                        },
                        child: forgottenPassword.value == true ? const Text('Cancel Password Reset',
                            style: TextStyle(color: Color(0xff15B77C))) : const Text('Forgot Password',
                            style: TextStyle(color: Color(0xff15B77C)))
                            ),
                  ),
                  Container(child: connectionError.value != null ? Column(children: [
                    Container(
                    alignment: Alignment.center,
                    child: const Icon(Icons.signal_wifi_connected_no_internet_4, color: Color(0xffEF9545),size: 80),
                  ),
                   Padding(padding: const EdgeInsets.only(top: 20), child: Text(connectionError.value ?? '', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),)
                  ],) : null,)
                 
                 
                  // Container(
                  //   child: Text('OTA status: ${updateState.value?.status} : ${updateState.value?.value} \n'),
                  // )
                ],
              ))
        ],
      ),
    );
  }
}
