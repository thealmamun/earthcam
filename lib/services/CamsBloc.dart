import 'dart:async';

import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/services/local_db.dart';

class CamsBloc {
  CamsBloc() {
    getClients();
  }
  final _clientController = StreamController<List<Cams>>.broadcast();
  get cams => _clientController.stream;

  dispose() {
    _clientController.close();
  }

  getClients() async {
    _clientController.sink.add(await DBHelper().getCams());
  }
}