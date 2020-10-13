import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/container_property.dart';
import 'package:provider/provider.dart';

class ContainerPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<ContainerProperty>();
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(property.container.title),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      tilePadding: EdgeInsets.symmetric(vertical: 10),
      initiallyExpanded: false,
      // trailing: IconButton(
      //   icon: Icon(Icons.create),
      //   onPressed: () {},
      // ),
      backgroundColor: Colors.grey[200],
      children: [
        SizedBox(height: 400, child: property.container.widget),
      ],
    );
  }
}
