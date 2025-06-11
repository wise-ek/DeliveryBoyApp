import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:permission_handler/permission_handler.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final LatLng deliveryAddress;
  final String orderId;
  final String customerName;

  const DeliveryTrackingPage({
    super.key,
    required this.deliveryAddress,
    required this.orderId,
    required this.customerName,
  });

  @override
  _DeliveryTrackingPageState createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  bool _isPermissionGranted = false;

  final String _googleApiKey = 'AIzaSyBlLAIe6UFqYXFo1rBPxEKnSVOowK1Vucw'; // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStartTracking();
  }

  Future<void> _checkPermissionsAndStartTracking() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        return;
      }

      var status = await Permission.location.request();
      if (status.isGranted) {
        setState(() {
          _isPermissionGranted = true;
        });
        await _startLocationUpdates();
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to check location permissions')),
        );
      }
    }
  }

  Future<void> _startLocationUpdates() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _updatePosition(position);

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Update only when user moves 5 meters
        ),
      ).listen(
            (position) {
          _updatePosition(position);
        },
        onError: (e) {
          debugPrint('Location stream error: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error updating location')),
            );
          }
        },
      );
    } catch (e) {
      debugPrint('Error getting initial position: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get location')),
        );
      }
    }
  }

  Future<void> _updatePosition(Position position) async {
    if (!mounted) return;

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers = {
        Marker(
          markerId: const MarkerId('current'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
        Marker(
          markerId: MarkerId(widget.orderId),
          position: widget.deliveryAddress,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: widget.customerName),
        ),
      };
    });

    await _drawPolyline();

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 15));
  }

  Future<void> _drawPolyline() async {
    if (_currentPosition == null) {
      debugPrint('Current position is null, skipping polyline draw');
      return;
    }

    // Validate coordinates
    if (!_isValidLatLng(_currentPosition!) || !_isValidLatLng(widget.deliveryAddress)) {
      debugPrint('Invalid coordinates: current=$_currentPosition, delivery=${widget.deliveryAddress}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid location coordinates')),
        );
      }
      return;
    }

    try {
      PolylinePoints polylinePoints = PolylinePoints();
      print('Current position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      print('Delivery address: ${widget.deliveryAddress.latitude}, ${widget.deliveryAddress.longitude}');
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: _googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          destination: PointLatLng(widget.deliveryAddress.latitude, widget.deliveryAddress.longitude),
          mode: TravelMode.driving,
        ),
      ).timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      print('Polyline request completed');
      if (result.points.isNotEmpty) {
        _polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        print('Points fetched: ${result.points.length}');

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: _polylineCoordinates,
              width: 5,
              color: Colors.blue,
            ),
          };
        });
        debugPrint('Route loaded successfully with ${result.points.length} points');
      } else {
        debugPrint('No route found: ${result.errorMessage}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No route found: ${result.errorMessage ?? 'Unknown error'}')),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error drawing polyline: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load route due to an error'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _drawPolyline(),
            ),
          ),
        );
      }
      // Retry after 5 seconds for transient errors
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        await _drawPolyline();
      }
    }
  }

  bool _isValidLatLng(LatLng latLng) {
    return latLng.latitude >= -90 &&
        latLng.latitude <= 90 &&
        latLng.longitude >= -180 &&
        latLng.longitude <= 180 &&
        latLng.latitude != 0.0 &&
        latLng.longitude != 0.0;
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _controller.future.then((controller) => controller.dispose()).catchError((e) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Tracking')),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition ?? widget.deliveryAddress, // Fallback to delivery address
          zoom: 15,
        ),
        myLocationEnabled: _isPermissionGranted,
        myLocationButtonEnabled: _isPermissionGranted,
        onMapCreated: (controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        },
        markers: _markers,
        polylines: _polylines,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_currentPosition != null) {
            final controller = await _controller.future;
            await controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 15));
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}