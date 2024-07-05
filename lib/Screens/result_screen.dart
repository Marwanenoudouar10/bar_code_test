import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResultScreen extends StatelessWidget {
  final String url;
  final VoidCallback? onReturn;

  const ResultScreen({Key? key, required this.url, this.onReturn});
  final bgcolor = const Color(0xfffafafa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width / 2,
                height: 60,
                decoration: BoxDecoration(
                  color: bgcolor,
                ),
                child: GestureDetector(
                  onTap: () {
                    SystemNavigator.pop();
                  },
                  child: const Center(
                    child: Text(
                      'Quitter',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width / 2,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onReturn?.call();
                  },
                  child: const Center(child: Text('Scanner à nouveau')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
