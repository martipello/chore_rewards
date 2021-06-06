import 'package:chore_rewards/theme/base_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/chore.dart';
import '../repositories/image_repository.dart';
import '../theme/chores_app_text.dart';
import 'chore_detail_view.dart';

class ChoreTile extends StatelessWidget {
  ChoreTile({required this.chore});

  final Chore chore;

  final _imageRepository = getIt.get<ImageRepository>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _imageRepository.getImageUrlForImagePath(chore.image ?? ''),
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
                  _navigateToChoreDetailView(context, chore, snapshot.data ?? '');
                },
                child: SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (snapshot.hasData)
                      Hero(
                        tag: '${chore.id}${chore.image}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(90),
                            bottomRight: Radius.circular(90),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: Container(
                              color: colors(context).primary,
                              child: Image.network(
                                snapshot.data ?? 'image.png',
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
                                errorBuilder: (context, object, stacktrace){
                                  return Image.asset('assets/images/chores_app.png',
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 120,);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                chore.title?.capitalize() ?? 'No title',
                                style: ChoresAppText.subtitle2Style.copyWith(height: 1),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                chore.description?.capitalize() ?? 'No description',
                                style: ChoresAppText.body4Style.copyWith(height: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Icon(Icons.star, size: 18,),
                                ),
                                SizedBox(width: 4,),
                                Text(
                                  '${chore.reward?.toString() ?? '0'}',
                                  style: ChoresAppText.subtitle1Style.copyWith(height: 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _navigateToChoreDetailView(BuildContext context, Chore chore, String imagePath) {
    Navigator.of(context).pushNamed(
      ChoreDetailView.routeName,
      arguments: ChoreDetailViewArguments(
        chore: chore,
        imagePath: imagePath,
      ),
    );
  }
}
