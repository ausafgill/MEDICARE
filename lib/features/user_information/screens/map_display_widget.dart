import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:medicare/shared/constants/colors.dart';

class MapDisplayWidget extends StatefulWidget {
  static const routeName = '/map-display-widget';
  final double latitude, longitude;
  final bool isStatic;
  const MapDisplayWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.isStatic = false,
  });

  @override
  State<MapDisplayWidget> createState() => _MapDisplayWidgetState();
}

class _MapDisplayWidgetState extends State<MapDisplayWidget> {
  late MapController controller;
  @override
  void initState() {
    controller = MapController.withPosition(
      initPosition: GeoPoint(
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: OSMFlutter(
              controller: controller,
              osmOption: OSMOption(
                staticPoints: widget.isStatic
                    ? [
                        StaticPositionGeoPoint(
                          "random",
                          const MarkerIcon(
                            icon: Icon(Icons.location_on),
                          ),
                          [
                            GeoPoint(
                              latitude: widget.latitude,
                              longitude: widget.longitude,
                            ),
                          ],
                        )
                      ]
                    : [],
                zoomOption: const ZoomOption(
                  initZoom: 12,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                isPicker: !widget.isStatic,
                showZoomController: true,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  if (widget.isStatic) {
                    Navigator.pop(context);
                  }
                  var p = await controller
                      .getCurrentPositionAdvancedPositionPicker();
                  await controller.cancelAdvancedPositionPicker();

                  if (context.mounted) {
                    Navigator.pop(context, p);
                  }
                },
                child: Container(
                  height: 50,
                  width: 125,
                  decoration: BoxDecoration(
                    color: EColors.primaryColor,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: EColors.light,
                    ),
                    title: Text(
                      widget.isStatic ? "Back" : "PICK",
                      style: TextStyle(color: EColors.light),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
