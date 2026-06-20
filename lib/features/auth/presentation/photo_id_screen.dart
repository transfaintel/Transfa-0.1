import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/transfa_logo.dart';

class PhotoIdScreen extends StatefulWidget {
  const PhotoIdScreen({super.key});

  @override
  State<PhotoIdScreen> createState() => _PhotoIdScreenState();
}

class _PhotoIdScreenState extends State<PhotoIdScreen> with SingleTickerProviderStateMixin {
  final _nin = TextEditingController(text: '');
  File? _uploadedImage;
  bool _isUploading = false;
  OverlayEntry? _overlayEntry;
  late AnimationController _popupAnimationController;
  late Animation<Offset> _popupSlideAnimation;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _popupAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _popupSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _popupAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _nin.dispose();
    _popupAnimationController.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _submit() => context.push(Routes.addMoney);

  Future<bool> _requestPermissions() async {
    // For Android 13+ (API 33+)
    if (await Permission.photos.request().isGranted) {
      return true;
    }
    
    // For older Android versions
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    
    // For camera permission if needed
    if (await Permission.camera.request().isGranted) {
      return true;
    }
    
    // Show permission dialog if denied
    if (context.mounted) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text('Please grant storage permission to select photos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
      
      if (result == true) {
        await openAppSettings();
        // Check again after opening settings
        if (await Permission.photos.isGranted || await Permission.storage.isGranted) {
          return true;
        }
      }
    }
    
    return false;
  }

  Future<void> _pickImage() async {
    // Request permissions first
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      if (mounted) {
        _showErrorNotification(
          'Permission Denied',
          'Please grant storage permission to upload photos',
        );
      }
      return;
    }

    try {
      // Show image source selection dialog
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Photo Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      setState(() {
        _isUploading = true;
      });

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _uploadedImage = File(pickedFile.path);
          _isUploading = false;
        });
        
        // Simulate upload verification
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _showUnsupportedIdPopup();
          // _showSuccessNotification();
        }
      } else {
        setState(() {
          _isUploading = false;
        });
        if (mounted) {
          _showUnsupportedIdPopup();
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error picking image: $e');
      if (mounted) {
        _showErrorNotification(
          'Upload Failed',
          'Unable to pick image. Please try again.',
        );
      }
    }
  }

  void _showSuccessNotification() {
    final overlay = Overlay.of(context);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildSuccessNotification(),
    );
    
    overlay.insert(_overlayEntry!);
    _popupAnimationController.forward();
    
    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _hideOverlay();
      }
    });
  }

  void _showErrorNotification(String title, String message) {
    final overlay = Overlay.of(context);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildErrorNotification(title, message),
    );
    
    overlay.insert(_overlayEntry!);
    _popupAnimationController.forward();
    
    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _hideOverlay();
      }
    });
  }

  void _showUnsupportedIdPopup() {
    final overlay = Overlay.of(context);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildUnsupportedIdPopup(),
    );
    
    overlay.insert(_overlayEntry!);
    _popupAnimationController.forward();
  }

  void _hideOverlay() {
    _popupAnimationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  Widget _buildSuccessNotification() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _popupSlideAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFB).withOpacity(0.95),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Photo Uploaded Successfully',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your photo ID has been added',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _hideOverlay,
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorNotification(String title, String message) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _popupSlideAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFB).withOpacity(0.95),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4466),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.error, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _hideOverlay,
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
Widget _buildUnsupportedIdPopup() {
  return GestureDetector(
    onTap: _hideOverlay,
    child: Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping inside
          child: SlideTransition(
            position: _popupSlideAnimation,
            child: Container(
              width: 270,
              height: 458,
              decoration: BoxDecoration(
                color: const Color(0xFFFCFCFB).withOpacity(0.5),
                borderRadius: BorderRadius.circular(45),
              ),
              child:Material(
                      color: Colors.transparent,
                      child:  Column(
                children: [
                  // Unsupported ID Header Card
                  Container(
                    width: 246,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Photo ID Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                                Assets.photoId,
                                width: 60,
                                height: 60,
                              ),
                           
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Storyline
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unsupported ID',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'To continue, pick a Photo ID, enter your NIN, then add a clear picture of your Photo ID and verify.',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.34,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Options
                  Container(
                    width: 246,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        // Continue Button
                        GestureDetector(
                          onTap: () {
                            _hideOverlay();
                            // Navigate to verify NIN page
                            context.push(Routes.verifyNin);
                          },
                          child: Container(
                            width: 222,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFFF4466), Color(0xFFF41E42)],
                              ),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: const Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.34,
                                  color: Color(0xFFFCFCFB),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Photo ID Guide Button
                        GestureDetector(
                          onTap: () {
                            _hideOverlay();
                            // Navigate to photo ID guide page
                            context.push(Routes.photoIdGuide);
                          },
                          child: Container(
                            width: 222,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: const Center(
                              child: Text(
                                'Photo ID Guide',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.34,
                                  color: Color(0xFFFCFCFB),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Intro card
              GlassCard(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(Assets.photoId, height: 64),
                    const SizedBox(height: 24),
                    Text(
                      'Add Your Photo ID',
                      style: AppTypography.displayMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Identify at the airport, checkpoints,\nonline & anywhere in the world.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 2. Form card — NIN pill + detached X clear, then upload tile.
              GlassCard(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _NinField(
                            controller: _nin,
                            onClear: () => _nin.clear(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _ClearButton(onTap: () => _nin.clear()),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _PhotoUploadTile(
                      uploadedImage: _uploadedImage,
                      onTap: _pickImage,
                      isUploading: _isUploading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Dark "Add to / Transfa" submit pill
              _AddToTransfaPill(onTap: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _NinField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  const _NinField({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.lock_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]'))],
              style: AppTypography.subheading.copyWith(
                fontSize: 19,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
              decoration: InputDecoration(
                hintText: '0000 1111 0000 2222',
                hintStyle: AppTypography.subheading.copyWith(
                  fontSize: 19,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ClearButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.close_rounded, color: Colors.black, size: 26),
      ),
    );
  }
}

class _PhotoUploadTile extends StatelessWidget {
  final File? uploadedImage;
  final VoidCallback onTap;
  final bool isUploading;
  
  const _PhotoUploadTile({
    required this.onTap,
    this.uploadedImage,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: uploadedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      uploadedImage!,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Photo ID Uploaded',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Replace',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isUploading)
                    const SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF1A1A1A),
                      ),
                    )
                  else
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                    ),
                  const SizedBox(height: 14),
                  Text(
                    isUploading ? 'Uploading...' : 'Add Your Photo ID',
                    style: AppTypography.subheading.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AddToTransfaPill extends StatelessWidget {
  final VoidCallback onTap;
  const _AddToTransfaPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.fromLTRB(8, 8, 68, 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const TransfaMark(size: 26, white: true),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add to',
                    style: AppTypography.body.copyWith(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 17,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Transfa',
                    style: AppTypography.subheading.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}