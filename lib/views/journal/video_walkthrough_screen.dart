import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

class VideoWalkthroughScreen extends StatefulWidget {
  const VideoWalkthroughScreen({super.key});
  @override
  State<VideoWalkthroughScreen> createState() => _VideoWalkthroughScreenState();
}

class _VideoWalkthroughScreenState extends State<VideoWalkthroughScreen> {
  String _exerciseName = '';
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) _exerciseName = args['exerciseName'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.accent, size: 20), onPressed: () => Get.back()), title: Text('Video Walkthrough', style: AppTextStyles.titleMedium.copyWith(color: AppColors.onBackground)), centerTitle: true),
      body: Column(children: [
        const Spacer(),
        Container(margin: const EdgeInsets.symmetric(horizontal: 24), height: 200, decoration: BoxDecoration(color: AppColors.primaryGrayLight, borderRadius: BorderRadius.circular(16)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [GestureDetector(onTap: () => setState(() => _isPlaying = !_isPlaying), child: Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle), child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppColors.primaryGrayDark, size: 32))), const SizedBox(height: 16), Text('Exercise Video', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGrayDark)), const SizedBox(height: 4), Text(_exerciseName, style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface))])),
        const Spacer(),
        Padding(padding: const EdgeInsets.only(bottom: 48), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [GestureDetector(onTap: () {}, child: Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryGrayLight, width: 2)), child: const Icon(Icons.fast_rewind, color: AppColors.onSurface, size: 24))), const SizedBox(width: 24), GestureDetector(onTap: () => setState(() => _isPlaying = !_isPlaying), child: Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle), child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppColors.onAccent, size: 28))), const SizedBox(width: 24), GestureDetector(onTap: () {}, child: Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryGrayLight, width: 2)), child: const Icon(Icons.fast_forward, color: AppColors.onSurface, size: 24)))])),
      ]),
    );
  }
}

