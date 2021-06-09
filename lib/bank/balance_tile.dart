import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/family_member.dart';
import '../repositories/image_repository.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';

class BalanceTile extends StatelessWidget {
  BalanceTile({
    required this.familyMember,
  });

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(90),
                            bottomRight: Radius.circular(90),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: Container(
                              color: colors(context).primary,
                              child: Image.network(
                                snapshot.data ?? '',
                                fit: BoxFit.cover,
                                height: 80,
                                width: 120,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return SizedBox(
                                    height: 80,
                                    width: 120,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stacktrace) {
                                  return Image.asset(
                                    'assets/images/familyMembers_app.png',
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 120,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                familyMember.name?.capitalize() ?? 'No title',
                                style: ChoresAppText.subtitle2Style.copyWith(height: 1),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Balance',
                                    style: ChoresAppText.subtitle3Style.copyWith(height: 1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 3.0),
                                        child: Icon(
                                          Icons.star,
                                          size: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '${familyMember.piggyBank?.balance?.toString() ?? '0'}',
                                        style: ChoresAppText.subtitle1Style.copyWith(height: 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

}

