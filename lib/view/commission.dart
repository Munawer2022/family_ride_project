import 'package:flutter/material.dart';

import 'package:rider/resources/padding.dart';

import '../resources/components/lisview_component.dart';
import '../resources/components/appbar.dart';

class Commission extends StatelessWidget {
  const Commission({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
          appBar: appBar(
              const Text(
                'Commission',
              ),
              null,
              true),
          body: Padding(
            padding: screenPadding,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: const [
                      ListViewComponent(
                          title: Text('Date'),
                          subtitle: Text('Rs: 100'),
                          trailing: Text('Type')),
                      ListViewComponent(
                          title: Text('Date'),
                          subtitle: Text('Rs: 100'),
                          trailing: Text('Type')),
                      ListViewComponent(
                          title: Text('Date'),
                          subtitle: Text('Rs: 100'),
                          trailing: Text('Type')),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
