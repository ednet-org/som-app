import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/pages/dashboard_page.dart';
import 'package:som/ui/utils/AppConstant.dart';

import '../components/Login.dart';

class CustomerLoginPage extends StatefulWidget {
  static String tag = '/DTLogin';

  @override
  CustomerLoginPageState createState() => CustomerLoginPageState();
}

class FunnyLogo extends StatelessWidget {
  final height;

  const FunnyLogo(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);

    return GestureDetector(
        onTap: () {
          appStore.toggleDarkMode();
        },
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'images/som/logo.png',
            height: height,
            fit: BoxFit.fitHeight,
            color: Theme.of(context).colorScheme.primary,
          ),
        ));
  }
}

class CustomerLoginPageState extends State<CustomerLoginPage> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var emailCont = TextEditingController();
  var passCont = TextEditingController();
  var companyNameCont = TextEditingController();

  var emailFocus = FocusNode();
  var passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    return Observer(
      builder: (_) => appStore.isAuthenticated
          ? DashboardPage()
          : SafeArea(
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                body: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: spacing_large),
                      FunnyLogo(150.0),
                      Text('Smart offer management'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))
                          .paddingOnly(left: 8, top: 20, right: 8, bottom: 20),
                      SizedBox(
                        width: 800,
                        child: Column(children: [
                          Login(),
                        ]),
                      ),
                    ],
                  ),
                )),
              ),
            ),
    );
  }
}
