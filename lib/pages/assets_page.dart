import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_test_mobile/bloc/asset/asset_bloc.dart';
import 'package:tractian_test_mobile/bloc/asset/asset_event.dart';
import 'package:tractian_test_mobile/bloc/asset/asset_state.dart';
import 'package:tractian_test_mobile/components/assets_builder.dart';
import 'package:tractian_test_mobile/styles/app_colors.dart';
import 'package:tractian_test_mobile/styles/app_icons.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  String? companyId;
  AssetBloc? assetBloc;
  String? searchQuery;
  String? sensorStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    companyId = ModalRoute.of(context)?.settings.arguments as String?;
    assetBloc = Provider.of<AssetBloc>(context);
    assetBloc?.addEvent(FetchAssetsEvent(companyId ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _buildAssetsContent(),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      backgroundColor: const Color(0xFF17192D),
      title: const Text(
        'Assets',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAssetsContent() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.input,
          ),
          child: TextField(
            onChanged: (value) {
              if (value.isEmpty) {
                searchQuery = null;
              } else {
                searchQuery = value;
              }

              assetBloc?.addEvent(FetchAssetsEvent(
                companyId ?? '',
                searchQuery: searchQuery,
                status: sensorStatus,
              ));
            },
            decoration: const InputDecoration(
              icon: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Icon(Icons.search),
              ),
              border: InputBorder.none,
              hintText: 'Buscar Ativo ou Local',
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _toggleButtonsWidget(),
        Expanded(
          child: StreamBuilder(
            stream: assetBloc!.streamState,
            builder: _buildStreamData,
          ),
        ),
      ],
    );
  }

  Widget _toggleButtonsWidget() {
    return Row(
      children: [
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => setState(() {
            if (sensorStatus == 'operating') {
              sensorStatus = null;
            } else {
              sensorStatus = 'operating';
            }

            assetBloc?.addEvent(FetchAssetsEvent(
              companyId ?? '',
              searchQuery: searchQuery,
              status: sensorStatus,
            ));
          }),
          label: Text(
            'Sensor de Energia',
            style: sensorStatus == 'operating'
                ? const TextStyle(color: Colors.white)
                : null,
          ),
          icon:
              sensorStatus == 'operating' ? AppIcons.whiteBold : AppIcons.bold,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              sensorStatus == 'operating' ? AppColors.selectedButton : null,
            ),
            shape: WidgetStatePropertyAll(
              BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: BorderSide(
                  width: 1,
                  color: sensorStatus == 'operating'
                      ? AppColors.selectedButton
                      : AppColors.borderButton,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => setState(() {
            if (sensorStatus == 'alert') {
              sensorStatus = null;
            } else {
              sensorStatus = 'alert';
            }

            assetBloc?.addEvent(FetchAssetsEvent(
              companyId ?? '',
              searchQuery: searchQuery,
              status: sensorStatus,
            ));
          }),
          label: Text(
            'Crítico',
            style: sensorStatus == 'alert'
                ? const TextStyle(color: Colors.white)
                : null,
          ),
          icon: sensorStatus == 'alert' ? AppIcons.whiteInfo : AppIcons.info,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              sensorStatus == 'alert' ? AppColors.selectedButton : null,
            ),
            shape: WidgetStatePropertyAll(
              BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: BorderSide(
                  width: 1,
                  color: sensorStatus == 'alert'
                      ? AppColors.selectedButton
                      : AppColors.borderButton,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamData(
      BuildContext context, AsyncSnapshot<AssetState> snapshot) {
    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(
        child: Text('Sem dados'),
      );
    }

    final assetState = snapshot.data;

    if (assetState is AssetLoadedState) {
      return AssetsBuilder(locations: assetState.locations);
    }

    if (assetState is AssetLoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (assetState is AssetErrorState) {
      return Center(
        child: Text(assetState.message),
      );
    }

    return const Center(child: Text('Estado da aplicação inválido'));
  }
}
