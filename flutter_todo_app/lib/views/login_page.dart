import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/services/auth.dart';
import 'package:provider/provider.dart';

enum FormStatus { login, register, reset }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FormStatus _formStatus = FormStatus.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child: new Text('Todo-App', textAlign: TextAlign.center)),
      ),
      body: Center(
        child: _formStatus == FormStatus.login
            ? buildLoginForm()
            : _formStatus == FormStatus.register
                ? buildRegisterForm()
                : buildResetForm(),
      ),
    );
  }

  Widget buildLoginForm() {
    final _loginFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Giriş Yap',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text('E-mail'),
            TextFormField(
              controller: _emailController,
              validator: (val) {
                if (!EmailValidator.validate(val)) {
                  return 'E-postanız yanlış. Lütfen e-postanızı kontrol edin.';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Parola'),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value.length < 6) {
                  return 'Şifreniz yanlış. Lütfen altı haneli şifrenizi giriniz.';
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: 'Parola',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_loginFormKey.currentState.validate()) {
                  final user = await Provider.of<Auth>(context, listen: false)
                      .singInWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                  if (!user.emailVerified) {
                    await _showMyDialog();
                    await Provider.of<Auth>(context, listen: false).signOut();
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Giriş Yap'),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _formStatus = FormStatus.register;
                  });
                },
                child: Text(
                  'Kayıt Ol',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                )),
            SizedBox(
              height: 70,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _formStatus = FormStatus.reset;
                  });
                },
                child: Text(
                  'Şifremi Unuttum',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildResetForm() {
    final _resetFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Parola Sıfırla',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 40),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _emailController,
              validator: (val) {
                if (!EmailValidator.validate(val)) {
                  return 'E-posta adresiniz hatalı,Lütfen kontrol edin.';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_resetFormKey.currentState.validate()) {
                  await Provider.of<Auth>(context, listen: false)
                      .sendPasswordResetEmail(_emailController.text);
                  await _showResetPasswordDialog();

                  Navigator.pop(context);
                }
              },
              child: Text('ENTER'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterForm() {
    final _registerFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordComfirmController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kayıt Ol',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 40),
            ),
            SizedBox(
              height: 40,
            ),
            Text('E-mail'),
            TextFormField(
              controller: _emailController,
              validator: (val) {
                if (!EmailValidator.validate(val)) {
                  return 'Email adresi yanlış,Lütfen kontrol ediniz.';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Parola'),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value.length < 6) {
                  return 'Şifre hatalı,Lütfen altı haneli bir şifre oluşturun.';
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: 'Parola oluştur',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Parolanızı Tekrar giriniz.'),
            TextFormField(
              controller: _passwordComfirmController,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Parola eşleşmiyor.';
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: 'Parolanızı tekrar giriniz.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_registerFormKey.currentState.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .createUserWithEmailAndPassword(
                            _emailController.text, _passwordController.text);
                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _showMyDialog();
                    await Provider.of<Auth>(context, listen: false).signOut();
                    setState(() {
                      _formStatus = FormStatus.login;
                    });
                  }
                } on FirebaseAuthException catch (e) {
                  await _showErrorDialog();
                  print('kayıt formu içerisinde hata yakalandı, ${e.message}');
                }
              },
              child: Text('Kayıt Ol'),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.login;
                });
              },
              child: Text(
                'Giriş Yap',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ONAY GEREKLİ',
            style: TextStyle(color: Colors.green),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Merhaba,lütfen epostanızı kontrol edin.'),
                SizedBox(
                  height: 5,
                ),
                Text('E-postanızı onaylayıp, tekrar giriş yapmalısınız.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Parola Oluştur',
            style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 22,
                color: Colors.green),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Merhaba,Lütfen e-postanızı kontrol edin.'),
                SizedBox(
                  height: 5,
                ),
                Text('Linke tıklayarak yeni şifrenizi oluşturabilirsiniz.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'HATA!',
            style: TextStyle(
                fontFamily: 'RobotoCondensed', fontSize: 20, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Zaten bir hesabınız var.'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    'Mevcut hesabınızla giriş yapabilir veya şifrenizi unuttuysanız şifremi unuttuma tıklayarak yeni şifre oluşturabilirsiniz. '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anladım'
                  ''),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
