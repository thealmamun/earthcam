import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LaunchVideo extends StatefulWidget {
  LaunchVideo({this.url});
  final String url;
  @override
  _LaunchVideoState createState() => _LaunchVideoState();
}

class _LaunchVideoState extends State<LaunchVideo> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final spinkit = SpinKitFadingCircle(
    duration: Duration(milliseconds: 1800),
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  // ignore: cancel_subscriptions
  StreamSubscription<WebViewStateChanged>
  // ignore: cancel_subscriptions
  onChanged; // here we checked the url state if it loaded or start Load or abort Load

  @override
  void initState() {
    super.initState();
    onChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            if (state.type == WebViewState.finishLoad) {
              // if the full website page loaded
              print("loaded...");
            } else if (state.type == WebViewState.abortLoad) {
              // if there is a problem with loading the url
              print("there is a problem...");
            } else if (state.type == WebViewState.startLoad) {
              // if the url started loading
              print("start loading...");
            }
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose(); // disposing the webview widget
  }

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      // ignore: unnecessary_statements
      _getwebview;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getwebview(context);
  }

  Widget _getwebview(context) {
    return RefreshIndicator(
      onRefresh: getRefresh,
      child: WebviewScaffold(
        url: widget.url,
        withJavascript: true,
        withLocalStorage: true,
        // run javascript
        withZoom: true,
        // if you want the user zoom-in and zoom-out
        hidden: true,
        // put it true if you want to show CircularProgressIndicator while waiting for the page to load
//        appBar: AppBar(
//          automaticallyImplyLeading: false,
//          title: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              InkWell(
//                onTap: (){
//                  flutterWebviewPlugin.close();
//                  Navigator.pop(context);
//                },
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(Icons.arrow_back_ios,color: Colors.black,),
//                    Center(child: Text('Back',style: TextStyle(color: Colors.black),)),
//                  ],
//                ),
//              ),
//              Expanded(
//                child: Center(child: Text('Live Stream',style: TextStyle(color: Colors.black),)),
//              ),
//              InkWell(
//                child: Icon(Icons.refresh),
//                onTap: () {
//                  flutterWebviewPlugin.reload();
//                  // flutterWebviewPlugin.reloadUrl(); // if you want to reloade another url
//                },
//              ),
//            ],
//          ),
//          centerTitle: true,
//          flexibleSpace: Container(
//            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                begin: Alignment.topLeft,
//                end: Alignment.bottomRight,
//                colors: <Color>[Color(0XFF67B39E), Color(0XFFAAF3EF)],
//              ),
//            ),
//          ),
//        ),
        initialChild: Center(
          // but if you want to add your own waiting widget just add InitialChild
          child: spinkit,
        ),
      ),
    );
  }
}
