import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:get_right/controllers/run_tracking_controller.dart';
import 'package:get_right/routes/app_routes.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Active Run Screen - Live GPS tracking with map and stats
class ActiveRunScreen extends StatefulWidget {
  const ActiveRunScreen({super.key});

  @override
  State<ActiveRunScreen> createState() => _ActiveRunScreenState();
}

class _ActiveRunScreenState extends State<ActiveRunScreen> with SingleTickerProviderStateMixin {
  final RunTrackingController _controller = Get.find<RunTrackingController>();
  GoogleMapController? _mapController;
  late AnimationController _pulseController;
  Timer? _mapUpdateTimer;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _startMapUpdates();

    // Get activity type from arguments if provided
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['activityType'] != null) {
      _controller.activityType.value = args['activityType'];
    }

    // Start tracking automatically
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.startTracking(activity: _controller.activityType.value);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapUpdateTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _startMapUpdates() {
    _mapUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final position = _controller.currentPosition.value;
      if (position != null && _mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Map Layer
            _buildMap(),

            // Overlay with stats (hidden when locked)
            if (!_isLocked) _buildStatsOverlay(),

            // Control buttons at bottom (hidden when locked)
            if (!_isLocked) _buildControlButtons(),

            // Top safe area with back button (hidden when locked)
            if (!_isLocked) _buildTopBar(),

            // Lock overlay (shown when locked)
            if (_isLocked) _buildLockOverlay(),
          ],
        ),
      ),
    );
  }

  /// Build map with route
  Widget _buildMap() {
    return Obx(() {
      final position = _controller.currentPosition.value;
      final routePoints = _controller.routePoints;

      if (position == null) {
        return Container(
          color: AppColors.surface,
          child: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        );
      }

      // Create polyline from route points
      final Set<Polyline> polylines = {};
      if (routePoints.length > 1) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('run_route'),
            points: routePoints.map((point) => LatLng(point.latitude, point.longitude)).toList(),
            color: AppColors.accent,
            width: 5,
            patterns: [PatternItem.dot, PatternItem.gap(10)],
          ),
        );
      }

      return GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 17),
        onMapCreated: (controller) {
          _mapController = controller;
          _setMapStyle(controller);
        },
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        polylines: polylines,
        markers: {
          Marker(
            markerId: const MarkerId('current_position'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            anchor: const Offset(0.5, 0.5),
          ),
        },
      );
    });
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

  /// Build top bar with status
  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 12, left: 12, right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.black.withOpacity(0.8), AppColors.black.withOpacity(0)]),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.white, size: 28),
              onPressed: _showExitDialog,
            ),
            Expanded(
              child: Center(
                child: Obx(() {
                  final status = _controller.runStatus.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: status == 'Paused' ? AppColors.upcoming.withOpacity(0.9) : AppColors.accent.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  /// Build stats overlay
  Widget _buildStatsOverlay() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      left: 16,
      right: 16,
      child: Obx(() {
        return Column(
          children: [
            // Main stat cards - Row 1
            Row(
              children: [
                Expanded(child: _buildStatCard('Distance', _controller.formatDistance(_controller.distanceMeters.value), Icons.straighten_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Time', _controller.formatDuration(_controller.elapsedTime.value), Icons.timer_rounded)),
              ],
            ),
            const SizedBox(height: 12),
            // Row 2
            Row(
              children: [
                Expanded(child: _buildStatCard('Pace', '${_controller.formatPace(_controller.currentPace.value)}/km', Icons.speed_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Avg Pace', '${_controller.formatPace(_controller.averagePace.value)}/km', Icons.insights_rounded)),
              ],
            ),
            const SizedBox(height: 12),
            // Row 3
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Calories', _controller.caloriesBurned.value > 0 ? '${_controller.caloriesBurned.value} cal' : '--', Icons.local_fire_department_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Elevation', _controller.formatElevation(_controller.elevationGain.value), Icons.terrain_rounded)),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 18),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGray, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 20),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Build control buttons
  Widget _buildControlButtons() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 24,
      left: 0,
      right: 0,
      child: Obx(() {
        final isPaused = _controller.isPaused.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stop button
              _buildControlButton(icon: Icons.stop_rounded, label: 'End', color: AppColors.error, onPressed: _showStopDialog),
              const SizedBox(width: 20),
              // Pause/Resume button
              _buildControlButton(
                icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                label: isPaused ? 'Resume' : 'Pause',
                color: isPaused ? AppColors.accent : AppColors.upcoming,
                onPressed: () {
                  if (isPaused) {
                    _controller.resumeTracking();
                  } else {
                    _controller.pauseTracking();
                  }
                },
                isLarge: true,
              ),
              const SizedBox(width: 20),
              // Lock button
              _buildControlButton(
                icon: _isLocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                label: _isLocked ? 'Unlock' : 'Lock',
                color: _isLocked ? AppColors.accent : AppColors.primaryGray,
                onPressed: () {
                  setState(() {
                    _isLocked = !_isLocked;
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildControlButton({required IconData icon, required String label, required Color color, required VoidCallback onPressed, bool isLarge = false}) {
    final size = isLarge ? 75.0 : 65.0;
    final iconSize = isLarge ? 36.0 : 28.0;

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 3),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Icon(icon, color: AppColors.white, size: iconSize),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: AppColors.black.withOpacity(0.8), blurRadius: 4)],
          ),
        ),
      ],
    );
  }

  /// Show exit confirmation dialog
  void _showExitDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Discard Run?', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
        content: Text('Are you sure you want to exit without saving this run?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryGray)),
          ),
          TextButton(
            onPressed: () {
              _controller.cancelTracking();
              Get.back(); // Close dialog
              Get.back(); // Go back to tracker screen
            },
            child: Text('Discard', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  /// Show stop confirmation dialog
  void _showStopDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Finish Run?', style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface)),
        content: Text('Do you want to save this run?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGray)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryGray)),
          ),
          TextButton(
            onPressed: () async {
              final run = await _controller.stopTracking();
              Get.back(); // Close dialog
              if (run != null) {
                Get.offNamed(AppRoutes.runDetail, arguments: run);
              } else {
                Get.back(); // Go back to tracker screen
              }
            },
            child: Text('Save', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  /// Build lock overlay - shows minimal stats when screen is locked
  Widget _buildLockOverlay() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isLocked = false;
        });
      },
      child: Container(
        color: AppColors.black,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lock icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryGray.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 2),
                ),
                child: Icon(Icons.lock_rounded, color: AppColors.accent, size: 48),
              ),
              const SizedBox(height: 32),

              // Minimal stats display
              Obx(() {
                return Column(
                  children: [
                    // Time (large)
                    Text(
                      _controller.formatDuration(_controller.elapsedTime.value),
                      style: AppTextStyles.headlineLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 64),
                    ),
                    const SizedBox(height: 24),

                    // Distance and Pace
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLockStat('Distance', _controller.formatDistance(_controller.distanceMeters.value)),
                        const SizedBox(width: 32),
                        _buildLockStat('Pace', '${_controller.formatPace(_controller.currentPace.value)}/km'),
                        const SizedBox(width: 32),
                        _buildLockStat('Cal', _controller.caloriesBurned.value > 0 ? '${_controller.caloriesBurned.value}' : '--'),
                      ],
                    ),
                  ],
                );
              }),

              const SizedBox(height: 48),

              // Unlock hint
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, color: AppColors.accent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Tap to unlock',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryGray, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ],
    );
  }
}
