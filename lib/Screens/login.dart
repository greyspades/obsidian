import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Widgets/input.dart';
import 'dart:convert';
import 'package:e_360/Models/Staff.dart';
import 'package:e_360/Widgets/frame.dart';
import 'package:e_360/Screens/profile.dart';


class Login extends HookWidget {
  final String title;
  const Login({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(debugLabel: '');
    final _usernameController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final focussed = useState<bool>(false);
    final inputState = useState<String>('');
    final loading = useState<bool>(false);
    // final isValid = useState<bool>(_formKey.currentState!.validate());

    useEffect(() {
        inputState.value = _usernameController.text;
    }, [_usernameController, _passwordController]);

    validateUsername(String value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a username';
      }
      return null;
    }

    validatePassword(String value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a username';
      }
      return null;
    }

    void login() async{
      loading.value = true;
      Uri url = Uri.parse('http://10.0.0.184:8015/userservices/mobile/authenticatem');
      var token = { 'br': "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300" };
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
              'Pwd': 'Password6\$',
              'xAppSource': "AS-IN-D659B-e3M"
            })
      );
      if(result.statusCode == 200){
        loading.value = false;
        final Staff data = Staff.fromJson(jsonDecode(result.body)['data']);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Frame(staff: data)));
      }
      else {
        throw Exception('Failed to load data');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.help, color: Color(0xff15B77C)))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'images/lapo_360.png',
              width: 200,
              height: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Hey there!',
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
                    child: SizedBox(
                        width: 330,
                        child: CustomInput(
                          controller: _passwordController,
                          hintText: 'your password',
                          labelText: 'Password',
                          validation: validatePassword,
                          isPassword: true,
                        )),
                  ),
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
                      onPressed:() {
                        // if (_formKey.currentState!.validate()) {
                        //   login();
                        // }
                        login();
                      },
                      splashColor: Colors.redAccent,
                      child: loading.value == false ? const Text("Sign in",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 22))
                              :
                              const CircularProgressIndicator(color: Colors.white, strokeWidth: 5,),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 20), child: TextButton(onPressed: (){}, child: const Text('Change password', style: TextStyle(color:Color(0xff15B77C)))),)
                ],
              ))
        ],
      ),
    );
  }
}
