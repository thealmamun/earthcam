//// 🎯 Dart imports:
//import 'dart:async';
//import 'dart:convert';
//
//// 🐦 Flutter imports:
//import 'package:flutter/material.dart';
//
//// 📦 Package imports:
//import 'package:webview_flutter/webview_flutter.dart';
//
//class IFramePlayerPage extends StatefulWidget {
//  IFramePlayerPage({this.url,});
//  final String url;
//  @override
//  _IFramePlayerPageState createState() => _IFramePlayerPageState();
//}
//
//class _IFramePlayerPageState extends State<IFramePlayerPage> {
//  final Completer<WebViewController> _controller =
//  Completer<WebViewController>();
//  var playerResponse;
//  var status = 200;
//  GlobalKey sc = new GlobalKey<ScaffoldState>();
//
//  @override
//  Widget build(BuildContext context) {
//    double width;
//    double height;
//    width = MediaQuery.of(context).size.width;
//    height = MediaQuery.of(context).size.height;
//    JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//      return JavascriptChannel(
//          name: 'Toaster',
//          onMessageReceived: (JavascriptMessage message) {
//            Scaffold.of(context).showSnackBar(
//              SnackBar(content: Text(message.message)),
//            );
//          });
//    }
//    return Scaffold(
//        key: sc,
//        body: status == 200
//            ? Container(
//            width: width,
//            height: height,
//            child: WebView(
//                initialUrl:  Uri.dataFromString(
//                    '''
//                        <html>
//                        <body style="width:100%;height:100%;display:block;background:black;">
//                        <iframe width="100%" height="100%"
//                        style="width:100%;height:100%;display:block;background:black;"
//                        src="${widget.url}"
//                        frameborder="0"
//                        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
//                         allowfullscreen="allowfullscreen"
//                          mozallowfullscreen="mozallowfullscreen"
//                          msallowfullscreen="msallowfullscreen"
//                          oallowfullscreen="oallowfullscreen"
//                          webkitallowfullscreen="webkitallowfullscreen"
//                         >
//                        </iframe>
//                        </body>
//                        </html>
//                        ''',
//                    mimeType: 'text/html',
//                    encoding: Encoding.getByName('utf-8')
//                ).toString(),
//                javascriptMode: JavascriptMode.unrestricted,
//                onWebViewCreated: (WebViewController webViewController) {
//                  _controller.complete(webViewController);
//                },
//                javascriptChannels: <JavascriptChannel>[
//                  _toasterJavascriptChannel(context),
//                ].toSet()
//            ))
//
//            : Center(
//          child: CircularProgressIndicator(),
//        )
//    );
//  }
//}
