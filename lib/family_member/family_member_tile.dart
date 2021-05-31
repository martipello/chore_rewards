import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/family_member.dart';
import '../repositories/image_repository.dart';
import '../theme/chores_app_text.dart';
import 'family_member_detail_view.dart';

class FamilyMemberTile extends StatelessWidget {
  FamilyMemberTile({required this.familyMember});

  final FamilyMember familyMember;

  final _imageRepository = getIt.get<ImageRepository>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _imageRepository.getImageUrlForImagePath(familyMember.image ?? ''),
        builder: (context, snapshot) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () async {
                  final imagePath = await _imageRepository.getImageUrlForImagePath(familyMember.image ?? '');
                  _navigateToFamilyMemberDetailView(context, familyMember, imagePath);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: '${familyMember.id}${familyMember.image}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(90),
                          bottomRight: Radius.circular(90),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Image.network(
                            snapshot.data ?? '',
                            height: 80,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            familyMember.name?.capitalize() ?? 'No name',
                            style: ChoresAppText.subtitle2Style.copyWith(height: 1),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Family member type : ${familyMember.familyMemberType}',
                            style: ChoresAppText.body3Style,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _navigateToFamilyMemberDetailView(BuildContext context, FamilyMember familyMember, String imagePath) {
    Navigator.of(context).pushNamed(
      FamilyMemberDetailView.routeName,
      arguments: FamilyMemberDetailViewArguments(
        familyMember: familyMember,
        imagePath: imagePath,
      ),
    );
  }
}
