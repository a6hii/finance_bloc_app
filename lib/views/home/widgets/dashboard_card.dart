import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.color,
    required this.icon,
    required this.labelText,
    required this.value,
  });

  final Color color;
  final Icon icon;
  final String labelText;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.44,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white38,
                child: icon,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    labelText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text("\$ $value")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
