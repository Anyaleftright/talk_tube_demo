import 'package:flutter/material.dart';
import 'package:talk_tube_1/models/user_model.dart';

class ContactListView extends StatelessWidget {
  const ContactListView({
    Key? key,
    required this.userModel,
    required this.callback,
  }) : super(key: key);

  final UserModel userModel;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  userModel.image == ""
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/default.png'),
                          maxRadius: 30,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(userModel.image),
                          maxRadius: 30,
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel.name == '' ? 'No name' : userModel.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            userModel.status,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
