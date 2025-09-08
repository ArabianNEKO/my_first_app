import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/config/config.dart';
import 'package:my_first_app/model/config/internal_config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/page/register.dart';
import 'package:my_first_app/page/showtrip.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
 LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int count = 0;
 TextEditingController phoneNoCtl = TextEditingController();
 TextEditingController passwordCtl = TextEditingController();
 String url ='';


  @override
void initState() {
super.initState();
Configuration.getConfig().then(
  (config) {
	url = config['apiEndpoint'];
  },
);
}
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(color: Colors.white,
        child: SizedBox(width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column( mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: GestureDetector(
                    child: Image.asset('assets/images/logo.png',
                    ),
                    onDoubleTap: () {
                      log('Logo double tapped');
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'หมายเลขโทรศัพท์',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        controller: phoneNoCtl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                          'รหัสผ่าน',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                    ),
                    Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: passwordCtl,
                  ),
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ 
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: TextButton(onPressed: regiser , child: const Text('ลงทะเบียน', style: TextStyle(color: Colors.blue))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30, top: 20),
                      child: FilledButton(onPressed: login, child: const Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white))),
                    ),
                  ],    
                             
                ),
                
                  ],
                  
                ),
                Center(
                  child: Text(text,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                ),
                Image.asset(
                  'assets/images/mira.gif',
                  width: MediaQuery.of(context).size.width,
                ),
                
            ],
                    ),
          ),
        ),
      ),
    );
  }

  void regiser() {
    // setState is used to update the state of the widget
    // setState(() { 
    //   text = 'Register button pressed';
    // });
    // log(text);
   Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()), );
  }

  void login() async {
    text = '';
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );

    http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ShowTripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
          text = 'Error, Invalid phone or password';
        });
  }
}
