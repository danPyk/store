List<CategoryModel> createList(List<String> list) => List<CategoryModel>.from(
    list.map<CategoryModel>((String i) => CategoryModel(category: i.replaceAll( RegExp(r'[^\w\s]+'),''))));

class CategoryModel {
  CategoryModel({
    required this.category,
  });

  factory CategoryModel.empty() => CategoryModel(category: '');

  String category;
}
