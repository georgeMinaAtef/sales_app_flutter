import 'package:flutter/material.dart';
import 'package:sales_app/feature/Profile/presentation/views/widgets/profile_actions.dart';
import 'package:sales_app/feature/Profile/presentation/views/widgets/profile_bio.dart';
import 'package:sales_app/feature/Profile/presentation/views/widgets/profile_header.dart';
import '../../../../Core/utils/constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    print(user);
    return const Column(
      children: [
        ProfileHeader(),
        SizedBox(height: 20),
        ProfileBio(),
        ProfileActions()
      ],
    );
  }
}
