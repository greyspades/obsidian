import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:image_form_field/image_form_field.dart';
import 'package:e_360/Models/ImageInputAdapter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SettingsItem extends HookWidget {
  Staff staff;
  Map<String, dynamic> info;
  String currentItem;
  SettingsItem(
      {super.key,
      required this.staff,
      required this.info,
      required this.currentItem});
  static final _settingsFormKey = GlobalKey<FormState>(debugLabel: '');

  validateEmail(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new email address';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Not a valid email address';
    }
    return null;
  }

  validatePhone(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new phone number';
    }
    if (value.length != 11) {
      return 'Must be 11 digits and start with 0';
    }
    return null;
  }

  validatePassword(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new Password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _mobileController = TextEditingController();
    final _emailController = TextEditingController();
    final _addressController = TextEditingController();
    final _beneficiaryController = TextEditingController();
    final _passwordController = TextEditingController();
    final _oldPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final loading = useState<bool>(false);
    final picker = useState<ImagePicker>(ImagePicker());
    final image = useState<File?>(null);
    // final source = useState<String>('gallery');

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
        "rOldPwd": "Password6\$1",
        "rNewPwd": _passwordController.text,
        "rONewPwdVrfy": _confirmPasswordController.text,
        "xAppSource": "AS-IN-D659B-e3M"
      };

      final result = http
          .post(url, headers: headers, body: jsonEncode(body))
          .then((result) => {print(result.body)});
    }

    Future<void> updatePhone() async {
      loading.value = true;
      Uri url = Uri.parse('http://10.0.0.184:8015/userservices/updatemobile');
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300"
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      var body = {
        "employee_No": staff.employeeNo,
        "phone_Number": _mobileController.text,
        "phone_Type_Id": "string"
      };
      final result = http
          .post(url, headers: headers, body: jsonEncode(body))
          .then((result) => {print(result.body)});
    }

    Future<void> updateEmail() async {
      loading.value = true;
      Uri url = Uri.parse('http://10.0.0.184:8015/userservices/updatemobile');
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      var body = {
        "employee_No": staff.employeeNo,
        "phone_Number": _mobileController.text,
        "phone_Type_Id": "string"
      };
      final result = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .then((result) => {print(result.body)});
    }

    Future<void> updatePhoto() async {
      loading.value = true;
      Uri url = Uri.parse('http://10.0.0.184:8015/userservices/updatephoto');
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300"
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      var body = {
        "file_Type": "image",
        "file_Size": image.value?.readAsBytesSync().lengthInBytes,
        "phone_Type_Id": "string"
      };
      final result = http
          .post(url, headers: headers, body: jsonEncode(body))
          .then((result) => {print(result.body)});
    }

    Future<String> getEmail() async {
      loading.value = true;
      Uri url = Uri.parse('http://10.0.0.184:8015/userservices/retrieveuseremails/${staff.employeeNo}/retrieveuseremails');
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
            'us': staff.userRef,
      'rl': staff.uRole
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      final result = await http
          .get(url, headers: headers);
          if(result.statusCode == 200) {
            var data = jsonDecode(result.body)['data']?[0]['Item'];
            return data;
          }
          return '';
    }

    Future<String> getNumber() async {
      loading.value = true;
      Uri url = Uri.parse('http://10.0.0.184:8015/userservices/retrieveusermobilenumbers/${staff.employeeNo}/retrieveusermobilenumbers');
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
        'us': staff.userRef,
        'rl': staff.uRole
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      final result = await http
          .get(url, headers: headers);
          if(result.statusCode == 200) {
            var data = jsonDecode(result.body)['data']?[0]['Item'];
            return data;
          }
          return '';
    }

    Future getImage(String source) async {
    final pickedFile = await picker.value.getImage(source: source == 'gallery' ? ImageSource.gallery : ImageSource.camera);

      if (pickedFile != null) {
        image.value = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
  }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
    color: Colors.black
  ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        // height: 300,
        child: Form(
          key: _settingsFormKey,
          child: Column(
            children: [
              Container(
                height: currentItem == '100' ? 140 : null,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: currentItem == '100'
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      FutureBuilder(
                        future: getEmail(),
                        builder: ((context, snapshot) {
                          if(snapshot.hasData) {
                            return CustomInput(
                          isEnabled: false,
                          controller: _emailController,
                          validation: validateEmail,
                          hintText: '',
                          labelText: snapshot.data,
                          prefixIcon:
                              const Icon(Icons.email, color: Color(0xff15B77C)),
                        );
                          }
                          return Text('Loading');
                      })),
                        CustomInput(
                          controller: _emailController,
                          validation: validateEmail,
                          hintText: 'New Email',
                          labelText: 'New Email',
                          prefixIcon:
                              const Icon(Icons.email, color: Color(0xff15B77C)),
                        ),
                      ])
                    : null,
              ),
              
              Container(
                height: currentItem == '200' ? 140 : null,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: currentItem == '200'
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      FutureBuilder(
                        future: getNumber(),
                        builder: ((context, snapshot) {
                          if(snapshot.hasData) {
                            return CustomInput(
                          isEnabled: false,
                          controller: _mobileController,
                          validation: validatePhone,
                          hintText: '',
                          labelText: snapshot.data,
                          prefixIcon:
                              const Icon(Icons.phone, color: Color(0xff15B77C)),
                        );
                          }
                          return Text('Loading');
                      })),
                        CustomInput(
                          controller: _mobileController,
                          validation: validatePhone,
                          hintText: 'New Mobile Number',
                          labelText: 'New Mobile Number',
                          prefixIcon:
                              const Icon(Icons.phone, color: Color(0xff15B77C)),
                        ),
                      ])
                    : null,
              ),

              Container(
                height: currentItem == '300' ? 250 : null,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: currentItem == '300'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            CustomInput(
                              controller: _oldPasswordController,
                              validation: validatePassword,
                              hintText: 'Old Password',
                              labelText: 'Old Password',
                              isPassword: true,
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xff15B77C)),
                            ),
                            CustomInput(
                              controller: _passwordController,
                              validation: validatePassword,
                              hintText: 'New Password',
                              labelText: 'New Password',
                              isPassword: true,
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xff15B77C)),
                            ),
                            CustomInput(
                              controller: _confirmPasswordController,
                              validation: validatePassword,
                              hintText: 'Confirm New Password',
                              labelText: 'Confirm New Password',
                              isPassword: true,
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xff15B77C)),
                            ),
                          ])
                    : null,
              ),
              Container(
                child: image.value != null ? CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(image.value as File),
                ) : null
              ),
              Container(
                  height: currentItem == '400' ? 40 : null,
                  child: currentItem == '400' ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    ElevatedButton(child: Text('Get from Gallery', style: TextStyle(color: Colors.black),),style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)) , onPressed: () {
                    getImage('gallery');
                  },),

                  ElevatedButton(child: Text('Get from Camera', style: TextStyle(color: Colors.black),),style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)) , onPressed: () {
                    getImage('camera');
                  },)
                  ],) : null
                      ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: 300,
                child: currentItem.isNotEmpty
                    ? SizedBox(
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff15B77C),
                            ),
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {

                              // }
                              getEmail();
                              // switch (currentItem) {
                              //   case '300':
                              //     resetPassword();
                              //     break;

                              //   case '200':
                              //     print('other');
                              // }
                            },
                            child: Text('Update')),
                      )
                    : null,
              )
            ],
          ),
        )),
    );
  }
}
