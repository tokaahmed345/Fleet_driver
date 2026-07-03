
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/function/validators.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/core/utils/widgets/app_text_form_field.dart';
import 'package:fleet_driver/core/utils/widgets/primary_button.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/route_entity.dart';
import 'package:fleet_driver/feature/register_driver/presentation/cubits/cubit/routes_cubit.dart';
import 'package:fleet_driver/feature/register_driver/presentation/cubits/register_cubit/register_driver_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterDriverViewBody extends StatefulWidget {
  const RegisterDriverViewBody({super.key});

  @override
  State<RegisterDriverViewBody> createState() =>
      _RegisterDriverViewBodyState();
}

class _RegisterDriverViewBodyState
    extends State<RegisterDriverViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  RouteEntity? _selectedRoute;
  

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateDriver() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid && _selectedRoute != null) {
      context.read<RegisterDriverCubit>().register(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,

            route: _selectedRoute!.id.toString(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterDriverCubit, RegisterDriverState>(
      listener: (context, state) {
        if (state is RegisterDriverSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Driver created successfully'),
            ),
          );

    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();

    setState(() {
      _selectedRoute = null;
    });
          
        } else if (state is RegisterDriverFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterDriverLoading;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _FieldLabel('FULL NAME'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hint: 'Ahmed Al-Rashidi',
                    icon:
                        Icons.person_outline_rounded,
                    controller: _nameController,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        Validators.nameValidator,
                  ),
                  const SizedBox(height: 20),

                  _FieldLabel('EMAIL ADDRESS'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hint: 'driver@fleet.io',
                    icon:
                        Icons.mail_outline_rounded,
                    controller: _emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        Validators.emailValidator,
                  ),
                  const SizedBox(height: 20),

                  _FieldLabel('TEMPORARY PASSWORD'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hint: 'Min. 8 characters',
                    icon:
                        Icons.lock_outline_rounded,
                    controller:
                        _passwordController,
                    obscureText: true,
                    textInputAction:
                        TextInputAction.done,
                    validator:
                        Validators.passwordValidator,
                  ),
                  const SizedBox(height: 20),

                  _FieldLabel('ASSIGNED ROUTE'),
                  const SizedBox(height: 8),

                 BlocBuilder<RoutesCubit, RoutesState>(
  builder: (context, state) {
    if (state is RoutesSuccess) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<RouteEntity>(
            value: _selectedRoute,
            isExpanded: true,
            dropdownColor: AppColors.surfaceElevated,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),

            hint: Text(
              'Select a route...',
              style: AppStyle.text16.copyWith(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),

            style: AppStyle.text16.copyWith(fontSize: 14),

            items: state.routes.map((route) {
              return DropdownMenuItem<RouteEntity>(
                value: route,
                child: Text(route.name),
              );
            }).toList(),

            onChanged: (value) {
              setState(() => _selectedRoute = value);
            },
          ),
        ),
      );
    }

    return const SizedBox();
  },
),

                  const SizedBox(height: 34),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(
                              color:
                                  AppColors.primary,
                            ),
                          )
                        : PrimaryButton(
                            label:
                                'Create driver account',
                            onTap:
                                _handleCreateDriver,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppStyle.text16.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 0.6,
      ),
    );
  }
}