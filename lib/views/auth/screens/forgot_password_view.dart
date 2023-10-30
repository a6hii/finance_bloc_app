import 'package:finance_management/views/auth/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_management/services/auth/bloc/auth_bloc.dart';
import 'package:finance_management/services/auth/bloc/auth_event.dart';
import 'package:finance_management/services/auth/bloc/auth_state.dart';
import 'package:finance_management/utilities/dialogs/error_dialog.dart';
import 'package:finance_management/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null && context.mounted) {
            await showErrorDialog(
              context,
              "Error",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forgot Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Enter your registered email",
                  ),
                ),
                AuthTextField(controller: _controller, hintText: "Email"),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                            Size(MediaQuery.sizeOf(context).width, 54))),
                    onPressed: () {
                      final email = _controller.text;
                      context
                          .read<AuthBloc>()
                          .add(AuthEventForgotPassword(email: email));
                    },
                    child: Text("Send reset link",
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: Text('Back to login',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
