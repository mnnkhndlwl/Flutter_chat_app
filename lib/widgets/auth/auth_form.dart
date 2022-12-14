import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  bool isLoading;

  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an Image...'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              if (!_isLogin) UserImagePicker(_pickedImage),
              TextFormField(
                key: ValueKey('email'),
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please Enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
                onSaved: (value) {
                  _userEmail = value;
                },
              ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('username'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      return 'Please Enter a atleast 4 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  onSaved: (value) {
                    _userName = value;
                  },
                ),
              TextFormField(
                key: ValueKey('password'),
                validator: (value) {
                  if (value.isEmpty || value.length < 7) {
                    return 'Please Enter a strong password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (value) {
                  _userPassword = value;
                },
                obscureText: true,
              ),
              SizedBox(
                height: 12,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                RaisedButton(
                  onPressed: _trySubmit,
                  child: Text(_isLogin ? 'Login' : 'SignUp'),
                ),
              if (!widget.isLoading)
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create New Account'
                      : 'I already have a new account'),
                ),
            ]),
          ),
        )),
      ),
    );
  }
}
