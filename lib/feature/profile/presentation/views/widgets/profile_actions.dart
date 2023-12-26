import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../Core/utils/app_router.dart';
import '../../../../Auth/presentation/views/widgets/custom_elevated_button.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              text: 'Edit Profile',
              onPressed: () =>
                  GoRouter.of(context).push(AppRouter.kEditProfileView),
            ),
          ),
        ],
      ),
    );
  }
}
