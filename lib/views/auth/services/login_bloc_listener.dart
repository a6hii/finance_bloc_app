

import 'package:finance_management/services/auth/auth_exceptions.dart';
import 'package:finance_management/services/auth/bloc/auth_state.dart';
import 'package:finance_management/utilities/dialogs/error_dialog.dart';

 Future<void> loginBlocListener(context, state)async {
  if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              "No user found with this email!",
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              "Wrong login credentials used!",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "An error occured while logging you in! Please try again or after some time!",
            );
          }
        }
}