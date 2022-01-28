// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get language {
    return Intl.message(
      'English',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Email không hợp lệ.`
  String get invalid_email {
    return Intl.message(
      'Email không hợp lệ.',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu quá yếu.`
  String get weak_password {
    return Intl.message(
      'Mật khẩu quá yếu.',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `Lỗi`
  String get error {
    return Intl.message(
      'Lỗi',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Lỗi không xác định!`
  String get unknown_error {
    return Intl.message(
      'Lỗi không xác định!',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Sai mật khẩu.`
  String get wrong_password {
    return Intl.message(
      'Sai mật khẩu.',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Tài khoản không tồn tại.`
  String get user_not_found {
    return Intl.message(
      'Tài khoản không tồn tại.',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Email đã được sử dụng.`
  String get email_already_in_use {
    return Intl.message(
      'Email đã được sử dụng.',
      name: 'email_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Đăng nhập bằng email\nchưa thể dùng số điện thoại`
  String get login_subtitle {
    return Intl.message(
      'Đăng nhập bằng email\nchưa thể dùng số điện thoại',
      name: 'login_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Địa chỉ email`
  String get auth_field_email {
    return Intl.message(
      'Địa chỉ email',
      name: 'auth_field_email',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu`
  String get auth_field_password {
    return Intl.message(
      'Mật khẩu',
      name: 'auth_field_password',
      desc: '',
      args: [],
    );
  }

  /// `Quên mật khẩu?`
  String get auth_forgot {
    return Intl.message(
      'Quên mật khẩu?',
      name: 'auth_forgot',
      desc: '',
      args: [],
    );
  }

  /// `Lưu thông tin đăng nhập`
  String get save_login {
    return Intl.message(
      'Lưu thông tin đăng nhập',
      name: 'save_login',
      desc: '',
      args: [],
    );
  }

  /// `Đăng nhập`
  String get login {
    return Intl.message(
      'Đăng nhập',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Tạo tài khoản mới`
  String get new_account {
    return Intl.message(
      'Tạo tài khoản mới',
      name: 'new_account',
      desc: '',
      args: [],
    );
  }

  /// `Lỗi upload ảnh đại diện`
  String get error_upload_avatar {
    return Intl.message(
      'Lỗi upload ảnh đại diện',
      name: 'error_upload_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Đã có tài khoản`
  String get ask_signup {
    return Intl.message(
      'Đã có tài khoản',
      name: 'ask_signup',
      desc: '',
      args: [],
    );
  }

  /// `Chụp ảnh`
  String get source_camera {
    return Intl.message(
      'Chụp ảnh',
      name: 'source_camera',
      desc: '',
      args: [],
    );
  }

  /// `Thư viện`
  String get source_gallery {
    return Intl.message(
      'Thư viện',
      name: 'source_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Xem thêm`
  String get more {
    return Intl.message(
      'Xem thêm',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Lưu trữ`
  String get archive {
    return Intl.message(
      'Lưu trữ',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Đã gửi 1 ảnh.`
  String get brief_image {
    return Intl.message(
      'Đã gửi 1 ảnh.',
      name: 'brief_image',
      desc: '',
      args: [],
    );
  }

  /// `Đã gửi nút like.`
  String get brief_like {
    return Intl.message(
      'Đã gửi nút like.',
      name: 'brief_like',
      desc: '',
      args: [],
    );
  }

  /// `Đã gửi 1 đường dẫn.`
  String get brief_url {
    return Intl.message(
      'Đã gửi 1 đường dẫn.',
      name: 'brief_url',
      desc: '',
      args: [],
    );
  }

  /// `Đã gửi 1 ảnh động`
  String get brief_gif {
    return Intl.message(
      'Đã gửi 1 ảnh động',
      name: 'brief_gif',
      desc: '',
      args: [],
    );
  }

  /// `Đang hoạt động`
  String get is_online {
    return Intl.message(
      'Đang hoạt động',
      name: 'is_online',
      desc: '',
      args: [],
    );
  }

  /// `temp`
  String get temp {
    return Intl.message(
      'temp',
      name: 'temp',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
