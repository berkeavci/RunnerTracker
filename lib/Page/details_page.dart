import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runner/components/dashboard_components/google_maps_view.dart';
import 'package:runner/constans.dart';
import 'package:runner/entities/activity_stats.dart';
import 'package:share_plus/share_plus.dart';

class DetailsPage extends StatefulWidget {
  final ActivityStats? activityStats;
  DetailsPage({Key? key, required this.activityStats}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  BitmapDescriptor? runnerIcon;
  Set<Polyline> polyline = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.navigate_before_outlined,
            size: 35,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Improve Share Button
              final RenderBox box = context.findRenderObject() as RenderBox;
              Share.share("${widget.activityStats?.map["km"]}",
                  subject: "${widget.activityStats?.map["step"]}",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
            icon: Icon(Icons.share),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  heightFactor: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Details",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: productSans,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  endIndent: 10,
                  indent: 10,
                  thickness: 0.8,
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: EdgeInsets.all(10),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    textBaseline: TextBaseline.alphabetic,
                    children: <TableRow>[
                      TableRow(
                        children: <Widget>[
                          TextWidget(
                            text: "Distance",
                          ),
                          TextWidget(
                            text:
                                "${widget.activityStats?.map["km"].toStringAsFixed(3)} Km",
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          TextWidget(text: "Kcal"),
                          TextWidget(
                              text: "${widget.activityStats?.map["kcal"]}"),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          TextWidget(text: "Time"),
                          TextWidget(
                              text: "${widget.activityStats?.map["time"]}"),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          TextWidget(text: "Date"),
                          TextWidget(
                              text:
                                  "${ActivityStats.toDate(widget.activityStats?.map["date"])}"),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          TextWidget(text: "Average Speed"),
                          TextWidget(
                              text:
                                  "${widget.activityStats?.map["averagespeed"]}"),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          TextWidget(text: "Step"),
                          TextWidget(
                              text: "${widget.activityStats?.map["step"]}"),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  height: 350,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: ActivityStats.stringtoLatLng(
                                widget.activityStats?.map["coordinate"])
                            .first,
                        zoom: 15),
                    onMapCreated: (map) {},
                    markers: createMarker(
                        runnerIcon ?? BitmapDescriptor.defaultMarker),
                    myLocationButtonEnabled: false,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addPolyLine() {
    if (mounted) {
      //print(mounted.toString());
      setState(() {
        PolylineId id = PolylineId("poly");
        Polyline polyline = Polyline(
            width: 3,
            visible: true,
            polylineId: id,
            color: Colors.red.withOpacity(0.5),
            points: ActivityStats.stringtoLatLng(
                widget.activityStats?.map["coordinate"]));
        polylines[id] = polyline;
      });
    }
  }

  // TODO: Add Between markes here
  Set<Marker> createMarkerActivityStats() {
    return {
      Marker(
        markerId: MarkerId("marker_1"),
        position: ActivityStats.stringtoLatLng(
                widget.activityStats?.map["coordinate"])
            .first,
        infoWindow: InfoWindow(title: 'Runner'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    }.toSet();
  }
}

class TextWidget extends StatelessWidget {
  final String? text;

  const TextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 15, 5, 10),
      child: Text(
        text ?? "Empty Field",
        style: TextStyle(
            color: Colors.black,
            fontFamily: productSans,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            backgroundColor: Colors.white),
      ),
    );
  }
}
