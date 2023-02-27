import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../api/api.dart';
import '../../utilities/appearance/style.dart';
import '../../widgets/card_tile.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/download_image.dart';
import '../../widgets/infinite_list.dart';
import 'controller/item_controller.dart';
import 'edit_item.dart';
import 'models/item_model.dart';
import 'show_item.dart';

class ItemSearch extends StatefulWidget {
  const ItemSearch({Key? key}) : super(key: key);

  @override
  State<ItemSearch> createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  final API _api = API('Item', withFile: true);

  final List<ItemModel> _items = [];

  final FocusNode searchFocus = FocusNode();
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      searchFocus.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 52,
        title: SizedBox(
          height: 40,
          child: CustomTextFormField(
            focusNode: searchFocus,
            controller: search,
            fillColor: AppColors.darkMainColor,
            hintText: 'ابحث',
            prefixIcon: Icons.search,
            onPrefixTap: () => setState(() {
              _items.clear();
            }),
            suffixIcon: Icons.cancel_outlined,
            onSuffixTap: () {
              search.clear();
            },
            borderColor: false,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
          )
        ],
      ),
      body: InfiniteList<ItemModel>(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        margin: const EdgeInsets.only(top: 1),
        items: _items,
        getItems: getItems,
        child: (int index) => CardTile(
          leading: _items[index].haveImage
              ? DownloadImage(
                  parent: (image) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    );
                  },
                  getImage: () =>
                      ItemController.getItemMainImage(_items[index].id),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'asset/icons/alqaren.png',
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                ),
          title: _items[index].name,
          subtitle:
              '${_items[index].quantity} حبة - ${_items[index].createdAt}',
          subtitleColor: _items[index].quantity > 0 ? null : Colors.red,
          isActive: _items[index].isActive,
          onTap: () =>
              Get.to(() => ShowItem(_items[index].id, _items[index].name)),
          onEditPressed: () => Get.to(() => EditItem(_items[index])),
        ),
      ),
    );
  }

  Future<List<ItemModel>> getItems(List<String> sentItemsIds) async {
    if (search.text.trim().isNotEmpty) {
      var data = await _api.post('GetItems',
          data: {'sentIds': sentItemsIds, 'text': search.text.trim()});
      return ItemModel.fromJson(data);
    }
    return [];
  }
}
