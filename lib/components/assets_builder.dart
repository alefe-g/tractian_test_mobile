import 'package:flutter/material.dart';
import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';
import 'package:tractian_test_mobile/styles/app_icons.dart';

class AssetsBuilder extends StatefulWidget {
  final List<LocationModel> locations;

  const AssetsBuilder({
    super.key,
    required this.locations,
  });

  @override
  State<AssetsBuilder> createState() => _AssetsBuilderState();
}

class _AssetsBuilderState extends State<AssetsBuilder> {
  final Map<String?, bool> locationsExpanded = {};
  final Map<String?, bool> assetsExpanded = {};

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: widget.locations.map(
        (location) {
          return _buildLocationMenu(location, true);
        },
      ).toList(),
    );
  }

  Widget _buildLocationMenu(LocationModel location, [bool first = false]) {
    var isExpanded = locationsExpanded[location.id] ?? false;

    if (location.id == null) {
      isExpanded = false;
    }

    final containsChildren =
        location.children != null && location.children!.isNotEmpty;
    final containsAssets =
        location.assets != null && location.assets!.isNotEmpty;
    final hasChildren = containsAssets || containsChildren;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() {
              locationsExpanded[location.id] = !isExpanded;
            }),
            child: Row(
              children: [
                if (!isExpanded && hasChildren) const Icon(Icons.arrow_right),
                if (isExpanded && hasChildren)
                  const Icon(Icons.arrow_drop_down),
                if (!hasChildren) const SizedBox(width: 24),
                AppIcons.goLocation,
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        location.name ?? '',
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded && hasChildren)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                )),
              ),
              margin: const EdgeInsets.only(left: 10.0),
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: [
                  ...location.children?.map((child) {
                        return _buildLocationMenu(child);
                      }).toList() ??
                      [],
                  ...location.assets?.map((asset) {
                        return _buildAssetMenu(asset);
                      }).toList() ??
                      [],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssetMenu(AssetModel asset) {
    var isExpanded = assetsExpanded[asset.id] ?? false;

    if (asset.id == null) {
      isExpanded = false;
    }

    final hasChildren = asset.children != null && asset.children!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() {
            assetsExpanded[asset.id] = !isExpanded;
          }),
          child: Row(
            children: [
              if (!isExpanded && hasChildren) const Icon(Icons.arrow_right),
              if (isExpanded && hasChildren) const Icon(Icons.arrow_drop_down),
              if (!hasChildren) const SizedBox(width: 24),
              hasChildren ? AppIcons.ioCubeOutline : AppIcons.codepen,
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  children: [
                    Text(
                      asset.name ?? '',
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              if (!hasChildren) const SizedBox(width: 4),
              if (!hasChildren && asset.status == 'operating') AppIcons.greenBold,
              if (!hasChildren && asset.status == 'alert') AppIcons.ellipse,
            ],
          ),
        ),
        if (isExpanded && hasChildren)
          Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            margin: const EdgeInsets.only(left: 10.0),
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              children: [
                ...asset.children?.map((child) {
                      return _buildAssetMenu(child);
                    }).toList() ??
                    [],
              ],
            ),
          ),
      ],
    );
  }
}
