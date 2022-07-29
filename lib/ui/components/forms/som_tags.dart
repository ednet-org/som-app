import 'package:flutter/material.dart';
import 'package:som/domain/model/shared/som.dart';

// import 'package:flutter_tags/flutter_tags.dart';
// https://medium.com/nonstopio/flutter-tags-7410bd6a5835

class SomTags extends StatefulWidget {
  const SomTags({required this.tags}) : super();
  final List<TagModel> tags;

  @override
  _SomTagsState createState() => _SomTagsState();
}

class _SomTagsState extends State<SomTags> with SingleTickerProviderStateMixin {
  final List<TagModel> _tags = [];
  final List<TagModel> _suggestions = [];
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  String get _searchText => _searchTextEditingController.text.trim();

  refreshState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _searchTextEditingController.addListener(() => refreshState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }

  List<TagModel> _filterSearchResultList() {
    if (_searchText.isEmpty) return _suggestions;

    List<TagModel> _tempList = [];
    for (int index = 0; index < widget.tags.length; index++) {
      TagModel tagModel = widget.tags[index];
      if (tagModel.title
          .toLowerCase()
          .trim()
          .contains(_searchText.toLowerCase())) {
        _tempList.add(tagModel);
      }
    }

    return _tempList;
  }

  _addTags(tagModel) async {
    if (!_tags.contains(tagModel)) {
      setState(() {
        _tags.add(tagModel);
      });
    }
  }

  _removeTag(tagModel) async {
    if (_tags.contains(tagModel)) {
      setState(() {
        _tags.remove(tagModel);
      });
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
        // Icon(
        //   Icons.local_offer_outlined,
        //   color: Colors.deepOrangeAccent,
        //   size: 25.0,
        // ),
        _tagsWidget(),
      ],
    );
  }

  _displayTagWidget() {
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
    ]);
  }

  Widget tagChip({
    tagModel,
    onTap,
    action,
    showCloseIcon,
  }) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Text(
                  '${tagModel.title}',
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            showCloseIcon
                ? Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8.0,
                      child: const Icon(
                        Icons.clear,
                        size: 10.0,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ));
  }

  Widget _buildSearchFieldWidget() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 10.0,
        bottom: 10.0,
      ),
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 5.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        border: Border.all(
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchTextEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search branch',
                hintStyle: TextStyle(),
              ),
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          _searchText.isNotEmpty
              ? InkWell(
                  child: Icon(
                    Icons.clear,
                  ),
                  onTap: () => _searchTextEditingController.clear(),
                )
              : Icon(
                  Icons.search,
                ),
          Container(),
        ],
      ),
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
