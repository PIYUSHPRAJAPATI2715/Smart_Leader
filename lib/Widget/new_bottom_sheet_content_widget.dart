import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Modal/language_filter_model.dart';

import '../Helper/Api.helper.dart';

class NewBottomSheetContentWidget extends StatefulWidget {
  const NewBottomSheetContentWidget({super.key});

  @override
  State<NewBottomSheetContentWidget> createState() =>
      _NewBottomSheetContentWidgetState();
}

class _NewBottomSheetContentWidgetState
    extends State<NewBottomSheetContentWidget> {
  bool isSubmit = true;
  List<LanguagesData> languages = [];
  bool isLanguageSearching = false;

  @override
  void initState() {
    super.initState();
    languageFilter();
  }

  void languageFilter() async {
    try {
      final value = await ApiHelper.languageFilter();
      setState(() {
        isSubmit = false;
        if (value.status == true) {
          languages = value.languages ?? [];
          isLanguageSearching = languages.isNotEmpty;
          print("Languages Initialized: $languages");
        }
      });
    } catch (error) {
      setState(() {
        isSubmit = false;
      });
      print("Error fetching languages: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: CupertinoColors.activeBlue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              children: [
                customtext(
                  fontWeight: FontWeight.w700,
                  text: "Filter By Language",
                  fontsize: 16,
                  color: Colors.white,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLanguageSearching
                ? ListView.builder(
                    itemCount: languages.length,
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      return ListTile(
                        leading: const Icon(Icons.language),
                        title: customtext(
                          fontWeight: FontWeight.w500,
                          text: language.value ?? 'Unknown',
                          fontsize: 15,
                        ),
                        onTap: () {
                          Navigator.pop(context, language.id.toString());
                        },
                      );
                    },
                  )
                : Center(
                    child: isSubmit
                        ? const CircularProgressIndicator()
                        : const Text('No languages available.'),
                  ),
          ),
        ],
      ),
    );
  }
}
