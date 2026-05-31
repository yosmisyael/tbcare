import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:TBConsult/core/di/injection_container.dart';
import 'package:TBConsult/core/network/dio_client.dart';
import 'package:TBConsult/core/theme/app_colors.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  
  late final SharedPreferences _prefs;
  String? _photoBase64;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _prefs = sl<SharedPreferences>();
    _usernameCtrl.text = _prefs.getString('user_display_name') ?? '';
    _photoBase64 = _prefs.getString('user_profile_photo_base64');
    _loadProfileFromBackend();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfileFromBackend() async {
    try {
      final dio = sl<DioClient>().dio;
      final response = await dio.get('/auth/me');
      final data = response.data;
      if (data != null) {
        setState(() {
          _usernameCtrl.text = data['full_name'] ?? '';
          _photoBase64 = data['profile_photo'];
          _isLoading = false;
        });
        
        await _prefs.setString('user_display_name', _usernameCtrl.text.trim());
        if (_photoBase64 != null) {
          await _prefs.setString('user_profile_photo_base64', _photoBase64!);
        } else {
          await _prefs.remove('user_profile_photo_base64');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final bytes = await File(pickedFile.path).readAsBytes();
        final base64String = base64Encode(bytes);
        setState(() {
          _photoBase64 = base64String;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Ambil Foto Baru'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_photoBase64 != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus Foto', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _photoBase64 = null;
                  });
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _showPhotoOptions,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                            backgroundImage: _photoBase64 != null
                                ? MemoryImage(base64Decode(_photoBase64!))
                                : null,
                            child: _photoBase64 == null
                                ? const Icon(Icons.person, size: 55, color: AppColors.primary)
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Ganti Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _oldPasswordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password Lama',
                      prefixIcon: const Icon(Icons.lock_open_outlined, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (_newPasswordCtrl.text.isNotEmpty && (value == null || value.isEmpty)) {
                        return 'Password lama wajib diisi untuk mengganti password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _newPasswordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty && value.length < 6) {
                        return 'Password baru minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isSaving ? null : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          _isSaving = true;
                        });
                        try {
                          final dio = sl<DioClient>().dio;
                          await dio.put(
                            '/auth/profile',
                            data: {
                              'full_name': _usernameCtrl.text.trim(),
                              'profile_photo': _photoBase64,
                              if (_newPasswordCtrl.text.isNotEmpty) ...{
                                'old_password': _oldPasswordCtrl.text,
                                'new_password': _newPasswordCtrl.text,
                              }
                            },
                          );

                          await _prefs.setString('user_display_name', _usernameCtrl.text.trim());
                          if (_photoBase64 != null) {
                            await _prefs.setString('user_profile_photo_base64', _photoBase64!);
                          } else {
                            await _prefs.remove('user_profile_photo_base64');
                          }

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profil berhasil diperbarui'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } on DioException catch (e) {
                          final msg = e.response?.data?['detail'] ?? 'Gagal memperbarui profil: $e';
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(msg.toString()),
                                backgroundColor: Colors.red.shade700,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isSaving = false;
                            });
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading || _isSaving)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

