import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../api/utils/api_response.dart';
import '../dependency_injection_container.dart';
import '../extensions/string_extension.dart';
import '../models/allocation.dart';
import '../models/chore.dart';
import '../repositories/image_repository.dart';
import '../shared_widgets/rounded_button.dart';
import '../theme/base_theme.dart';
import '../theme/chores_app_text.dart';
import '../view_models/chore/chore_view_model.dart';
import 'accept_chore_dialog.dart';
import 'cancel_chore_dialog.dart';
import 'complete_chore_dialog.dart';

class ChoreDetailViewArguments {
  ChoreDetailViewArguments({
    required this.familyId,
    required this.chore,
    required this.imagePath,
  });

  final Chore chore;
  final String familyId;
  final String imagePath;
}

class ChoreDetailView extends StatefulWidget {
  static const routeName = '/families/chores/details';

  @override
  _ChoreDetailViewState createState() => _ChoreDetailViewState();
}

class _ChoreDetailViewState extends State<ChoreDetailView> {
  final _imageRepository = getIt.get<ImageRepository>();

  final _choreViewModel = getIt.get<ChoreViewModel>();

  @override
  void dispose() {
    _choreViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as ChoreDetailViewArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments.chore.title?.capitalize() ?? 'Family Member'),
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
                _buildProfileHeader(arguments.chore),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: _buildChoreInformationTable(context, arguments.chore),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildButtonBar(arguments.chore, arguments.familyId),
      ),
    );
  }

  Widget _buildButtonBar(Chore chore, String familyId) {
    return Row(
      children: [
        if (chore.allocation == Allocation.available)
          Expanded(
            child: _buildAcceptButton(chore, familyId),
          ),
        if (chore.allocation == Allocation.allocated)
          Expanded(
            child: _buildCancelButton(chore, familyId),
          ),
        if (chore.allocation == Allocation.allocated)
          SizedBox(
            width: 16,
          ),
        if (chore.allocation == Allocation.allocated)
          Expanded(
            child: _buildCompleteButton(chore, familyId),
          ),
        SizedBox(
          width: 12,
        ),
      ],
    );
  }

  Widget _buildAcceptButton(Chore chore, String familyId) {
    return StreamBuilder<ApiResponse>(
        stream: _choreViewModel.acceptChoreResult,
        builder: (context, snapshot) {
          return RoundedButton(
            label: 'ACCEPT',
            isLoading: snapshot.data?.status == Status.LOADING,
            onPressed: () {
              _showAcceptChoreDialog(chore, familyId);
            },
          );
        });
  }

  Widget _buildCancelButton(Chore chore, String familyId) {
    return StreamBuilder<ApiResponse>(
        stream: _choreViewModel.acceptChoreResult,
        builder: (context, snapshot) {
          return RoundedButton(
            label: 'Cancel',
            fillColor: colors(context).error,
            isLoading: snapshot.data?.status == Status.LOADING,
            onPressed: () {
              _showCancelChoreDialog(chore, familyId);
            },
          );
        });
  }

  Widget _buildCompleteButton(Chore chore, String familyId) {
    return StreamBuilder<ApiResponse>(
        stream: _choreViewModel.acceptChoreResult,
        builder: (context, snapshot) {
          return RoundedButton(
            label: 'Complete',
            isLoading: snapshot.data?.status == Status.LOADING,
            onPressed: () {
              _showCompletedChoreDialog(chore, familyId);
            },
          );
        });
  }

  void _showAcceptChoreDialog(Chore chore, String familyId) {
    AcceptChoreDialog.show(context, chore, familyId);
  }

  void _showCancelChoreDialog(Chore chore, String familyId) {
    CancelChoreDialog.show(context, chore, familyId);
  }

  void _showCompletedChoreDialog(Chore chore, String familyId) {
    CompleteChoreDialog.show(context, chore, familyId);
  }

  Widget _buildProfileHeader(Chore chore) {
    return FutureBuilder<String>(
        future: _imageRepository.getImageUrlForImagePath(chore.image ?? ''),
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Hero(
                  tag: '${chore.id}${chore.image}',
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
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          );
        });
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

  Widget _buildChoreInformationTable(BuildContext context, Chore chore) {
    final title = chore.title?.capitalize() ?? '';
    final description = chore.description?.capitalize() ?? '';
    final addedDate = _buildDateTime(chore.addedDate);
    final completedDate = _buildDateTime(chore.completedDate);
    final allocation = chore.allocation?.name ?? '';
    final createdBy = chore.createdBy?.name ?? '';
    final allocatedTo = chore.allocatedToFamilyMember?.name ?? '';
    final expiry = _buildDateTime(chore.expiryDate);
    final reward = chore.reward?.toString() ?? '0';
    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: FlexColumnWidth(1),
      },
      children: [
        if (title.isNotEmpty)
          _buildTableRow(
            context,
            title,
            'Title :',
            Icons.title,
          ),
        if (description.isNotEmpty)
          _buildTableRow(
            context,
            description,
            'Description :',
            Icons.description_outlined,
          ),
        if (allocation.isNotEmpty)
          _buildTableRow(
            context,
            allocation.capitalize(),
            'Allocation :',
            Icons.pending,
          ),
        if (allocatedTo.isNotEmpty)
          _buildTableRow(
            context,
            allocatedTo,
            'Allocated to :',
            Icons.person,
          ),
        if (createdBy.isNotEmpty)
          _buildTableRow(
            context,
            createdBy,
            'Created by :',
            Icons.person,
          ),
        if (reward.isNotEmpty)
          _buildTableRow(
            context,
            '$reward',
            'Reward :',
            Icons.star,
          ),
        if (addedDate.isNotEmpty)
          _buildTableRow(
            context,
            addedDate,
            'Added :',
            Icons.today,
          ),
        if (expiry.isNotEmpty)
          _buildTableRow(
            context,
            expiry,
            'Expires :',
            Icons.today,
          ),
        if (completedDate.isNotEmpty)
          _buildTableRow(
            context,
            completedDate,
            'Completed :',
            Icons.today,
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
          padding: const EdgeInsets.only(top: 21.0, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: colors(context).textOnForeground,
                size: 20,
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
                  style: ChoresAppText.body1Style,
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
                        ? ChoresAppText.body1Style.copyWith(
                            color: colors(context).link,
                          )
                        : ChoresAppText.body1Style,
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
