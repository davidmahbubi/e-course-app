import 'package:e_course_app/pages/watch_video.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'E-Course App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(height: 200, enlargeCenterPage: true),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: Image.asset('assets/images/example_banner.jpg'));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Course Videos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                childAspectRatio: 0.62,
                crossAxisCount: 2,
                shrinkWrap: true,
                // physics: const BouncingScrollPhysics(),
                children: List.generate(10, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => WatchVideo()),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Image.asset(
                            'assets/images/example_banner_video.jpg',
                            width: 170,
                          ),
                        ),
                        const SizedBox(height: 13),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Flexible(
                            child: Text(
                              'Aljabar Linear',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Flexible(
                            child: Text(
                              'Matematika Diskrit',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
