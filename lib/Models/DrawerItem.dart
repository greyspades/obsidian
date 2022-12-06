class DrawerItem {
  DrawerItem(
    this.title,
    this.body,
    [this.isExpanded = false]
  );
  String title;
  String body;
  bool isExpanded;
}