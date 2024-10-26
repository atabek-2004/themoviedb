import 'package:flutter/material.dart';
import 'package:themoviedb/ui/Theme/app_color.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget_model.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
        backgroundColor: AppColor.appColor,
        foregroundColor: AppColor.foreGroundColor,
      ),
      body: const _AuthWidgetBody(),
    );
  }
}

class _AuthWidgetBody extends StatelessWidget {
  const _AuthWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ListView(
        children: const [
          _TextFieldWidget(),
          SizedBox(height: 25),
          _LoginButtonWidget(),
          SizedBox(height: 40),
          _HeaderTextWidgetOne(),
          SizedBox(height: 25),
          _HeaderTextWidgetTwo(),
        ],
      ),
    );
  }
}

class _TextFieldWidget extends StatelessWidget {
  const _TextFieldWidget();

  @override
  Widget build(BuildContext context) {
    const textFieldDecoration = InputDecoration(
      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...[
          const _ErrorMessage(),
        ],
        const SizedBox(height: 15),
        const Text('Username'),
        const SizedBox(height: 5),
        TextField(
          controller:
              AuthWidgetModelProvider.read(context)?.model.textNameController,
          decoration: textFieldDecoration,
        ),
        const SizedBox(height: 20),
        const Text('Password'),
        const SizedBox(height: 5),
        TextField(
          obscureText: true,
          controller: AuthWidgetModelProvider.read(context)
              ?.model
              .passwordNameController,
          decoration: textFieldDecoration,
        ),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        AuthWidgetModelProvider.watch(context)?.model.errorMessage;
    return Column(
      children: [
        if (errorMessage != null)
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}

class _HeaderTextWidgetOne extends StatelessWidget {
  const _HeaderTextWidgetOne();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple.',
        ),
        _RegisterWidget(),
      ],
    );
  }
}

class _RegisterWidget extends StatelessWidget {
  const _RegisterWidget();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Register'),
    );
  }
}

class _HeaderTextWidgetTwo extends StatelessWidget {
  const _HeaderTextWidgetTwo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'If you signed up but didn`t get your verification email.',
        ),
        _VerificationEmailWidget(),
      ],
    );
  }
}

class _VerificationEmailWidget extends StatelessWidget {
  const _VerificationEmailWidget();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Verification email'),
    );
  }
}

class _LoginButtonWidget extends StatelessWidget {
  const _LoginButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ElevatedButtonWidget(),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {},
          child: const Text('Reset password'),
        ),
      ],
    );
  }
}

class _ElevatedButtonWidget extends StatelessWidget {
  const _ElevatedButtonWidget();

  @override
  Widget build(BuildContext context) {
    final model = AuthWidgetModelProvider.watch(context)?.model;
    final child = model?.isAuth == true
        ? const SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(),
          )
        : const Text('Login');
    return ElevatedButton(
      onPressed: () =>
          model?.canAuth == true ? model?.showMainScreen(context) : null,
      child: child,
    );
  }
}
