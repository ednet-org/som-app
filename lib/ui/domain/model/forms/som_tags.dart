import 'package:flutter/material.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../../domain/model/shared/som.dart';

// import 'package:flutter_tags/flutter_tags.dart';
// https://medium.com/nonstopio/flutter-tags-7410bd6a5835

class SomTags extends StatefulWidget {
  const SomTags({
    super.key,
    required this.tags,
    this.selectedTags,
    this.onAdd,
    this.onRemove,
  });
  final List<TagModel> tags;
  final List<TagModel>? selectedTags;
  final void Function(TagModel tag)? onAdd;
  final void Function(TagModel tag)? onRemove;

  @override
  State<SomTags> createState() => _SomTagsState();
}

class _SomTagsState extends State<SomTags> with SingleTickerProviderStateMixin {
  final List<TagModel> _tags = [];
  final List<TagModel> _suggestions = [];
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  String get _searchText => _searchTextEditingController.text.trim();

  void refreshState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _searchTextEditingController.addListener(() => refreshState(() {}));
    if (widget.selectedTags != null) {
      _tags.addAll(widget.selectedTags!);
    }
    _suggestions.addAll(widget.tags);
  }

  @override
  void didUpdateWidget(covariant SomTags oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tags != widget.tags) {
      _suggestions
        ..clear()
        ..addAll(widget.tags);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }

  List<TagModel> _filterSearchResultList() {
    if (_searchText.isEmpty) return _suggestions;

    final tempList = <TagModel>[];
    for (int index = 0; index < _suggestions.length; index++) {
      final tagModel = _suggestions[index];
      if (tagModel.title
          .toLowerCase()
          .trim()
          .contains(_searchText.toLowerCase())) {
        tempList.add(tagModel);
      }
    }

    return tempList;
  }

  void _addTags(TagModel tagModel) {
    if (!_tags.contains(tagModel)) {
      setState(() {
        _tags.add(tagModel);
      });
      widget.onAdd?.call(tagModel);
    }
  }

  void _removeTag(TagModel tagModel) {
    if (_tags.contains(tagModel)) {
      setState(() {
        _tags.remove(tagModel);
      });
      widget.onRemove?.call(tagModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _tagIcon();
  }

  Widget _tagIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _tags.isNotEmpty
            ? SomSvgIcon(
                SomAssets.iconOffers,
                size: 25.0,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )
            : Container(),
        _tagsWidget(),
      ],
    );
  }

  Widget _displayTagWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _filterSearchResultList().isNotEmpty
          ? _buildSuggestionWidget()
          : const Text('No suggestions, please start typing'),
    );
  }

  Widget _buildSuggestionWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_filterSearchResultList().length != _tags.length)
        const Text('Suggestions'),
      Wrap(
        alignment: WrapAlignment.start,
        children: _filterSearchResultList()
            .where((tagModel) => !_tags.contains(tagModel))
            .take(10)
            .map((tagModel) => tagChip(
                  tagModel: tagModel,
                  onTap: () => _addTags(tagModel),
                  action: 'Add',
                  showCloseIcon: false,
                ))
            .toList(),
      ),
      if (_searchText.isNotEmpty &&
          !_suggestions.any((tag) =>
              tag.title.toLowerCase() == _searchText.toLowerCase()))
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: OutlinedButton.icon(
            onPressed: () => _addTags(
              TagModel(id: _searchText, title: _searchText),
            ),
            icon: SomSvgIcon(
              SomAssets.iconChevronRight,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text('Add "$_searchText"'),
          ),
        ),
    ]);
  }

  Widget tagChip({
    required TagModel tagModel,
    required VoidCallback onTap,
    required String action,
    required bool showCloseIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          OutlinedButton(
              onPressed: onTap,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 15.0,
                    ),
                    child: Text(
                      tagModel.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              )),
          showCloseIcon
              ? const Positioned(
                  right: 8.0,
                  top: 16.0,
                  child: CircleAvatar(
                    radius: 10.0,
                    child: SomSvgIcon(
                      SomAssets.iconClose,
                      size: 14,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _buildSearchFieldWidget() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchTextEditingController,
            decoration: const InputDecoration(
              labelText: 'Filter categories',
              hintText: 'Branches like IT, Media, Pharma, Sport...',
            ),
            style: Theme.of(context).textTheme.titleMedium,
            textInputAction: TextInputAction.search,
          ),
        ),
        _searchText.isNotEmpty
            ? InkWell(
                child: SomSvgIcon(
                  SomAssets.iconClearCircle,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => _searchTextEditingController.clear(),
              )
            : Container(),
        Container(),
      ],
    );
  }

  Widget _tagsWidget() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _tags.isNotEmpty
              ? Column(children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: _tags
                        .map((tagModel) => tagChip(
                            tagModel: tagModel,
                            onTap: () => _removeTag(tagModel),
                            action: 'Remove',
                            showCloseIcon: true))
                        .toSet()
                        .toList(),
                  ),
                ])
              : Container(),
          _buildSearchFieldWidget(),
          _displayTagWidget(),
        ],
      ),
    );
  }
}
