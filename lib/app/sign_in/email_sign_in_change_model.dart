import 'package:flutter/cupertino.dart';
import 'package:onlinecrimereportingsystem/app/sign_in/email_sign_in_model.dart';
import 'package:onlinecrimereportingsystem/app/sign_in/validators.dart';
import 'package:flutter/foundation.dart';
import 'package:onlinecrimereportingsystem/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false,
      @required this.auth});
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email,password);
      } else {
        await auth.createUserWithEmailAndPassword(email,
            password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? inValidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? inValidEmailErrorText : null;
  }

  void toggleFormTye(){
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }
  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

 void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
  this.email= email ?? this.email;
      this.password= password ?? this.password;
      this.formType= formType ?? this.formType;
      this.isLoading= isLoading ?? this.isLoading;
      this.submitted= submitted ?? this.submitted;
      notifyListeners();
  }
}
