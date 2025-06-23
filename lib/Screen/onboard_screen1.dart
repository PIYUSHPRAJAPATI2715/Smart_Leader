import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/onbord_modal.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Screen/welcome_screen.dart';

class OnboardScreen1 extends StatefulWidget {
  const OnboardScreen1({Key? key}) : super(key: key);

  @override
  State<OnboardScreen1> createState() => _OnboardScreen1State();
}

class _OnboardScreen1State extends State<OnboardScreen1> {

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          topContainer(),
          middleColum(),
          bottumContainer(),
        ],
      ),
    );
  }

  // Middle Column with PageView
  Widget middleColum() {
    final data = Provider.of<AppController>(context);
    return Flexible(
      flex: 2,
      child: PageView.builder(
        controller: pageController,
        itemCount: OnBordModal.onBordList.length,
        onPageChanged: (value) {
          data.getPageIndex(value);
        },
        itemBuilder: (BuildContext context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {
                          pageController.animateToPage(
                            pageController.page!.toInt() - 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.bounceIn,
                          );
                        },
                        icon: Icon(Icons.arrow_back_ios, size: 25, color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        child: Image.asset(
                          OnBordModal.onBordList[index].image,
                          height: 250,
                          width: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (data.getPage == OnBordModal.onBordList.length - 1) {
                            data.getPageIndex(0);
                            SessionManager.setwelcome(true);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                          } else {
                            pageController.animateToPage(
                              pageController.page!.toInt() + 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.bounceIn,
                            );
                          }
                        },
                        icon: Icon(Icons.arrow_forward_ios_outlined, size: 25, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              customtext(
                alignment: TextAlign.start,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
                text: OnBordModal.onBordList[index].title,
                fontsize: 25,
              ),
              SizedBox(height: 15),
              customtext(
                fontWeight: FontWeight.w400,
                text: OnBordModal.onBordList[index].subTitle,
                fontsize: 15,
                color: Theme.of(context).primaryColor,
                alignment: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  // Top Container (Banner)
  Widget topContainer() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25, // Make this responsive
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  SessionManager.setwelcome(true);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
                child: customtext(
                  fontWeight: FontWeight.w500,
                  text: "Skip",
                  fontsize: 17,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Container with Pagination
  Widget bottumContainer() {
    final data = Provider.of<AppController>(context);
    return Container(
      width: double.infinity,
      height: 100, // Reduced height for better fitting
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assest/images/OnBordScreenBottumImage.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Pagination Dots
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                OnBordModal.onBordList.length,
                    (index) => Container(
                  margin: EdgeInsets.all(5),
                  height: data.getPage == index ? 16 : 14,
                  width: data.getPage == index ? 16 : 14,
                  decoration: BoxDecoration(
                    color: data.getPage == index ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: data.getPage == index ? kWhiteColor : Color(0xff011638),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
