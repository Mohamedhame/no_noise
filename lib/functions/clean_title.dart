String cleanTitle(List filterData, int index) {
  String title = "${filterData[index]['title']}";
  return title.replaceAll(RegExp(r'[:!@#%^&*(),.?":{}|<>]'), '');
}
