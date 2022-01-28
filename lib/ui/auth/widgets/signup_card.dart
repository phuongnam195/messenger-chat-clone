import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../generated/l10n.dart';
import '../../../models/profile.dart';
import './auth_text_field.dart';

class SignUpCard extends StatefulWidget {
  final String? initEmail;
  final String? initPassword;
  final Future<bool> Function(Profile info, String password, File? imageFile)
      onSubmit;

  const SignUpCard(
      {this.initEmail, this.initPassword, required this.onSubmit, Key? key})
      : super(key: key);

  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Image? _avatar;
  bool _isAvatarLoading = false;

  bool _canSignUp = true;

  Future<void> _pickImage(BuildContext context) async {
    Widget _menuItem(String label, IconData icon, void Function() onTap) {
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width / 3),
              Icon(
                icon,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
        onTap: onTap,
      );
    }

    final ImageSource? source = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _menuItem(S.current.source_camera, Icons.camera_alt_rounded, () {
                Navigator.of(context).pop(ImageSource.camera);
              }),
              const Divider(height: 0),
              _menuItem(S.current.source_gallery, Icons.image, () {
                Navigator.of(context).pop(ImageSource.gallery);
              }),
            ],
          );
        });
    if (source == null) {
      return;
    }
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _isAvatarLoading = true;
    });
    _imageFile = File(pickedImage.path);
    _avatar = Image.file(_imageFile!);
    await precacheImage(_avatar!.image, context);
    setState(() {
      _isAvatarLoading = false;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _canSignUp = false;
    });
    final newProfile = Profile(
      id: '',
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );
    final success = await widget.onSubmit(
      newProfile,
      _passwordController.text,
      _imageFile,
    );
    if (!success) {
      setState(() {
        _canSignUp = true;
      });
    }
  }

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController(text: widget.initEmail);
    _passwordController = TextEditingController(text: widget.initPassword);
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var bigGap = screenHeight / 25;
    var smallGap = screenHeight / 75;

    return Container(
        width: screenWidth > 400 ? 400 : null,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(context),
              child: SizedBox(
                height: screenHeight / 5,
                child: _isAvatarLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CircleAvatar(
                        radius: 83,
                        backgroundImage: _avatar?.image,
                        backgroundColor: Colors.grey[300],
                        child: _avatar == null
                            ? Center(
                                child: FractionallySizedBox(
                                  heightFactor: 0.6,
                                  widthFactor: 0.6,
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.person,
                                      size: 100,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
              ),
            ),
            SizedBox(height: bigGap),
            Row(
              children: [
                Flexible(
                  child: AuthTextField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    labelText: 'Họ',
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_lastNameFocusNode);
                    },
                    borderRadius: BorderRadius.circular(16),
                    hasBorderSide: true,
                  ),
                ),
                SizedBox(width: smallGap),
                Flexible(
                  child: AuthTextField(
                    controller: _lastNameController,
                    focusNode: _lastNameFocusNode,
                    textInputAction: TextInputAction.next,
                    labelText: 'Tên',
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    borderRadius: BorderRadius.circular(16),
                    hasBorderSide: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: smallGap),
            AuthTextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              labelText: 'Địa chỉ email',
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              borderRadius: BorderRadius.circular(16),
              hasBorderSide: true,
            ),
            SizedBox(height: smallGap),
            AuthTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              labelText: 'Mật khẩu',
              onSubmitted: (_) async {
                if (_canSignUp) {
                  await _signUp();
                }
              },
              obscureText: true,
              borderRadius: BorderRadius.circular(16),
              hasBorderSide: true,
            ),
            SizedBox(height: bigGap),
            SizedBox(
              width: screenWidth / 3,
              height: screenHeight / 13,
              child: ElevatedButton(
                child: const FractionallySizedBox(
                    heightFactor: 0.35,
                    child: FittedBox(child: Text('Đăng ký'))),
                onPressed: (!_canSignUp)
                    ? null
                    : () async {
                        await _signUp();
                      },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                  primary: const Color.fromRGBO(66, 183, 42, 1),
                  onPrimary: Colors.white,
                  shadowColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ));
  }
}
