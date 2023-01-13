import 'package:flutter/material.dart';

class EntityCard extends StatelessWidget {
  final item;

  final mapping;

  const EntityCard({
    Key? key,
    required Map<String, String> this.item,
    EdsCardMapping this.mapping = const EdsCardMapping(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: mapping.build(item));
  }
}

class EdsCardMapping {
  final String id = 'id';
  final String title = 'title';
  final String description = 'description';
  final String category = 'category';
  final String branch = 'branch';
  final String username = 'username';
  final String userrole = 'userrole';
  final String userphonenumber = 'userphonenumber';
  final String usermail = 'usermail';
  final String publishingDate = 'publishingDate';
  final String expirationDate = 'expirationDate';
  final String deliverylocation = 'deliverylocation';
  final String numberofOffers = 'numberofOffers';
  final String providerlocation = 'providerlocation';
  final String providercompanytype = 'providercompanytype';
  final String providercompanysize = 'providercompanysize';
  final String attachments = 'attachments';
  final String status = 'status';
  final String offers = 'offers';

  const EdsCardMapping();

  // function which returns a widget based on properties of this class
  Widget build(Map<String, String> item) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'ID: ${item[id]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Status: ${item[status]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Title: ${item[title]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Category: ${item[category]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Description: ${item[description]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Branch: ${item[branch]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'User: ${item[username]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Role: ${item[userrole]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Phone: ${item[userphonenumber]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Mail: ${item[usermail]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Publishing Date: ${item[publishingDate]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Expiration Date: ${item[expirationDate]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Delivery Location: ${item[deliverylocation]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Number of Offers: ${item[numberofOffers]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Provider Location: ${item[providerlocation]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Provider Company Type: ${item[providercompanytype]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Provider Company Size: ${item[providercompanysize]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Attachments: ${item[attachments]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Offers: ${item[offers]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
