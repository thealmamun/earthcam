
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;
  List<Marker> allMarkers = [];
  PageController _pageController;
  int prevPage;
  bool isClicked = false;




  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    camDetails.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.camTitle),
          draggable: false,
          infoWindow:
              InfoWindow(title: element.camTitle, snippet: element.address),
          position: element.locationCoords));
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
//            moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 200.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          camDetails[index].thumbNail),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  camDetails[index].camTitle,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  camDetails[index].address,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
//                                Container(
//                                  width: 170.0,
//                                  child: Text(
//                                    coffeeShops[index].description,
//                                    style: TextStyle(
//                                        fontSize: 11.0,
//                                        fontWeight: FontWeight.w300),
//                                  ),
//                                ),

                                Container(
                                  width: 150,
                                  child: RaisedButton.icon(
                                    elevation: 12,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(
                                        15
                                         ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
                                    },
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Play',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.redAccent,
                                  ),
                                )

                              ])
                        ]))))
          ])),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1B2D45),
        appBar: AppBar(
          centerTitle: true,
          title: Text('All Live Cams'),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: null),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.do_not_disturb_off,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: null),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(

                compassEnabled: true,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(40.7128, -74.0060), zoom: 12.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,


              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: camDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _coffeeShopList(index);
                  },
                ),
              ),
            ),

            isClicked
                ? Container(
           padding: EdgeInsets.only(top: 30),
              alignment: Alignment.topRight,
              child: RaisedButton.icon(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                onPressed: () {
                  print('YT cam Clicked');
                  setState(() {
                    isClicked = false;
                  });
                },
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                label: Text(
                  'YT Cam',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
              ),
            )
                : Container(
              padding: EdgeInsets.only(top: 30),
              alignment: Alignment.topRight,
              child: RaisedButton.icon(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                onPressed: () {
                  print('IP cam Clicked');
                  setState(() {
                    isClicked = true;
                  });
                },
                icon: Icon(
                  Icons.linked_camera,
                  color: Colors.white,
                ),
                label: Text(
                  'IP Cam',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.indigo,
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: camDetails[_pageController.page.toInt()].locationCoords,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

}
