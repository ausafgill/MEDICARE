import 'package:flutter/material.dart';
import 'package:medicare/shared/constants/colors.dart';

// class HelperButton extends StatelessWidget {
//   final String name;
//   final VoidCallback onTap;
//   final Color? color;
//   bool isLoading;
//   HelperButton(
//       {super.key, required this.name, required this.onTap, this.color,this.isLoading=false;});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 50,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: color ?? EColors.primaryColor,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child:  isLoading?const Center(child: CircularProgressIndicator(),): Center(
//             child: Text(
//               name,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class HelperButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Color? color;
  bool isLoading;
  HelperButton(
      {super.key,
      required this.name,
      required this.onTap,
      this.color,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color ?? EColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: EColors.white,
                  ),
                )
              : Center(
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
