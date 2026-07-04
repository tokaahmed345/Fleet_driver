import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/function/validators.dart';
import 'package:fleet_driver/core/utils/router/routes_name.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/core/utils/widgets/app_text_form_field.dart';
import 'package:fleet_driver/core/utils/widgets/primary_button.dart';
import 'package:fleet_driver/core/utils/widgets/snackbar.dart';
import 'package:fleet_driver/feature/auth/presentation/login_cubit/log_in_cubit.dart';
import 'package:fleet_driver/feature/auth/presentation/widgets/driver/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LogInCubit>().logIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const LoginLogo(),
                  const SizedBox(height: 24),
                  Text('Fleet Driver', style: AppStyle.text28),
                  const SizedBox(height: 6),
                  Text(
                    'Fleet management platform',
                    style: AppStyle.text16.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 36),
                  AppTextField(
                    hint: 'Email address',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.emailValidator,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    hint: 'Password',
                    icon: Icons.lock_outline_rounded,
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: Validators.passwordValidator,
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: BlocConsumer<LogInCubit, LogInState>(
                      listener: (context, state) {
                        if (state is LogInFailure) {
                          showSnackBarFuction(
                            context,
                            state.errorMessage,
                            isError: true,
                          );
                        }
                        if (state is LogInSuccess) {
                          final entity = state.logInEntity;

                          if (entity.role == 'admin') {
                            GoRouter.of(context).go(RoutesName.registerDriver);
                          } else {
                            GoRouter.of(context).go(RoutesName.home);
                          }
                        }
                      },

                      builder: (context, state) {
                        return state is LogInLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            : PrimaryButton(
                                label: 'Login',
                                onTap: _handleLogin,
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Need an account? Contact your fleet admin.',
                    style: AppStyle.text16.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
