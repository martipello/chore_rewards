import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/chore.dart';
import '../repositories/image_repository.dart';
import '../shared_widgets/rounded_button.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../view_models/chore/chore_view_model.dart';
import 'accept_chore_dialog.dart';
import 'chore_detail_view.dart';

class ChoreTile extends StatefulWidget {
  ChoreTile({required this.chore, required this.familyId,});

  final Chore chore;
  final String familyId;

  @override
  _ChoreTileState createState() => _ChoreTileState();
}

class _ChoreTileState extends State<ChoreTile> {
  final _imageRepository = getIt.get<ImageRepository>();
  final _choreViewModel = getIt.get<ChoreViewModel>();

  @override
  void dispose() {
    _choreViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _imageRepository.getImageUrlForImagePath(widget.chore.image ?? ''),
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
                  _navigateToChoreDetailView(context, widget.chore, snapshot.data ?? '');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (snapshot.hasData)
                            Hero(
                              tag: '${widget.chore.id}${widget.chore.image}',
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
                                      errorBuilder: (context, object, stacktrace) {
                                        return Image.asset(
                                          'assets/images/chores_app.png',
                                          fit: BoxFit.cover,
                                          height: 80,
                                          width: 120,
                                        );
                                      },
                                    ),
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
                                    widget.chore.title?.capitalize() ?? 'No title',
                                    style: ChoresAppText.subtitle2Style.copyWith(height: 1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    widget.chore.description?.capitalize() ?? 'No description',
                                    style: ChoresAppText.body4Style.copyWith(height: 1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0, top: 16),
                                child: Row(
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
                                      '${widget.chore.reward?.toString() ?? '0'}',
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
                    SizedBox(
                      height: 8,
                    ),
                    _buildButtonBar(),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildAcceptButton(),
        SizedBox(
          width: 12,
        ),
      ],
    );
  }

  Widget _buildAcceptButton() {
    return StreamBuilder<ApiResponse>(
      stream: _choreViewModel.acceptChoreResult,
      builder: (context, snapshot) {
        return RoundedButton(
            label: 'Accept',
            isLoading: snapshot.data?.status == Status.LOADING,
            onPressed: _showAcceptChoreDialog,
          );
      }
    );
  }

  void _showAcceptChoreDialog() {
    AcceptChoreDialog.show(context, widget.chore, widget.familyId);
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
