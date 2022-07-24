import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {

  final List<String> carouselImages = const [
    'geometri_ruang.jpg',
    'hak_kewajiban.jpg',
    'indahnya_saling_menghormati.jpg',
    'kerukunan_dalam_perbedaan.jpg',
  ];

  const ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 200, enlargeCenterPage: true),
      items: carouselImages.map((String carouselFileName) {
        return Builder(builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.asset('assets/images/carousels/$carouselFileName'),
            );
          },
        );
      }).toList(),
    );
  }
  
}