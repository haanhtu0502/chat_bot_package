import 'package:flutter/material.dart';
import 'package:chat_bot_package/core/components/constant/handle_time.dart';
import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';

class RecentDocumentItem extends StatelessWidget {
  final String header;
  final String content;
  final String type;
  final DateTime createdDate;
  const RecentDocumentItem({
    super.key,
    required this.header,
    required this.content,
    required this.type,
    required this.createdDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getYmdHmFormat(createdDate),
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).hintColor,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 5.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
                child: Text(
                  type,
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Text(
            content,
            maxLines: 4,
            style: context.titleSmall.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child:
                    Icon(Icons.copy_outlined, color: context.titleLarge.color),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {},
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ].expand((e) => [e, const SizedBox(height: 5.0)]).toList(),
      ),
    );
  }
}
