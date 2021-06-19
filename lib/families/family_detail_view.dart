import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../bank/bank_list_view.dart';
import '../bank/spend_bank_button.dart';
import '../chores/add_chore_button.dart';
import '../chores/chore_view.dart';
import '../dependency_injection_container.dart';
import '../extensions/family_extension.dart';
import '../extensions/string_extension.dart';
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
  final sharedPreferences = getIt.get<SharedPreferences>();

  @override
  _FamilyDetailViewState createState() => _FamilyDetailViewState();
}

class _FamilyDetailViewState extends State<FamilyDetailView> with SingleTickerProviderStateMixin {
  var _selectedIndex = 0;
  final scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  List<WidgetForIdBuilder> _bottomNavViewsActionButtons() {
    return [
      (id) => AddFamilyMemberButton(
            familyId: id,
            sharedPreferences: widget.sharedPreferences,
          ),
      (id) => AddChoreButton(familyId: id),
      (id) => SpendBankButton(
            familyId: id,
            sharedPreferences: widget.sharedPreferences,
          )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as FamilyDetailViewArguments;
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerScroll) {
          return [
            _buildSliverOverlapAbsorber(
              context,
              MultiSliver(
                children: [
                  _buildSliverAppBar(context, arguments),
                  if (_selectedIndex == 1) _buildSliverPersistentHeaderForTabBar(context),
                ],
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (nestedScrollViewContext) {
              return _getBottomNavView(arguments.family.id ?? '');
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _bottomNavViewsActionButtons().elementAt(_selectedIndex).call(
            arguments.family.id ?? '',
          ),
    );
  }

  Widget _getBottomNavView(String id) {
    if (_selectedIndex == 0) {
      return FamilyMemberListView(
        familyId: id,
      );
    } else if (_selectedIndex == 1) {
      return ChoreView(
        familyId: id,
        tabController: _tabController,
      );
    } else if (_selectedIndex == 2) {
      return BankListView(
        familyId: id,
      );
    } else {
      return SizedBox();
    }
  }

  SliverOverlapAbsorber _buildSliverOverlapAbsorber(
    BuildContext context,
    Widget sliver,
  ) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: sliver,
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, FamilyDetailViewArguments arguments) {
    return SliverAppBar(
      elevation: _selectedIndex == 1 ? 0 : 4,
      expandedHeight: 200,
      pinned: true,
      leading: SizedBox(),
      flexibleSpace: _MyAppSpace(
        imagePath: arguments.imagePath,
        family: arguments.family,
      ),
    );
  }

  Widget _buildSliverPersistentHeaderForTabBar(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        child: _buildTabBar(context),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: colors(context).secondary,
      tabs: [
        _buildTab('AVAILABLE'),
        _buildTab('ACCEPTED'),
        _buildTab('COMPLETED'),
        _buildTab('CREATED'),
      ],
    );
  }

  Tab _buildTab(String label) {
    return Tab(
      child: Text(
        label,
        style: ChoresAppText.subtitle4Style.copyWith(
          color: colors(context).textOnPrimary,
        ),
      ),
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
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(opacity / 4),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getImage(Family family, String imagePath) {
    return Hero(
      tag: family.heroTag(),
      child: Image.network(
        imagePath,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, chunk) {
          if (chunk == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stack) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  bottom: 16,
                ),
                child: Image.asset(
                  'assets/images/chores_app.png',
                  fit: BoxFit.contain,
                  height: 120,
                  width: 120,
                  color: colors(context).chromeDark,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getTitle(BuildContext context, Family family, EdgeInsets padding, double fontSize) {
    return Padding(
      padding: padding,
      child: Hero(
        tag: '${family.id}${family.name}${family.image}',
        child: Material(
          type: MaterialType.transparency,
          child: Text(
            family.name?.capitalize() ?? '',
            textAlign: TextAlign.center,
            style: ChoresAppText.subtitle4Style.copyWith(fontSize: fontSize, color: colors(context).textOnPrimary),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final PreferredSizeWidget child;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: colors(context).primary,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
