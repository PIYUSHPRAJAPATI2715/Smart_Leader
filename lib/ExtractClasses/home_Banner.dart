import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_banner_modal.dart';
import 'package:smart_leader/Provider/app_controller.dart';

class HomeBanner1 extends StatefulWidget {
  const HomeBanner1({Key? key}) : super(key: key);

  @override
  State<HomeBanner1> createState() => _HomeBanner1State();
}

class _HomeBanner1State extends State<HomeBanner1> {

  late Future<ShowBannerModal>futureBanner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureBanner = ApiHelper.homeBanner();
  }


  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
    return FutureBuilder<ShowBannerModal>(
        future: futureBanner,
        builder: (context , snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            child: PageView.builder(
                itemCount: snapshot.data!.data!.length,
                onPageChanged: (value) {
                  data.getbannerslider(value);
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: SessionManager.getTheme()== true?kGradientblack:kGradient),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customtext(
                                fontWeight: FontWeight.w600,
                                text: snapshot.data!.data![index].title!,maxLine: 2,
                                fontsize: 22,
                                color: kWhiteColor,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              customtext(
                                  fontWeight: FontWeight.w400,
                                  color: kWhiteColor,maxLine: 4,
                                  text:snapshot.data!.data![index].description!,
                                  fontsize: 10),
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 25, vertical: 8),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(7),
                              //       color: Color(0xffFFD3AC)),
                              //  child: customtext(fontWeight: FontWeight.w400, text: "Buy Now", fontsize: 7,color: kBlackColor,),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Image.network(snapshot.data!.data![index].path!+snapshot.data!.data![index].image!,
                            height: 175,
                            width: 30,
                          ),
                        )
                        // Image.asset(
                        //   "assest/png_icon/banner_book_image.png",
                        //   height: 175,
                        //   width: 97,
                        // )
                      ],
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                snapshot.data!.data!.length,
                    (index) => Container(
                  margin: EdgeInsets.all(5),
                  height: SessionManager.getTheme()== true?8:7,
                  width: SessionManager.getTheme()== true?8:7,
                  decoration: BoxDecoration(
                      gradient:
                      data.bannerslider == index ? SessionManager.getTheme()== true?k2Gradient:kGradient : k2Gradient,
                      // color: data.bannerslider==index?Color(0xff000E87):Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: data.bannerslider == index
                              ? SessionManager.getTheme()== true?kWhiteColor:Color(0xff000E87)
                              : Color(0xff557AFF),
                          width: 1)),
                )),
          ),
        ],
      );
    });
  }
}
