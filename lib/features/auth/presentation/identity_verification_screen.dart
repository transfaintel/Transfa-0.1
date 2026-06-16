import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' show ImageFilter;
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

List<CameraDescription>? cameras;

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  File? _capturedFaceImage;
  bool _isFaceCaptured = false;
  bool _isCapturing = false;
  bool _isVerifying = false;
  Timer? _captureTimer;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFaceShotPopup();
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _captureTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    if (cameras == null || cameras!.isEmpty) {
      cameras = await availableCameras();
    }

    final frontCamera = cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras!.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  void _showFaceShotPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const _FaceShotPopup(),
    ).then((_) {
      if (mounted && !_isFaceCaptured && !_isCapturing) {
        _startAutoCapture();
      }
    });
  }

  void _startAutoCapture() {
    setState(() {
      _isCapturing = true;
    });
    _captureTimer = Timer(const Duration(seconds: 2), () async {
      await _captureFace();
    });
  }

  Future<void> _captureFace() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      setState(() {
        _isCapturing = false;
      });
      return;
    }

    try {
      final XFile = await _cameraController!.takePicture();
      final File image = File(XFile.path);

      setState(() {
        _capturedFaceImage = image;
        _isFaceCaptured = true;
        _isCapturing = false;
        _isVerifying = true;
      });

      _captureTimer?.cancel();
      
      // Simulate face verification (replace with actual API call)
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, let's say verification succeeds
      // You can add logic here to determine success/failure
      final bool isSuccess = true; // Change to false for testing failed popup
      
      setState(() {
        _isVerifying = false;
      });
      
      if (isSuccess) {
        _showSuccessPopup();
      } else {
        _showFailedPopup();
      }
    } catch (e) {
      debugPrint('Error capturing face: $e');
      setState(() {
        _isCapturing = false;
        _isVerifying = false;
      });
      _showFailedPopup();
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => _SuccessPopup(capturedFaceImage: _capturedFaceImage!),
    );
  }

  void _showFailedPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const _FailedPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 28),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) => CustomPaint(
                          size: const Size(320, 320),
                          painter: _DottedFacePainter(
                            progress: _pulse.value,
                            isFaceCaptured: _isFaceCaptured,
                          ),
                        ),
                      ),
                      if (_isCapturing && _isCameraInitialized)
                        ClipOval(
                          child: Container(
                            width: 250,
                            height: 250,
                            child: CameraPreview(_cameraController!),
                          ),
                        )
                      else if (_isVerifying)
                        ClipOval(
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      else if (_capturedFaceImage != null)
                        ClipOval(
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_capturedFaceImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      if (_isCapturing)
                        Container(
                          width: 220,
                          height: 220,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 236, 235, 236),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Follow the light, move your\nhead slowly to complete the\ncircle.',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: SvgPicture.asset(
                            Assets.transfaYou,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.body.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 15,
                              height: 1.4,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'Face Shot will recognize the unique features of your face to verify your identity & keep your Transfa secure. ',
                              ),
                              TextSpan(
                                text: 'See how to take Pro Face Shots…',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _showFaceShotPopup(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaceShotPopup extends StatefulWidget {
  const _FaceShotPopup();

  @override
  State<_FaceShotPopup> createState() => _FaceShotPopupState();
}

class _FaceShotPopupState extends State<_FaceShotPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _exampleFaces = [
    {'asset': Assets.magic, 'gradient': [const Color(0xFF00BCF6), const Color(0xFF006EFF)]},
    {'asset': Assets.Amadioha, 'gradient': [const Color(0xFFB571E3), const Color(0xFF7E2FFF)]},
    {'asset': Assets.avatarJanelle, 'gradient': [const Color(0xFF00BCF6), const Color(0xFF006EFF)]},
    {'asset': Assets.Saphirre, 'gradient': [const Color(0xFFB571E3), const Color(0xFF7E2FFF)]},
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: 378,
                decoration: BoxDecoration(
                  color: const Color(0x80FCFCFB),
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x20FFFFFF),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        Assets.transfaLife,
                                        width: 16,
                                        height: 20,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Text(
                                    'Face Shot',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      letterSpacing: 0.02,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[0]['asset'],
                                      gradientColors: _exampleFaces[0]['gradient'],
                                    ),
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[1]['asset'],
                                      gradientColors: _exampleFaces[1]['gradient'],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[2]['asset'],
                                      gradientColors: _exampleFaces[2]['gradient'],
                                    ),
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[3]['asset'],
                                      gradientColors: _exampleFaces[3]['gradient'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Your Face Shot is your identity at work, online & everywhere you go. Dress professionally, face forward, and take your finest shot.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                height: 1.5,
                                letterSpacing: 0.02,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [Color(0xFF363636), Colors.black],
                                  ).createShader(const Rect.fromLTWH(0, 0, 300, 50)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: double.infinity,
                                height: 58,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [AppColors.primaryLight, AppColors.primary],
                                  ),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Take the shot',
                                  style: AppTypography.subheading.copyWith(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleFaceCard extends StatelessWidget {
  final String assetPath;
  final List<Color> gradientColors;

  const _ExampleFaceCard({
    required this.assetPath,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144,
      height: 144,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          assetPath,
          width: 144,
          height: 144,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _SuccessPopup extends StatefulWidget {
  final File capturedFaceImage;
  const _SuccessPopup({required this.capturedFaceImage});

  @override
  State<_SuccessPopup> createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<_SuccessPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 330,
                decoration: BoxDecoration(
                  color: const Color(0xB3FCFCFB),
                  borderRadius: BorderRadius.circular(56),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x20FFFFFF),
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 300,
                            height: 300,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 220,
                                    height: 220,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(widget.capturedFaceImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.blueBubble,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.yellowBubble,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 7,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.greenBubble,
                                      width: 195,
                                      height: 195,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 7,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.redBubble,
                                      width: 195,
                                      height: 195,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Face Shot',
                            style: TextStyle(
                              fontFamily: 'Arial Rounded MT Bold',
                              fontSize: 26,
                              letterSpacing: 0.02,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Face Shot is complete.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 17,
                              letterSpacing: 0.02,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                context.push(Routes.createPin);
                              },
                              child: Container(
                                width: 270,
                                height: 58,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [AppColors.primaryLight, AppColors.primary],
                                  ),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 17,
                                    letterSpacing: 0.02,
                                    color: Color(0xFFFCFCFB),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FailedPopup extends StatefulWidget {
  const _FailedPopup();

  @override
  State<_FailedPopup> createState() => _FailedPopupState();
}

class _FailedPopupState extends State<_FailedPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 330,
                decoration: BoxDecoration(
                  color: const Color(0xB3FCFCFB),
                  borderRadius: BorderRadius.circular(56),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x20FFFFFF),
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 300,
                            height: 300,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Gray face with not recognized icon
                                ClipOval(
                                  child: Container(
                                    width: 220,
                                    height: 220,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        Assets.notRecognized,
                                        width: 170,
                                        height: 170,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.blueBubbleIncomplete,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.yellowBubbleIncomplete,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 7,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.greenBubbleIncomplete,
                                      width: 195,
                                      height: 195,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 7,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.redBubbleIncomplete,
                                      width: 195,
                                      height: 195,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Face Shot',
                            style: TextStyle(
                              fontFamily: 'Arial Rounded MT Bold',
                              fontSize: 26,
                              letterSpacing: 0.02,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Your face was not recognized.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 17,
                              letterSpacing: 0.02,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                            child: 
                                Expanded(
                                  child: GestureDetector(
                                     onTap: () {
                                      Navigator.of(context).pop();
                                      // Retry capture
                                      if (Navigator.of(context).mounted) {
                                        // Go back to retry
                                      }
                                    },
                                    child: Container(
                                      height: 58,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [AppColors.primaryLight, AppColors.primary],
                                        ),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Try Again',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 17,
                                          letterSpacing: 0.02,
                                          color: Color(0xFFFCFCFB),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DottedFacePainter extends CustomPainter {
  final double progress;
  final bool isFaceCaptured;

  _DottedFacePainter({required this.progress, required this.isFaceCaptured});

  static const _colors = [
    AppColors.success,
    Color(0xFFFF9F0A),
    Color(0xFFFF375F),
    Color(0xFFAF52DE),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 8;
    const total = 40;
    final paintDot = Paint()..color = const Color(0xFFDFDFDF);
    final anchorIdx = [
      (5 + (progress * 0.5 * total).round()) % total,
      (15 + (progress * 0.5 * total).round()) % total,
      (25 + (progress * 0.5 * total).round()) % total,
      (35 + (progress * 0.5 * total).round()) % total,
    ];

    for (var i = 0; i < total; i++) {
      final angle = -pi / 2 + (i / total) * 2 * pi;
      final dotCenter = Offset(c.dx + r * cos(angle), c.dy + r * sin(angle));
      final anchor = anchorIdx.indexOf(i);
      if (anchor >= 0) {
        final p = Paint()..color = _colors[anchor];
        canvas.drawCircle(dotCenter, 7, p);
      } else {
        canvas.drawCircle(dotCenter, 5, paintDot);
      }
    }

    if (!isFaceCaptured) {
      canvas.drawCircle(c, r - 18, Paint()..color = const Color(0xFFE9E9E9));
    }
  }

  @override
  bool shouldRepaint(covariant _DottedFacePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isFaceCaptured != isFaceCaptured;
  }
}