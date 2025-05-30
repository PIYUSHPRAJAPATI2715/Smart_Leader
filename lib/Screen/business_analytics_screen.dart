import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/ShowGraph.dart';
import 'package:smart_leader/Modal/show_analytics.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class BusinessAnalyticScreen extends StatefulWidget {
  const BusinessAnalyticScreen({Key? key, required this.showGraph})
      : super(key: key);

  final ShowGraph showGraph;

  @override
  State<BusinessAnalyticScreen> createState() => _BusinessAnalyticScreenState();
}

class _BusinessAnalyticScreenState extends State<BusinessAnalyticScreen> {
  /*
  Analytics will show the following:
1. % times you achieved your business
2. Big gaps (with respect to % difference) is in which team
3. Which specific months reduce your business
4. Which team is performing well
   */
  late Future<ShowAnalytics> _future;

  Future<ShowAnalytics> getAnalytics() {
    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'branch_id': widget.showGraph.branchId!
    };
    print(body);
    return ApiHelper.showAnalytics(body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 102,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                    AssetImage("assest/images/OnBordScreenTopScreen.png"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: kWhiteColor,
                      )),
                  Expanded(
                    child: Center(
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: "Smart Leader",
                        fontsize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {

                        Navigator.pop(context);

                      },
                      child: Image.asset(
                        "assest/png_icon/home_removebg_preview.png",
                        height: 25,
                        width: 25,
                      ))

                ],
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<ShowAnalytics>(
              future: _future,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                ShowAnalytics analytics = response.data!;

                if (analytics.data == null || analytics.data!.isEmpty) {
                  return Center(
                    child: customtext(
                        fontWeight: FontWeight.w600,
                        text: 'No data found',
                        fontsize: 14.0),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: analytics.data!.length,
                  itemBuilder: (context, index) {
                    return  ShowAnalyticsWidget(data: analytics.data![index],);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ShowAnalyticsWidget extends StatelessWidget {
  const ShowAnalyticsWidget({super.key,required this.data});

  final ShowAnalyticsData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade400)),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 3.0),
          Row(
            children: [

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: kblueColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.all(3.0),
                child: customtext(
                  fontWeight: FontWeight.w600,
                  text: data.monthYear!,
                  fontsize: 12.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 3.0,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.teamData!.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 3.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.all(3.0),
                    child: customtext(
                      fontWeight: FontWeight.w600,
                      text: '${data.teamData![index].teamName}',
                      fontsize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            customtext(
                              fontWeight: FontWeight.w500,
                              text: 'Target: ₹${Helper.formatUnitType(int.parse(data.teamData![index].targetAmount!))}',
                              fontsize: 12.0,

                            ),
                            SizedBox(width: 10.0),
                            customtext(
                              fontWeight: FontWeight.w500,
                              text: 'Completed: ₹${Helper.formatUnitType(int.parse(data.teamData![index].amount!))}',
                              fontsize: 12.0,
                              color: Colors.green,
                            ),

                          ],
                        ),
                        const SizedBox(height: 5.0),
                        customtext(
                          fontWeight: FontWeight.w500,
                          text: '1. ${data.teamData![index].percentage}% times you achieved your business',
                          fontsize: 12.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 5.0),
                        customtext(
                          fontWeight: FontWeight.w500,
                          text:
                              '2. ₹${Helper.formatUnitType(data.teamData![index].gaps!.toInt())} gaps',
                          fontsize: 12.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 5.0),

                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 3.0,
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
