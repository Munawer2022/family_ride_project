import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Terms extends StatefulWidget {
  Terms({Key? key}) : super(key: key);
  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  final box = GetStorage();
  TextEditingController pickController = new TextEditingController();
  TextEditingController dropController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Terms and Conditions"),
          centerTitle: true,
        ),
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller
                .loadUrl("https://blockchainride.pk/terms-and-conditions");
          },
        ));
  }
}
