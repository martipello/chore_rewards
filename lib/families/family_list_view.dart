import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/family.dart';
import '../models/user.dart';
import '../shared_widgets/circle_image.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../view_models/family/family_view_model.dart';
import '../view_models/user_view_model.dart';
import 'add_family_view.dart';
import 'family_tile.dart';

class FamilyListView extends StatefulWidget {
  static const routeName = '/families';

  @override
  _FamilyListViewState createState() => _FamilyListViewState();
}

class _FamilyListViewState extends State<FamilyListView> {
  final _familyViewModel = getIt.get<FamilyViewModel>();
  final _userViewModel = getIt.get<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 260,
            width: double.infinity,
            child: _buildWave(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileHeaderState(),
              Expanded(
                child: _buildFamilyList(),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildAddFamilyButton(context),
    );
  }

  Widget _buildProfileHeaderState() {
    return StreamBuilder<DocumentSnapshot<User>>(
        stream: _userViewModel.userDocumentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildProfileHeader(snapshot.data?.data());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildProfileHeader(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 90,
        ),
        Center(
          child: CircleImage(
            imagePath: user?.image ?? '',
            height: 150,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Center(
          child: Text(
            'Welcome ${user?.name?.capitalize()}',
            style: ChoresAppText.h5Style.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            '${user?.userName}',
            style: ChoresAppText.body1Style,
          ),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget _buildAddFamilyButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        _navigateToAddFamilyView(context);
      },
      tooltip: 'Add family',
      child: Icon(Icons.add),
    );
  }

  Widget _buildFamilyList() {
    return StreamBuilder<List<QueryDocumentSnapshot<Family>?>>(
      stream: _familyViewModel.getFamilies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final familyList = snapshot.data!.where((e) => e?.data() != null).toList();
          if (familyList.isNotEmpty) {
            return ListView.separated(
              itemCount: familyList.length,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                return FamilyTile(family: familyList[index]!.data());
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 4,
                );
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                left: 48.0,
                right: 48,
                top: 96,
              ),
              child: Text(
                'No Families, please create one to get started.',
                style: ChoresAppText.subtitle2Style,
                textAlign: TextAlign.center,
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _navigateToAddFamilyView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddFamilyView();
        },
      ),
    );
  }

  Widget _buildWave() {
    return WaveWidget(
      config: CustomConfig(
        colors: [
          Colors.white70,
          Colors.white54,
          Colors.white30,
          Colors.white24,
        ],
        durations: [32000, 21000, 18000, 5000],
        heightPercentages: [0.52, 0.53, 0.55, 0.58],
        // blur: _blurs[3],
      ),
      backgroundColor: colors(context).primary,
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 0,
    );
  }
}
