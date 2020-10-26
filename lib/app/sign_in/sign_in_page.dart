import 'dart:math';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/app/sign_in/sign_in_view_model.dart';
import 'package:school_im/app/sign_in/sign_in_button.dart';
import 'package:school_im/constants/keys.dart';
import 'package:school_im/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_im/routing/app_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as ios;
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

final signInModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(auth: ref.watch(firebaseAuthProvider)),
);

class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final signInModel = watch(signInModelProvider);
    return ProviderListener<SignInViewModel>(
      provider: signInModelProvider,
      onChange: (context, model) async {
        if (model.error != null) {
          await showExceptionAlertDialog(
            context: context,
            title: Strings.signInFailed,
            exception: model.error,
          );
        }
      },
      child: SignInPageContents(
        viewModel: signInModel,
        title: 'Architecture Demo',
      ),
    );
  }
}

class SignInPageContents extends StatelessWidget {
  const SignInPageContents(
      {Key key, this.viewModel, this.title = 'Architecture Demo'})
      : super(key: key);
  final SignInViewModel viewModel;
  final String title;

  static const Key emailPasswordButtonKey = Key(Keys.emailPassword);
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showEmailPasswordSignInPage(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      AppRoutes.emailPasswordSignInPage,
      arguments: () => navigator.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(context),
    );
  }

  Widget _buildHeader() {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      Strings.signIn,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget androidWidget() {
    return GoogleSignInButton(
      onPressed: () {
        viewModel.isLoading ? null : viewModel.signInGoogle();
      },
      darkMode: false, // default: false
    );
  }

  Widget iosWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return const SizedBox(height: 0.0);
        }
        if (projectSnap.data == false) {
          //!= false) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ios.AppleSignInButton(
              style: ios.ButtonStyle.white,
              type: ios.ButtonType.signIn,
              onPressed: viewModel.isLoading ? null : viewModel.signInIos,
            ),
          );
        } else {
          //print("error apple signin not available");
          return Padding(
              padding: const EdgeInsets.all(20.0), child: androidWidget());
        }
      },
      future: AppleSignIn.isAvailable(),
    );
  }

  Widget _getBody(BuildContext context) {
    List<Widget> pages = [
      Container(
        color: Color(0xff9188E5),
      ),
      Container(
        color: Colors.red,
      ),
      Container(
        color: Color(0xff9188E5),
      ),
    ];
    final controller = PageController(
      initialPage: 1,
    );

    return Stack(
      children: <Widget>[
        PageView(
          children: pages,
          controller: controller,
          scrollDirection: Axis.horizontal,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            //height: 150.0,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(""),
                ),
                SmoothPageIndicator(
                    controller: controller, // PageController
                    count: pages.length,
                    effect: SlideEffect(
                        spacing: 8.0,
                        radius: 4.0,
                        dotWidth: 10.0,
                        dotHeight: 10.0,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 1.5,
                        dotColor: Color(0xffC1BCF2),
                        activeDotColor: Colors.white), // your preferred effect
                    onDotClicked: (index) {}),
                SizedBox(height: 20.0),
                iosWidget(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: min(constraints.maxWidth, 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 32.0),
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              const SizedBox(height: 32.0),
              SignInButton(
                key: emailPasswordButtonKey,
                text: Strings.signInWithEmailPassword,
                onPressed: viewModel.isLoading
                    ? null
                    : () => _showEmailPasswordSignInPage(context),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              const Text(
                Strings.or,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SignInButton(
                key: anonymousButtonKey,
                text: Strings.goAnonymous,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed:
                    viewModel.isLoading ? null : viewModel.signInAnonymously,
              ),
            ],
          ),
        );
      }),
    );
  }
}
