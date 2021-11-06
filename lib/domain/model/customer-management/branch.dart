class Branch {
  String uuid;
  String title;
  Branch? category;
  Branch? product;

  Branch({
    required this.uuid,
    required this.title,
    Branch? category,
    Branch? product,
  }) {
    category?.category = null;
    category?.product = null;
    product?.category = null;
    product?.product = null;
  }
}
