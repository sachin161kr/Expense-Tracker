import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40, bottom: 8),
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Username'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40, bottom: 35),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 20),
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ))),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Track My Expense!',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Don\'t have an account?',
            style: TextStyle(fontSize: 20),
          ),
        ),
        FlatButton(
            onPressed: () {},
            child: Text(
              'Sign Up here!',
              style: TextStyle(fontSize: 15, color: Colors.purple),
            )),
      ],
    );
  }
}
