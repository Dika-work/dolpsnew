import 'package:doplsnew/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/theme/app_colors.dart';

class CustomSearchTextFormField extends StatefulWidget {
  final double offset;
  final String name;
  final TextEditingController textEditingController;
  final Function(String) function;
  final String nameTextField;
  final Function()? clearFunction;
  final IconData icon;
  const CustomSearchTextFormField(
      {super.key,
      required this.offset,
      required this.name,
      required this.textEditingController,
      required this.function,
      required this.nameTextField,
      required this.clearFunction,
      required this.icon});

  @override
  State<CustomSearchTextFormField> createState() =>
      _CustomSearchTextFormFieldState();
}

class _CustomSearchTextFormFieldState extends State<CustomSearchTextFormField> {
  bool search = false;
  bool textVisible = false;

  // Function to update the visibility of the clear icon
  void _updateTextVisibility() {
    setState(() {
      textVisible = widget.textEditingController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add a listener to the textEditingController
    widget.textEditingController.addListener(_updateTextVisibility);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.textEditingController.removeListener(_updateTextVisibility);
    super.dispose();
  }

  Widget change(double width, BuildContext context) {
    // final dark = CustomHelperFunctions.isDarkMode(context);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: 10,
      right: search ? 10 : 0,
      bottom: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 150,
        width: widget.offset > 30
            ? (search ? width - 40 : 20)
            : (search ? width : 40),
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: search
                ? TextField(
                    controller: widget.textEditingController,
                    onChanged: widget.function,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.nameTextField,
                      prefixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            search = false;
                            widget.textEditingController.clear();
                            textVisible = false;
                            widget.clearFunction?.call();
                          });
                        },
                        child: const Icon(
                          Iconsax.close_circle,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        search = true;
                      });
                    },
                    child: Icon(
                      widget.icon,
                      color: AppColors.black,
                    ),
                  )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 80,
      color: Theme.of(context).scaffoldBackgroundColor,
      width: CustomHelperFunctions.screenWidth(),
      child: Stack(
        children: [
          change(CustomHelperFunctions.screenWidth() * .96, context),
          Align(
              alignment: Alignment.centerLeft,
              child: search
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        widget.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )),
          Positioned(
            top: 0,
            right: 15,
            bottom: 0,
            child: Visibility(
              visible: textVisible,
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.textEditingController.clear();
                    textVisible = false;
                    widget.clearFunction?.call();
                  });
                },
                child: const Icon(
                  Iconsax.close_circle,
                  color: AppColors.warning,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
