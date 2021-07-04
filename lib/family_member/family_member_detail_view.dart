import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../dependency_injection_container.dart';
import '../extensions/family_member_extension.dart';
import '../extensions/string_extension.dart';
import '../models/family_member.dart';
import '../repositories/image_repository.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

class FamilyMemberDetailViewArguments {
  FamilyMemberDetailViewArguments({
    required this.familyMember,
    required this.imagePath,
  });

  final FamilyMember familyMember;
  final String imagePath;
}

class FamilyMemberDetailView extends StatelessWidget {
  static const routeName = '/families/family_member/details';
  final _imageRepository = getIt.get<ImageRepository>();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as FamilyMemberDetailViewArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments.familyMember.name?.capitalize() ?? 'Family Member'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: _buildWave(context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(arguments.familyMember),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: _buildFamilyMemberInformationTable(context, arguments.familyMember),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add family',
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildProfileHeader(FamilyMember familyMember) {
    return FutureBuilder<String>(
      future: _imageRepository.getImageUrlForImagePath(familyMember.image ?? ''),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Hero(
                tag: familyMember.heroTag(),
                child: Material(
                  type: MaterialType.transparency,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: Image.network(
                        snapshot.data ?? '',
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                        loadingBuilder: (context, child, chunk) {
                          if (chunk == null) {
                            return child;
                          }
                          return _buildLoadingImage();
                        },
                        errorBuilder: (context, object, stacktrace) {
                          return Icon(
                            Icons.person_outline_rounded,
                            size: 150,
                          );
                        },
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingImage() {
    return SizedBox(
      height: 150,
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildFamilyMemberInformationTable(BuildContext context, FamilyMember familyMember) {
    final dob = _buildDateTime(familyMember.dateOfBirth);
    final name = familyMember.name?.capitalize() ?? '';
    final userName = familyMember.userName?.capitalize() ?? '';
    final familyMemberType = familyMember.familyMemberType?.name ?? '';
    final familyMemberPiggyBankBalance = familyMember.piggyBank?.balance ?? '';
    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: FlexColumnWidth(1),
      },
      children: [
        if (name.isNotEmpty)
          _buildTableRow(
            context,
            name,
            'Name :',
            Icons.person,
          ),
        if (userName.isNotEmpty)
          _buildTableRow(
            context,
            userName,
            'User Name :',
            Icons.person,
          ),
        if (dob.isNotEmpty)
          _buildTableRow(
            context,
            dob,
            'Date of birth :',
            Icons.today,
          ),
        if (familyMemberType.isNotEmpty)
          _buildTableRow(
            context,
            familyMemberType,
            'Child/Parent :',
            Icons.family_restroom,
          ),
        if (familyMemberPiggyBankBalance.toString().isNotEmpty)
          _buildTableRow(
            context,
            familyMemberPiggyBankBalance.toString(),
            'Balance :',
            Icons.account_balance,
          ),
      ],
    );
  }

  TableRow _buildTableRow(
    BuildContext context,
    String label,
    String? iconLabel,
    IconData icon, {
    VoidCallback? onPressed,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: colors(context).textOnForeground,
                size: 18,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 8),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  iconLabel?.trim() ?? '',
                  style: ChoresAppText.body3Style,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onPressed,
                  child: Text(
                    label,
                    style: onPressed != null
                        ? ChoresAppText.body3Style.copyWith(
                            color: colors(context).link,
                          )
                        : ChoresAppText.body3Style,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return '';
  }

  Widget _buildWave(BuildContext context) {
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
