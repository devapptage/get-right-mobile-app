import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  // Rx<ProfileModel> user = ProfileModel().obs;

  // setUser(ProfileModel data) {
  //   user.value = data;
  //   update();
  // }

  // DecorationImage getProfileImage() {
  //   final profileImage = user.value.data?.user?.profile?.profilePicture?.url;
  //   final ProfileId = user.value.data?.user?.profile?.sId;

  //   if (profileImage == null ||
  //       profileImage.isEmpty ||
  //       profileImage == "null") {
  //     return const DecorationImage(
  //       scale: 3,
  //       image: AssetImage(
  //         "assets/images/profile_icon.png",
  //       ),
  //       fit: BoxFit.scaleDown,
  //     );
  //   } else {
  //     return DecorationImage(
  //       image: NetworkImage(
  //         // '${AppUrl.imageUrl}$profileImage',
  //         profileImage,
  //       ),
  //       fit: BoxFit.cover,
  //     );
  //   }
  // }

  // String getProfileImagePath() {
  //   final profileImage = user.value.data?.user?.profile?.profilePicture?.url;
  //   if (profileImage == null ||
  //       profileImage.isEmpty ||
  //       profileImage == "null") {
  //     return "assets/images/profile_icon.png";
  //   } else {
  //     // return '${AppUrl.imageUrl}$profileImage';
  //     return profileImage;
  //   }
  // }
}
