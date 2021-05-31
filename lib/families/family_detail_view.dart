import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../bank/bank_list_view.dart';
import '../chores/add_chore_button.dart';
import '../chores/chore_list_view.dart';
import '../family_member/add_family_member_button.dart';
import '../family_member/family_member_list_view.dart';
import '../models/family.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

typedef WidgetForIdBuilder = Widget Function(String id);

class FamilyDetailViewArguments {
  FamilyDetailViewArguments({
    required this.family,
    required this.imagePath,
  });

  final Family family;
  final String imagePath;
}

class FamilyDetailView extends StatefulWidget {
  static const routeName = '/families/detail';

  @override
  _FamilyDetailViewState createState() => _FamilyDetailViewState();
}

class _FamilyDetailViewState extends State<FamilyDetailView> {
  var _selectedIndex = 0;
  final scrollController = ScrollController();

  final _bottomNavViews = <WidgetForIdBuilder>[
    (id) => FamilyMemberListView(
          familyId: id,
        ),
    (id) => ChoreListView(
          familyId: id,
        ),
    (id) => BankListView(),
  ];

  final _bottomNavViewsActionButtons = <WidgetForIdBuilder>[
    (id) => AddFamilyMemberButton(familyId: id),
    (id) => AddChoreButton(familyId: id),
    (id) => SizedBox(),
  ];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as FamilyDetailViewArguments;
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerScroll) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                flexibleSpace: _MyAppSpace(
                  imagePath: arguments.imagePath,
                  family: arguments.family,
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (nestedScrollViewContext) {
              return CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(nestedScrollViewContext),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(8),
                    sliver: _bottomNavViews.elementAt(_selectedIndex).call(arguments.family.id ?? ''),
                  )
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _bottomNavViewsActionButtons.elementAt(_selectedIndex).call(arguments.family.id ?? ''),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: colors(context).white),
      showUnselectedLabels: true,
      iconSize: 24,
      unselectedFontSize: ChoresAppText.body3Style.fontSize ?? 14,
      selectedFontSize: ChoresAppText.body3Style.fontSize ?? 14,
      elevation: 12,
      backgroundColor: colors(context).primary,
      items: _bottomNavigationBarItems(),
      currentIndex: _selectedIndex,
      selectedItemColor: colors(context).white,
      unselectedItemColor: colors(context).textOnForeground,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.family_restroom),
        label: 'Members',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.cleaning_services),
        label: 'Chores',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: 'Bank',
      ),
    ];
  }
}

class _MyAppSpace extends StatelessWidget {
  const _MyAppSpace({
    Key? key,
    required this.imagePath,
    required this.family,
  }) : super(key: key);

  final String imagePath;
  final Family family;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final maxExtent = settings?.maxExtent ?? 0;
        final minExtent = settings?.minExtent ?? 0;
        final currentExtent = settings?.currentExtent ?? 0;

        final deltaExtent = maxExtent - minExtent;
        final t = (1.0 - (currentExtent - minExtent) / deltaExtent).clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - 250 / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Opacity(opacity: opacity, child: getImage(family, imagePath)),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(opacity / 4),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Center(
                      child: getTitle(
                          context,
                          family,
                          EdgeInsets.only(
                            left: 52 + 16 * opacity,
                          ),
                          (20 * (opacity + 1)).clamp(20, 28)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getImage(Family family, String imagePath) {
    return Hero(
      tag: '${family.id}${family.image}',
      child: Image.network(
        imagePath,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getTitle(BuildContext context, Family family, EdgeInsets padding, double fontSize) {
    return Padding(
      padding: padding,
      child: Hero(
        tag: '${family.id}${family.name}',
        child: Material(
          type: MaterialType.transparency,
          child: Text(
            family.name ?? '',
            textAlign: TextAlign.center,
            style: ChoresAppText.subtitle4Style.copyWith(fontSize: fontSize, color: colors(context).textOnPrimary),
          ),
        ),
      ),
    );
  }
}
