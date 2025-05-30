import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Widget/sync_barchart_widget.dart';
import 'package:smart_leader/Widget/sync_linechart_widget.dart';

class BusinessCreatorFragment extends StatefulWidget {
  const BusinessCreatorFragment({Key? key}) : super(key: key);

  @override
  State<BusinessCreatorFragment> createState() =>
      _BusinessCreatorFragmentState();
}

class _BusinessCreatorFragmentState extends State<BusinessCreatorFragment> {
 // List<String> frequencyContainer = ["Bar Chart", "Line Chart"];
 // List<String> frequencyContainer = [ "Line Chart"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppController>(context, listen: false).getBarGraphList();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),

            const SizedBox(height: 2),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //       children: List.generate(
            //     growable: true,
            //     frequencyContainer.length,
            //     (index) => InkWell(
            //       onTap: () {
            //         data.getchartContainer(index);
            //       },
            //       child: Card(
            //         color: SessionManager.getTheme() == true
            //             ? kscafolledColor
            //             : kWhiteColor,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(20)),
            //         child: Container(
            //           decoration: BoxDecoration(
            //               gradient: SessionManager.getTheme() == true
            //                   ? data.chartContainer == index
            //                       ? kGradient
            //                       : kgreyGradient
            //                   : data.chartContainer == index
            //                       ? kGradient
            //                       : k2Gradient,
            //               borderRadius: BorderRadius.circular(40),
            //               border: Border.all(
            //                   color: SessionManager.getTheme() == true
            //                       ? kscafolledColor
            //                       : KBoxNewColor)),
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 22, vertical: 10),
            //             child: Center(
            //               child: customtext(
            //                 fontWeight: FontWeight.w400,
            //                 text: frequencyContainer[index],
            //                 fontsize: 12,
            //                 color: data.chartContainer == index
            //                     ? kWhiteColor
            //                     : Theme.of(context).primaryColor,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   )),
            // ),
            // const SizedBox(height: 10),
            // Visibility(
                //visible: data.chartContainer == 0, child: const SynnBarChart()),
            const SizedBox(
              height: 20,
            ),
            Visibility(
                visible: data.chartContainer == 0,
                child: const SyncLineChartWidget()),
          ],
        ),
      ),
    );
  }
}
