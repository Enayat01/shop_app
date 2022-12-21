import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/authentication.dart';
import '../config/http_exception.dart';

enum AuthMode { signUp, logIn }

class AuthenticationCard extends StatefulWidget {
  const AuthenticationCard({Key? key}) : super(key: key);

  @override
  State<AuthenticationCard> createState() => _AuthenticationCardState();
}

class _AuthenticationCardState extends State<AuthenticationCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.logIn;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  var _isObscurePassword = true; //Invisible Password
  var _isObscureConfirmPassword = true; //Invisible Confirm Password
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Size> _heightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation = Tween<Size>(
      begin: const Size(double.infinity, 280),
      end: const Size(double.infinity, 350),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));  //Manual Animation Listener
  }

  @override
  void dispose() {
    super.dispose();
    // _animationController.dispose();  // Disposing manual listener
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error has occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == false) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      //Turn on loading indicator
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.logIn) {
        // Log user in
        await Provider.of<Authentication>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Authentication>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      // Handling various error messages
      var errorMessage = 'Authentication failed!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email address!';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find with this email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Could not authenticate! Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      //Turn off loading indicator
      _isLoading = false;
    });
  }

  //Switching between login and signup pages
  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (ctx, ch) => Container(
            padding: const EdgeInsets.all(15),
            // height: _authMode == AuthMode.signUp ? 350 : 280,   //Old setup for height
            height: _heightAnimation.value.height,
            constraints: BoxConstraints(
              minHeight: _heightAnimation.value.height,
            ),
            width: mediaQuery.width * 0.80,
            child: ch),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return 'Please provide a valid email address!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscurePassword = !_isObscurePassword;
                        });
                      },
                      icon: _isObscurePassword
                          ? const Icon(Icons.visibility_rounded)
                          : const Icon(Icons.visibility_off_rounded),
                    ),
                  ),
                  obscureText: _isObscurePassword,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                // if (_authMode == AuthMode.signUp) //old setup for switching auth modes

                //switching auth mode using AnimatedContainer
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.signUp ? 120 : 0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signUp,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscureConfirmPassword =
                                  !_isObscureConfirmPassword;
                            });
                          },
                          icon: _isObscureConfirmPassword
                              ? const Icon(Icons.visibility_rounded)
                              : const Icon(Icons.visibility_off_rounded),
                        ),
                      ),
                      obscureText: _isObscureConfirmPassword,
                      validator: _authMode == AuthMode.signUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:
                        Text(_authMode == AuthMode.logIn ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.logIn ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
