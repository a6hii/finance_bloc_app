import 'package:finance_management/config/dark_theme.dart';
import 'package:finance_management/config/light_theme.dart';
import 'package:finance_management/config/route_names.dart';
import 'package:finance_management/helpers/loading/loading_screen.dart';
import 'package:finance_management/services/auth/bloc/auth_bloc.dart';
import 'package:finance_management/services/auth/bloc/auth_event.dart';
import 'package:finance_management/services/auth/bloc/auth_state.dart';
import 'package:finance_management/services/auth/firebase_auth_provider.dart';
import 'package:finance_management/services/transactions/bloc/fetch_transactions_bloc.dart';
import 'package:finance_management/views/auth/views/forgot_password_view.dart';
import 'package:finance_management/views/auth/views/login_view.dart';
import 'package:finance_management/views/auth/views/register_view.dart';
import 'package:finance_management/views/auth/views/verify_email_view.dart';
import 'package:finance_management/views/create_update_transaction/create_update_transaction_view.dart';
import 'package:finance_management/views/home/home_transactions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
        ),
        BlocProvider(
          create: (context) => FetchTransactionsBloc(),
        ),
        BlocProvider(
          create: (context) => TransactionTypeSelectionCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'My Finance',
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        home: const HomePage(),
        routes: {
          addOrUpdateTransaction: (context) =>
              const CreateUpdateTransactionView(),
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("restart");
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          print("Loading stast");
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          print("$state");
          return const HomeTransactionsView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
