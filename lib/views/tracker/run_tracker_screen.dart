import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_right/controllers/run_tracking_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/services/gps_service.dart';
import 'package:get_right/services/storage_service.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';
import 'package:get_right/views/home/dashboard_screen.dart';

/// Run Tracker - GPS tracking and run history
class RunTrackerScreen extends StatefulWidget {
  const RunTrackerScreen({super.key});

  @override
  State<RunTrackerScreen> createState() => _RunTrackerScreenState();
}

class _RunTrackerScreenState extends State<RunTrackerScreen> {
  final RunTrackingController _trackingController = Get.put(RunTrackingController());
  GoogleMapController? _mapController;
  int _totalRuns = 0;
  double _totalDistance = 0.0;
  bool _mapLoadError = false;
  bool _isMapCreated = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _initializeLocation();
    // Listen to position updates and update camera only
    ever(_trackingController.currentPosition, (position) {
      if (position != null && _mapController != null && _isMapCreated && mounted) {
        _updateCameraPosition(position);
      }
    });
  }

  /// Initialize location with proper error handling
  Future<void> _initializeLocation() async {
    try {
      final gpsService = GpsService.getInstance();

      // Check if location services are enabled
      final serviceEnabled = await gpsService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          Get.snackbar(
            'Location Disabled',
            'Please enable location services to use the Run Tracker',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            mainButton: TextButton(onPressed: () => gpsService.openLocationSettings(), child: const Text('Open Settings')),
          );
        }
        return;
      }

      // Check and request permission if needed
      var permission = await gpsService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await gpsService.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            Get.snackbar('Permission Required', 'Location permission is required to track your runs', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          Get.snackbar(
            'Permission Denied',
            'Please enable location permission in app settings',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            mainButton: TextButton(onPressed: () => gpsService.openAppSettings(), child: const Text('Open Settings')),
          );
        }
        return;
      }

      // Get current location
      final position = await gpsService.getCurrentLocation();
      if (position != null && mounted) {
        _trackingController.currentPosition.value = position;
        debugPrint('✅ Location initialized: ${position.latitude}, ${position.longitude}');
      } else {
        debugPrint('❌ Failed to get location');
      }
    } catch (e) {
      debugPrint('❌ Location initialization error: $e');
      if (mounted) {
        Get.snackbar('Location Error', 'Failed to initialize location: $e', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
      }
    }
  }

  @override
  void dispose() {
    _isMapCreated = false;
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  /// Update camera position without rebuilding the map
  void _updateCameraPosition(position) {
    if (_mapController != null && _isMapCreated) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
    }
  }

  Future<void> _loadStats() async {
    final storageService = Get.find<StorageService>();
    final runsCount = await storageService.getTotalRunsCount();
    final distance = await storageService.getTotalDistance();
    setState(() {
      _totalRuns = runsCount;
      _totalDistance = distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Preview - Full Screen
          _buildMapPreview(),

          // Bottom Sheet with Activity Selection
          Positioned(left: 0, right: 0, bottom: 0, child: _buildActionButtons()),

          // Plan Route Button - Top Right
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              color: AppColors.accent,
              child: InkWell(
                onTap: () => Get.toNamed(AppRoutes.routePlanning),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined, color: AppColors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Plan Route',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build map preview with Google Maps - Full Screen
  Widget _buildMapPreview() {
    return Obx(() {
      final position = _trackingController.currentPosition.value;
      final hasPosition = position != null;

      debugPrint('🗺️ Building map preview - hasPosition: $hasPosition, mapError: $_mapLoadError');

      return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            hasPosition
                ? _mapLoadError
                      ? _buildMapErrorState(position)
                      : _buildGoogleMapWidget(position)
                : Container(
                    color: AppColors.surface,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), shape: BoxShape.circle),
                            child: const Icon(Icons.location_searching, size: 40, color: AppColors.accent),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Finding your location...',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 3)),
                        ],
                      ),
                    ),
                  ),

            // Top overlay with gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.black.withOpacity(0.6), AppColors.black.withOpacity(0)]),
                ),
              ),
            ),

            // Map info badge
            if (hasPosition)
              Positioned(
                top: MediaQuery.of(Get.context!).padding.top + 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.gps_fixed, color: AppColors.accent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'GPS Ready',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  /// Build Google Map widget with error handling - only builds once
  Widget _buildGoogleMapWidget(position) {
    // Only log on first build
    if (!_isMapCreated) {
      debugPrint('🗺️ Building GoogleMap widget - Position: ${position.latitude}, ${position.longitude}');
    }

    try {
      return GoogleMap(
        key: const ValueKey('static_google_map'), // Static key prevents rebuilds
        initialCameraPosition: CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 15),
        onMapCreated: (controller) {
          debugPrint('✅ Map created successfully');
          if (!_isMapCreated || _mapController == null) {
            _mapController = controller;
            _isMapCreated = true;
            try {
              _setMapStyle(controller);
              debugPrint('✅ Map style applied');
            } catch (e) {
              debugPrint('⚠️ Map style error: $e');
              // Style error doesn't prevent map from working
            }
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        liteModeEnabled: false, // Disable lite mode to prevent buffer issues
        buildingsEnabled: true,
        indoorViewEnabled: false,
        trafficEnabled: false,
      );
    } catch (e) {
      debugPrint('❌ Error building map: $e');
      // Schedule error state update for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _mapLoadError = true;
          });
        }
      });
      // Return loading state while error is being set
      return Container(
        color: AppColors.surface,
        child: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }
  }

  /// Build map error state with location info
  Widget _buildMapErrorState(position) {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColors.upcoming.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.map_outlined, size: 40, color: AppColors.upcoming),
              ),
              const SizedBox(height: 16),
              Text(
                'Map Unavailable',
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Please add your Google Maps API key to enable maps',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'GPS Location Ready',
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lat: ${position.latitude.toStringAsFixed(6)}\nLng: ${position.longitude.toStringAsFixed(6)}',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _mapLoadError = false;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Setup Required',
                        'Please check GET_GOOGLE_MAPS_API_KEY.md for instructions',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                      );
                    },
                    icon: const Icon(Icons.help_outline, size: 18),
                    label: const Text('How to fix?'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Set custom map style for dark theme
  void _setMapStyle(GoogleMapController controller) {
    const String mapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [{"color": "#1a1a1a"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#8a8a8a"}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "#1a1a1a"}]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [{"color": "#2a2a2a"}]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [{"color": "#29603C"}, {"lightness": -40}]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [{"color": "#2a2a2a"}]
      },
      {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [{"color": "#1a1a1a"}]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{"color": "#000000"}]
      }
    ]
    ''';
    controller.setMapStyle(mapStyle);
  }

  /// Build activity type selector and action buttons
  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),

          // Activity Type Label

          // Activity Type Buttons

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Start Tracking Button
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.activityTypeSelection);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.accent.withOpacity(0.5), width: 2),
                        foregroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Start Tracking',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // View History Button
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed(AppRoutes.runHistory);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryGray.withOpacity(0.5), width: 2),
                        foregroundColor: AppColors.onSurface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.history_rounded, size: 20),
                      label: Text(
                        'View History',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurface),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build activity type button
}
