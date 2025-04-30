import 'package:flutter/material.dart';

TextFormField reusableTextField(
  String text,
  TextEditingController controller,
  Color? color,
  VoidCallback? tap(),
) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "field is required";
        }
        return null;
      },
      autocorrect: true,
      onTap: tap,
      controller: controller,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color!),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // disabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
      keyboardType: TextInputType.text);
}

TextFormField expandableTextField(
  String text,
  Color? color,
  TextEditingController controller,
) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "field is required";
        }
        return null;
      },
      autocorrect: true,
      //  autofocus: true,
      controller: controller,
      minLines: 1,
      maxLines: 20,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color!),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // disabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
      keyboardType: TextInputType.text);
}

TextFormField postViewTextField(
    String text, TextEditingController controller, Widget prefix) {
  return TextFormField(
      autocorrect: true,
      controller: controller,
      minLines: 1,
      maxLines: 5,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        prefixIcon: prefix,
        labelText: text,
        hintText: text,
        helperStyle: TextStyle(
          fontSize: 16,
        ),
        labelStyle: TextStyle(
          fontSize: 16,
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.green.shade300,
        //   ),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide( color: Colors.green.shade300,),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // disabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
      keyboardType: TextInputType.text);
}

TextFormField phoneTextField(
  String text,
  TextEditingController controller,
  Color? color,
  Function? tap(),
) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "phone number is required";
        }
        return null;
      },
      onTap: tap,
      //  autofocus: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color!),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // disabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
      keyboardType: TextInputType.phone);
}

TextFormField transferTextField(
  Widget icon,
  String text,
  TextEditingController controller,
  Color? color,
  Function? tap(),
) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Amount?";
        }
        return null;
      },
      onTap: tap,
      //  autofocus: true,
      controller: controller,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        prefixIcon: icon,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color!),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // disabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
      keyboardType: TextInputType.number);
}




TextFormField moneyTextField(
  String text,
  TextEditingController controller,
  Color? color,
  Function? tap(),
) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Amount is required";
        }
        return null;
      },
      onTap: tap,
       autofocus: false,
      controller: controller,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color!),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: color),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // disabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
      keyboardType: TextInputType.number);
}