import 'dart:typed_data';

import 'package:aip/config/themes.dart';
import 'package:ap_common/config/ap_constants.dart';
import 'package:ap_common/models/user_info.dart';
import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:flutter/material.dart';

class NthuApDrawer extends StatefulWidget {
  const NthuApDrawer({
    Key? key,
    required this.onTapHeader,
    required this.widgets,
    this.userInfo,
    this.imageAsset,
    this.imageHeroTag = ApConstants.tagStudentPicture,
    this.displayPicture = false,
  }) : super(key: key);

  final UserInfo? userInfo;
  final Function() onTapHeader;
  final String? imageAsset;
  final List<Widget> widgets;
  final String imageHeroTag;
  final bool displayPicture;

  @override
  NthuApDrawerState createState() => NthuApDrawerState();
}

class NthuApDrawerState extends State<NthuApDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: widget.onTapHeader,
              child: Stack(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    margin: EdgeInsets.zero,
                    currentAccountPicture:
                    widget.userInfo?.pictureBytes != null &&
                        widget.displayPicture
                        ? Hero(
                      tag: widget.imageHeroTag,
                      child: Container(
                        width: 72.0,
                        height: 72.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: MemoryImage(
                              widget.userInfo?.pictureBytes ??
                                  Uint8List(0),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container(
                      width: 72.0,
                      height: 72.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        ApIcon.accountCircle,
                        color: Colors.white,
                        size: 72.0,
                      ),
                    ),
                    accountName: Text(
                      widget.userInfo == null
                          ? ApLocalizations.of(context).notLogin
                          : (widget.userInfo?.name ?? ''),
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      widget.userInfo?.id ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: NthuApTheme.of(context).purple,
                      image: DecorationImage(
                        image: AssetImage(NthuApTheme.of(context).drawerBackground),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  if (widget.imageAsset != null)
                    Positioned(
                      bottom: 20.0,
                      right: 20.0,
                      child: Opacity(
                        opacity: ApTheme.of(context).drawerIconOpacity,
                        child: Image.asset(
                          widget.imageAsset!,
                          width: 90.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ...widget.widgets,
          ],
        ),
      ),
    );
  }
}