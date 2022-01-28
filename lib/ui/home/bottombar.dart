import 'dart:ui';

import 'package:flutter/material.dart';

import '../../blocs/home_bloc.dart';
import '../../foundation/constants.dart';
import '../../foundation/extensions/meta_icons_icons.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Stack(children: [
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 15),
              child: Container(
                color: Colors.white.withOpacity(0.85),
                height: 56,
              ),
            ),
          ),
          StreamBuilder<int>(
              stream: homeBloc.page,
              builder: (context, snapshot) {
                final currentIndex = snapshot.data ?? 0;
                return BottomNavigationBar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.04),
                  elevation: 0,
                  selectedFontSize: 12,
                  iconSize: 32,
                  unselectedItemColor: unselectedWidgetColor,
                  currentIndex: currentIndex,
                  onTap: (index) => homeBloc.moveToPage(index),
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(
                          MetaIcons.speech_bubble,
                        ),
                        label: 'Chat',
                        tooltip: ''),
                    BottomNavigationBarItem(
                        icon: Icon(
                          MetaIcons.people,
                        ),
                        label: 'People',
                        tooltip: ''),
                  ],
                );
              }),
        ]));
  }
}
