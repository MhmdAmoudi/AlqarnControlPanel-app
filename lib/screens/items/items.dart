import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../widgets/card_tile.dart';
import '../../widgets/download_image.dart';
import '../../widgets/drawer/sections_drawer.dart';
import '../../widgets/infinite_list.dart';
import '../home/home.dart';
import 'controller/item_controller.dart';
import 'edit_item.dart';
import 'add_item.dart';
import 'models/item_model.dart';
import 'search.dart';
import 'show_item.dart';

class Items extends StatelessWidget {
  const Items({Key? key}) : super(key: key);
  static final API _api = API('Item', isFile: true);
  static final List<ItemModel> _items = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Get.off(() => const Home());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('المنتجات'),
            actions: [
              IconButton(
                onPressed: () => Get.to(() => const AddItem()),
                icon: const Icon(Icons.add_rounded),
              ),
              IconButton(
                onPressed: () => Get.to(() => const ItemSearch()),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          drawer: const MenuDrawer(),
          body: InfiniteList<ItemModel>(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            margin: const EdgeInsets.only(top: 1),
            items: _items,
            getItems: (List<String> sentItemsIds) => getItems(sentItemsIds),
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
        ),
      ),
    );
  }

  Future<List<ItemModel>> getItems(List<String> sentItemsIds) async {
    try {
      var data = await _api.post('GetItems', data: {'sentIds': sentItemsIds});
      return ItemModel.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }
}
