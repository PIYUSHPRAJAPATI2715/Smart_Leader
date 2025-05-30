import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class ToolsSearchBarWidget extends StatelessWidget {
  ValueChanged onchange;
  VoidCallback ontapIcon;
  bool enable;
   ToolsSearchBarWidget({Key? key,required this.onchange,required this.ontapIcon,this.enable = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
              color: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor,
              borderRadius: BorderRadius.circular(20)),
          child: TextFormField(
            onChanged: onchange,
            enabled: enable,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: "SplineSans",
                fontSize: 18,
                fontWeight: FontWeight.w400),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              suffixIcon: InkWell(
                onTap: ontapIcon,
                child: Icon(
                  Icons.filter_alt_outlined,color: Theme.of(context).primaryColor,
                ),
              ),
              hintText: "Search",
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: "SplineSans",
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : Colors.white)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
