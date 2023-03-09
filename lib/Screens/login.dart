import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Widgets/input.dart';
import 'dart:convert';
import 'package:e_360/Models/Staff.dart';
import 'package:e_360/Widgets/frame.dart';
import 'package:e_360/Screens/profile.dart';
import 'package:ota_update/ota_update.dart';
// import 'dart:io' show Platform;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import "package:hex/hex.dart";
import 'dart:math';
import 'dart:typed_data';
import 'package:e_360/helpers/aes.dart';
import 'package:convert/convert.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Login extends HookConsumerWidget {
  final String title;
  Login({super.key, required this.title});

  OtaEvent? event;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    final _formKey = GlobalKey<FormState>(debugLabel: '');
    final _usernameController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _newPasswordController = useTextEditingController();
    final _confirmPasswordController = useTextEditingController();
    final focussed = useState<bool>(false);
    final inputState = useState<String>('');
    final loading = useState<bool>(false);
    final updateState = useState<OtaEvent?>(null);
    final forgottenPassword = useState<bool>(false);
    final connectionError = useState<String?>(null);
    final firstName = useState<String?>(null);
    final token = useState<String?>(null);
    final key = useState<String?>(null);
    final iv = useState<String?>(null);
    // final isValid = useState<bool>(_formKey.currentState!.validate());

    useEffect(() {
      inputState.value = _usernameController.text;
    }, [_usernameController, _passwordController]);

    Future<void> tryOtaUpdate() async {
      try {
        //LINK CONTAINS APK OF E360 app
        OtaUpdate()
            .execute(
          // 'http://10.0.0.184:8015/updates/downloadappversionfile/1.0.2/downloadappversionfile',
          'http://10.0.0.94:5000/apk/E360.apk',
          destinationFilename: 'E360.apk',
          //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
          // sha256checksum: 'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
        )
            .listen(
          (OtaEvent event) {
            updateState.value = event;
          },
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print('Failed to make OTA update. Details: $e');
      }
    }

    useEffect(() {
      initiateContract() async {
        final auth = await makeContract();
        if (auth?.isNotEmpty == true) {
          ref.read(authProvider.notifier).state =
              Auth(token: auth?[0], aesKey: auth?[1], iv: auth?[2]);
        }
        token.value = auth?[0];
        key.value = auth?[1];
        iv.value = auth?[2];
      }

      initiateContract();

      return null;
    }, []);

//gets the users name from local storage if it exists
    useEffect(() {
      void getName() async {
        final SharedPreferences prefs = await _prefs;
        if (prefs.containsKey('firstname') == true) {
          var name = prefs.getString('firstname');
          firstName.value = name;
        }
      }

      getName();
      return null;
    });
//validation for input fields
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

// displays a dialog for login errors
    Future<void> _showMyDialog(Map data) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: data['status'] == false
                ? const Text('Unsuccessful')
                : const Text('Success'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(data['message_description'])],
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

    Future<void> _showUpdateDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update Available'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[Text('A new version is available for download')],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                   Navigator.of(context).pop();
                  tryOtaUpdate();
                },
              ),
            ],
          );
        },
      );
    }

    //gets the current time for the intro
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

    //logs the user in
    void login() async {
      loading.value = true;

      connectionError.value = null;

      try {
        Uri url = Uri.parse(
            // 'http://10.0.0.184:8015/userservices/mobile/authenticatem'
            'https://e360.lapo-nigeria.org/userservices/mobile/authenticatem'
            );

        String base64ToHex(String source) =>
            base64Decode(LineSplitter.split(source).join())
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join();

        // token for the headers
        var token = jsonEncode({'tk': auth.token, 'src': "AS-IN-D659B-e3M"});

        var body = jsonEncode({
          'UsN': _usernameController.text,
          'Pwd': _passwordController.text,
          // 'UsN': 'SN11798',
          // 'UsN': 'SN12216',
          // 'UsN' : 'SN12213',
          // 'Pwd': 'Password6\$',
          'xAppSource': "AS-IN-D659B-e3M"
        });

        final encryptedBody =
            encryption(body, auth.aesKey ?? '', auth.iv ?? '');

        final encryptedHeader =
            encryption(token, auth.aesKey ?? '', auth.iv ?? '');

        var headers = {
          'x-lapo-eve-proc': base64ToHex(encryptedHeader) + (auth.token ?? ''),
          'Content-type': 'text/json',
        };

        final result = await http
            .post(url, headers: headers, body: base64ToHex(encryptedBody))
            .timeout(const Duration(seconds: 10))
            .catchError((err) => {
                  // print(err),
                  loading.value = false,
                  connectionError.value =
                      'An Error Occured Connecting to the Server'
                });
        print(result.body);
        if (jsonDecode(result.body)?['status'] != 200) {
          loading.value = false;
          return _showMyDialog(jsonDecode(result.body));
        }

        //initiates shared preferences for local storage
        final SharedPreferences prefs = await _prefs;

        loading.value = false;

        var payload = decryption(
            base64.encode(hex.decode(jsonDecode(result.body)['data'])),
            auth.aesKey ?? '',
            auth.iv ?? '');

        final Staff data = Staff.fromJson(jsonDecode(payload));

        firstName.value = data.firstName;

        // stores the users first name in local storage
        if (prefs.containsKey('firstname') == false) {
          prefs.setString('firstname', data.firstName ?? '');
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Frame(staff: data)));
      } catch (e) {
        print(e);
        loading.value = false;
        connectionError.value = 'An Error Occured Connecting to the Server';
      }
    }

    Future<void> resetPassword() async {
      loading.value = true;
      Uri url = Uri.parse('http://10.0.0.184:8015/userservices/passreset');
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

      final result = http
          .post(url, headers: headers, body: body)
          .then((result) => {print(result)});
    }

    // initiates ota update

    // checks for the current app version and compares versions on the server
    void checkForUpdate() async {
      Uri url = Uri.parse('http://10.0.0.94:5000/get_latest_version');
      final result = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });
      if (result.statusCode == 200) {
        // gets the current version from app
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        var version = packageInfo.version;
      
        var versionList = version.split('.');

        var serverList = result.body.split('.');

        if(int.parse(versionList[1]) < int.parse(serverList[1]) || int.parse(versionList[2]) < int.parse(serverList[2]) ) {
          _showUpdateDialog();
        }
        else {
          print('its current');
          return;
        }
      }
    }

    useEffect(() {
      if(kIsWeb) {
        return;
      }
      else if(Platform.isAndroid) {
        checkForUpdate();
      }
      // checkForUpdate();
      return null;
    }, []);

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.help, color: Colors.grey[500]))
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
                  padding: const EdgeInsets.only(bottom: 20, left: 30),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Text('Good',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              fontFamily: 'Ubuntu-light')),
                      const Text('  '),
                      Text(
                        getTime() + ',',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            fontFamily: 'Ubuntu-light'),
                      ),
                      const Text('  '),
                      Container(
                        child: firstName.value == null
                            ? const Text('Boss',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 28,
                                    color: Color(0xff15B77C),
                                    fontFamily: 'Ubuntu-regular'))
                            : Text(firstName.value.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 28,
                                    color: Color(0xff15B77C),
                                    fontFamily: 'Ubuntu-regular')),
                      )
                    ],
                  )),
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
                                height: 60,
                                child: CustomInput(
                                  controller: _passwordController,
                                  hintText: 'Enter Old Password',
                                  labelText: 'Enter Old Password',
                                  validation: validatePassword,
                                  isPassword: true,
                                )),
                      ),
                      Container(
                          margin: forgottenPassword.value == true
                              ? const EdgeInsets.only(top: 20)
                              : null,
                          height: forgottenPassword.value == true ? 160 : null,
                          child: forgottenPassword.value == true
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 330,
                                        height: 60,
                                        child: CustomInput(
                                          controller: _newPasswordController,
                                          hintText: 'Enter New Password',
                                          labelText: 'Enter New Password',
                                          validation: validatePassword,
                                          isPassword: true,
                                        )),
                                    SizedBox(
                                        width: 330,
                                        height: 60,
                                        child: CustomInput(
                                          controller:
                                              _confirmPasswordController,
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
                              if (_formKey.currentState!.validate() &&
                                  forgottenPassword.value == false &&
                                  updateState.value?.status.toString() !=
                                      'OtaStatus.DOWNLOADING') {
                                login();
                              }

                              // login();
                            },
                            splashColor: Colors.redAccent,
                            child: loading.value == false &&
                                    forgottenPassword.value == false
                                ? const Text("Sign in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22))
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
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20),
                      //   child: TextButton(
                      //       onPressed: () {
                      //         // forgottenPassword.value = !forgottenPassword.value;
                      //       },
                      //       child: forgottenPassword.value == true
                      //           ? const Text('Cancel Password Reset',
                      //               style: TextStyle(color: Color(0xff15B77C)))
                      //           : const Text('Forgot Password',
                      //               style:
                      //                   TextStyle(color: Color(0xff15B77C)))),
                      // ),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                          height: 50,
                          child: updateState.value?.status.toString() ==
                                  'OtaStatus.DOWNLOADING'
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      updateState.value?.status
                                              .toString()
                                              .split('.')[1] ??
                                          '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    LinearProgressIndicator(
                                      backgroundColor: Colors.grey[200],
                                      color: const Color(0xff15B77C),
                                      value: double.parse(
                                              updateState.value?.value ??
                                                  '0.0') /
                                          100,
                                    ),
                                    Text(
                                      '${updateState.value?.value}%',
                                      style: const TextStyle(
                                          color: Color(0xff15B77C),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              : null),

                      Container(
                        child: connectionError.value != null
                            ? Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: const Icon(
                                        Icons
                                            .signal_wifi_connected_no_internet_4,
                                        color: Color(0xffEF9545),
                                        size: 80),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      connectionError.value ?? '',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )
                            : null,
                      )

                      // Container(
                      //   child: Text('OTA status: ${updateState.value?.status} : ${updateState.value?.value} \n'),
                      // )
                    ],
                  ))
            ],
          ),
        ));
  }
}
