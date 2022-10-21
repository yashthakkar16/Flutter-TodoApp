import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  //----------------------------------------
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;
  //----------------------------------------
  //authentication validating
  startAuthentication() {
    final validity = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity!) {
      _formkey.currentState?.save();
      submitForm(_email, _password, _username);
    }
  }

  //----------------------------------------
  //submiting the form and sending data to firebase
  submitForm(String email, String password, String username) async {
    // final auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try {
      if (isLoginPage) {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        String? uid = userCredential.user?.uid;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set({"username": _username, "email": _email});
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // ignore: avoid_print
        print('Wrong password provided for that user.');
      }
    }
  }

  //----------------------------------------

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.blue[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            if (!isLoginPage)
                              TextFormField(
                                keyboardType: TextInputType.name,
                                key: const ValueKey('username'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Incorrect usename";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _username = value!;
                                },
                                decoration: const InputDecoration(
                                    hintText: "Enter Username",
                                    labelText: "Username"),
                              ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              key: const ValueKey('email'),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains("@")) {
                                  return "Incorrect Email";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value!;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter Email", labelText: "Email"),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              key: const ValueKey('password'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Incorrect Password";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value!;
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                  hintText: "Enter Password",
                                  labelText: "Password"),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              child: isLoginPage
                                  ? const Text("Login")
                                  : const Text("Sign Up"),
                              onPressed: () {
                                startAuthentication();
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextButton(
                              child: isLoginPage
                                  ? const Text("Not a member?")
                                  : const Text("Already a member?"),
                              onPressed: () {
                                setState(() {
                                  isLoginPage = !isLoginPage;
                                });
                              },
                            )
                          ],
                        )),
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
