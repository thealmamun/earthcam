
import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';


class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  var state = FlutterVpnState.disconnected;
  var charonState = CharonErrorState.NO_ERROR;

  @override
  void initState() {
    FlutterVpn.prepare();
    FlutterVpn.onStateChanged.listen((s) => setState(() => state = s));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter VPN'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Text('Current State: $state'),
            Text('Current Charon State: $charonState'),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(icon: Icon(Icons.map)),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(icon: Icon(Icons.person_outline)),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(icon: Icon(Icons.lock_outline)),
            ),
            RaisedButton(
              child: Text('Connect'),
              onPressed: () => FlutterVpn.simpleConnect(
                _addressController.text,
                _usernameController.text,
                _passwordController.text,
              ),
            ),
            RaisedButton(
              child: Text('Disconnect'),
              onPressed: () => FlutterVpn.disconnect(),
            ),
            RaisedButton(
                child: Text('Update State'),
                onPressed: () async {
                  var newState = await FlutterVpn.currentState;
                  setState(() => state = newState);
                }),
            RaisedButton(
                child: Text('Update Charon State'),
                onPressed: () async {
                  var newState = await FlutterVpn.charonErrorState;
                  setState(() => charonState = newState);
                }),
          ],
        ),
      ),
    );
  }
}