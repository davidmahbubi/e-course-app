import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 200, enlargeCenterPage: true),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.asset('assets/images/example_banner.jpg'),
            );
          },
        );
      }).toList(),
    );
  }
  
}