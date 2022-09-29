import 'package:badges/badges.dart';
import 'package:store/constants/screen_ids.dart';
import 'package:store/constants/screen_titles.dart';
import 'package:store/controllers/cart_controller.dart';
import 'package:store/controllers/category_controller.dart';
import 'package:store/controllers/product_controller.dart';
import 'package:store/screens/product_detail.dart';
import 'package:store/screens/shopping_cart.dart';
import 'package:store/skeletons/category_list_skeleton.dart';
import 'package:store/skeletons/product_list_skeleton.dart';
import 'package:store/widgets/category.dart';
import 'package:store/widgets/drawer.dart';
import 'package:store/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductList extends StatefulWidget {
  const ProductList({ Key? key}) : super(key: key);
  static String id = productListScreenId;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _textEditingController = TextEditingController();
   late int _categorySelectedIndex;
  late final ProductController _productController;
  var _cartController;
  var _categoryController;
  //todo get ridf of all globalkeys
  //https://stackoverflow.com/questions/51253630/flutter-access-parent-scaffold-from-different-dart-file
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _productController = Provider.of<ProductController>(context, listen: false);
    _productController.getAllProducts(_scaffoldKey);
    _categoryController =
        Provider.of<CategoryController>(context, listen: false);
    _categoryController.getAllCategories(_scaffoldKey);
    _cartController = Provider.of<CartController>(context, listen: false);
    _cartController.getSavedCart();
   // _textEditingController.addListener(_handleSearchField);
    _categorySelectedIndex = 0;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Future<void> _handleSearchField() async{
  //   _productController.getProductByCategoryOrName(
  //     _textEditingController.text,
  //   );
  //   _categorySelectedIndex = null;
  // }

  Future<bool> _handleRefresh() {
    _productController.setIsLoadingAllProducts(true);
    _categoryController.setIsLoadingCategories(true);
    _categoryController.getAllCategories(_scaffoldKey);
    _productController.getAllProducts(_scaffoldKey);
    _categorySelectedIndex = 0;
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double leftMargin = 18;
    double rightMargin = 10;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          productListScreenTitle,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: rightMargin),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ShoppingCart.id);
              },
              child: Badge(
                padding: const EdgeInsets.all(5),
                badgeContent: Text(
                  '${context.watch<CartController>().cart.length}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //search field,title
            RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  //search field
                  Container(
                    height: size.height / 15,
                    margin: EdgeInsets.only(
                      left: leftMargin,
                      right: rightMargin,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: "Search by product name or category",
                        contentPadding: const EdgeInsets.only(
                          top: 8,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        fillColor: Colors.grey[300],
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //title
                  Container(
                    margin: EdgeInsets.only(left: leftMargin),
                    child: const Text(
                      "Get The Best Products",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),

            // Horizontal list of categories
            Container(
                height: 50,
                margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
                child: Consumer<CategoryController>(
                    builder: (context, cateogoryCtlr, child) {
                  if (cateogoryCtlr.isLoadingCategories) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[400]!,
                      child:  const CategoryListSkeleton(),
                    );
                  }

                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cateogoryCtlr.categoryList.length,
                      itemBuilder: (context, index) {
                        return Category(
                          category: cateogoryCtlr.categoryList[index].category,
                          categoryIndex: index,
                          //todo
                          categorySelectedIndex: _categorySelectedIndex,
                          onTapped: () {
                            setState(() {
                              _categorySelectedIndex = index;
                            });
                            _productController.getProductByCategory(
                              cateogoryCtlr.categoryList[index].category,
                              _scaffoldKey,
                            );
                          },
                        );
                      });
                })),
            const SizedBox(
              height: 30,
            ),

            // List of products
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
                child: Consumer<ProductController>(
                    builder: (context, productCtlr, child) {
                  if (productCtlr.isLoadingAllProducts) {
                    return Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.grey[400]!,
                        child:  const ProductListSkeleton(),
                      ),
                    );
                  }
                  if (!productCtlr.isLoadingAllProducts &&
                      productCtlr.productList.isEmpty) {
                    return const Center(
                      child: Text(
                        'Results not found ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: productCtlr.productList.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: productCtlr.productList[index],
                        onProductTapped: () {
                          _cartController
                              .setCurrentItem(productCtlr.productList[index]);
                          Navigator.pushNamed(context, ProductDetail.id);
                        },
                      );
                    },
                  );
                }),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      drawer: SizedBox(
        width: size.width * 0.8,
        child: const CDrawer(),
      ),
    );
  }
}
