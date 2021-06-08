import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/family.dart';
import '../models/family_member.dart';
import '../repositories/image_repository.dart';
import '../theme/chores_app_text.dart';
import '../view_models/family/family_member_view_model.dart';
import 'family_detail_view.dart';

class FamilyTile extends StatelessWidget {
  FamilyTile({required this.family});

  final Family family;

  final _imageRepository = getIt.get<ImageRepository>();
  final _familyMemberViewModel = getIt.get<FamilyMemberViewModel>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _imageRepository.getImageUrlForImagePath(family.image ?? ''),
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
                  final imagePath = await _imageRepository.getImageUrlForImagePath(family.image ?? '');
                  _navigateToFamilyDetailView(context, family, imagePath);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: '${family.id}${family.image}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(90),
                          bottomRight: Radius.circular(90),
                        ),
                        child: snapshot.data?.isNotEmpty == true ? Material(
                          type: MaterialType.transparency,
                          child: Image.network(
                            snapshot.data ?? '',
                            fit: BoxFit.cover,
                            height: 80,
                            width: 120,
                          ),
                        ) : SizedBox(
                          height: 80,
                          width: 120,
                          child: Center(
                            child: CircularProgressIndicator(),
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
                          Hero(
                            tag: '${family.id}${family.name}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                family.name?.capitalize() ?? 'No name',
                                style: ChoresAppText.subtitle2Style.copyWith(height: 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          StreamBuilder<QuerySnapshot<FamilyMember>>(
                            stream: _familyMemberViewModel.getFamilyMemberList(family.id ?? ''),
                            builder: (context, snapshot) {
                              return Text(
                                'Members : ${snapshot.data?.docs.length ?? 0}',
                                style: ChoresAppText.body3Style,
                              );
                            }
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

  void _navigateToFamilyDetailView(BuildContext context, Family family, String imagePath) {
    Navigator.of(context).pushNamed(
      FamilyDetailView.routeName,
      arguments: FamilyDetailViewArguments(
        family: family,
        imagePath: imagePath,
      ),
    );
  }
}
