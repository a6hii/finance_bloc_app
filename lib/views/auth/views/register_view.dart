import 'package:finance_management/views/auth/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_management/services/auth/auth_exceptions.dart';
import 'package:finance_management/services/auth/bloc/auth_bloc.dart';
import 'package:finance_management/services/auth/bloc/auth_event.dart';
import 'package:finance_management/services/auth/bloc/auth_state.dart';
import 'package:finance_management/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              "Please use a stronger password!",
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              "Email already existes. Please use a different email to register.",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Please try after some time!",
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "Email not found or is invalid!",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Please register. We will send you a link on the email for verification.",
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 24),
                  child:
                      AuthTextField(controller: _name, hintText: "Enter name"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AuthTextField(
                      controller: _email, hintText: "Enter email"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AuthTextField(
                    controller: _password,
                    obscureText: true,
                    hintText: "Enter password",
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(
                                Size(MediaQuery.sizeOf(context).width, 54))),
                        onPressed: () async {
                          final name = _name.text;
                          final email = _email.text;
                          final password = _password.text;

                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  name,
                                  email,
                                  password,
                                ),
                              );
                        },
                        child: Text(
                          "Register",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        child: Text(
                          "Already registered? Log in",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
