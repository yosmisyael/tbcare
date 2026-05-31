import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/core/di/injection_container.dart';
import 'package:TBConsult/features/auth/presentation/pages/profile_settings_page.dart';
import 'package:TBConsult/features/treatment/presentation/cubit/dashboard_cubit.dart';

class SharedSliverAppBar extends StatefulWidget {
  final bool pinned;
  final bool floating;
  final Color backgroundColor;

  const SharedSliverAppBar({
    super.key,
    this.pinned = false,
    this.floating = true,
    this.backgroundColor = const Color(0xFFF5F7F6),
  });

  @override
  State<SharedSliverAppBar> createState() => _SharedSliverAppBarState();
}

class _SharedSliverAppBarState extends State<SharedSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final photoBase64 = prefs.getString('user_profile_photo_base64');
    final hasPhoto = photoBase64 != null && photoBase64.isNotEmpty;

    return SliverAppBar(
      backgroundColor: widget.backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      pinned: widget.pinned,
      floating: widget.floating,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primary),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'TBConsult',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
              );
              // Trigger a local state rebuild of the app bar so the avatar refreshes
              setState(() {});
              
              // Refresh the dashboard if DashboardCubit is in context
              if (mounted) {
                try {
                  context.read<DashboardCubit>().load();
                } catch (_) {}
              }
            },
            child: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              backgroundImage: hasPhoto ? MemoryImage(base64Decode(photoBase64)) : null,
              child: !hasPhoto
                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

