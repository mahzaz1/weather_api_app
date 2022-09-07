import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather_api_app/services/api_services.dart';
import 'Models/currentWeatherModel.dart';
import 'const/colors.dart';
import 'const/images.dart';
import 'const/strings.dart';
import 'controller/mainController.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = DateFormat('yMMMMd').format(DateTime.now());

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var controller = Get.put(MainController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '$date',
          style: TextStyle(color: Vx.gray300),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.changeTheme(ThemeData.dark());
              },
              icon: Icon(
                Icons.light_mode_outlined,
                color: Vx.gray300,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_outlined, color: Vx.gray300)),
        ],
      ),
      body:
         Padding(
            padding: EdgeInsets.all(15),
            child: FutureBuilder(
              future: controller.currentWeatherData,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  CurrentWeatherModel data = snapshot.data;
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '${data.name}'
                            .text
                            .size(30)
                            .uppercase
                            .fontFamily('poppins_bold')
                            .make(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                                'assets/weather/${data.weather![0].icon}.png'),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '${data.main!.temp?.toInt()}$degree',
                                  style: TextStyle(
                                    color: Vx.white,
                                    fontSize: 60,
                                  )),
                              TextSpan(
                                  text: '${data.weather![0].description}'.upperCamelCase,
                                  style: TextStyle(
                                      color: Vx.gray300,
                                      fontFamily: 'poppins_light'))
                            ]))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.expand_less_outlined),
                              label: '${data.main!.tempMin?.toInt()}$degree'.text.make(),
                            ),
                            TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.expand_more_outlined),
                              label: '${data.main!.tempMax?.toInt()}$degree'.text.make(),
                            ),
                          ],
                        ),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(3, (index) {
                            var iconsList = [cloud, humidity, windSpeed];
                            var values = [
                              '${data.clouds!.all}%',
                              '${data.main!.humidity}%',
                              '${data.wind!.speed} km/h'
                            ];
                            return Column(
                              children: [
                                Image.asset(
                                  iconsList[index],
                                  width: width * .1,
                                ).box.color(cardColor).p8.roundedSM.make(),
                                10.heightBox,
                                values[index].text.gray500.make()
                              ],
                            );
                          }),
                        ),
                        10.heightBox,
                        Divider(
                          thickness: 1,
                        ),
                        10.heightBox,
                        FutureBuilder(
                            future: controller.hourlyWeatherData,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: height * .19,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: 8,
                                      itemBuilder: (context, index) {
                                        var hourlyData = list[index];
                                        var time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hourlyData['dt']!.toInt() * 1000));

                                        return Container(
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                              color: cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              '${time}'
                                                  .text
                                                  .gray400
                                                  .make(),
                                              Image.asset(
                                                'assets/weather/${hourlyData['weather'][0]['icon']}.png',
                                                width: width * .16,
                                              ),
                                              '${hourlyData['main']['temp'].toInt()}$degree'.text.gray400.make(),
                                            ],
                                          ),
                                        );
                                      }),
                                );
                              }
                              else{
                                return Center(child: CircularProgressIndicator(),);
                              }
                            }),
                        10.heightBox,
                        Divider(
                          thickness: 1,
                        ),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            'Next 7 Days'.text.bold.make(),
                            TextButton(
                                onPressed: () {},
                                child: 'View All'.text.bold.make())
                          ],
                        ),
                        FutureBuilder(
                          future: controller.hourlyWeatherData,
                            builder: (context,snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 7,
                                itemBuilder: (context, index) {

                                  var day = DateFormat('EEEE').format(
                                      DateTime.now().add(Duration(days: index + 1)));
                                  var hourlyData = list[index + 7];

                                  return Card(
                                    shadowColor: Colors.grey,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: day.text.gray300.make()),
                                            Expanded(
                                              child: TextButton.icon(
                                                  onPressed: () {},
                                                  icon: Image.asset(
                                                    'assets/weather/${hourlyData['weather'][0]['icon']}.png',
                                                    width: width * .1,
                                                  ),
                                                  label: '${hourlyData['main']['temp'].toInt()}$degree'.text.gray400.make()),
                                            ),
                                            '${hourlyData['main']['temp_min'].toInt()}$degree / ${hourlyData['main']['temp_max'].toInt()}$degree' .text.blue500.make()
                                          ],
                                        ),
                                      ));
                                });
                          }else{
                            return Center(child: CircularProgressIndicator(),);

                          }
                        }),

                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red,),
                  );
                }
              },
            )),
      );
  }
}
