
import 'package:adhan_app/model/salah.dart';
import 'package:flutter/material.dart';

import 'salah_item_widget.dart';

class SalahTimeSection extends StatelessWidget {
  const SalahTimeSection({
    Key key,
    @required this.list,
  }) : super(key: key);

  final List<Salah> list;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext ctx, int index) {
          return SalahItemWidget(
            salah: list[index],
          );
        },
        separatorBuilder: (BuildContext ctx, int index) {
          return SizedBox(
            height: 6,
          );
        },
        itemCount: list.length,
      ),
    );
  }
}