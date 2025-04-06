import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Fixed typo in 'models'
import 'package:mashatel/features/customers/modles/advertisment.dart';
import 'package:mashatel/values/colors.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class CarouselWithIndicator extends StatefulWidget {
  final List<String>? urls;
  final bool isAds;
  final List<Advertisment>? ads;

  const CarouselWithIndicator({
    super.key,
    this.urls,
    this.isAds = false,
    this.ads,
  });

  @override
  State<CarouselWithIndicator> createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  late List<Widget> imageSliders;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    imageSliders = _generateSliderWidgets();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(
          uri,
          mode: url_launcher.LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
        );
      }
    }
  }

  List<Widget> _generateSliderWidgets() {
    if (widget.isAds && widget.ads != null) {
      return widget.ads!.map((item) => _buildAdSlide(item)).toList();
    } else if (widget.urls != null) {
      return widget.urls!.map((url) => _buildImageSlide(url)).toList();
    }
    return [];
  }

  Widget _buildAdSlide(Advertisment ad) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: GestureDetector(
          onTap: () => _launchUrl(ad.url ?? ''),
          child: CachedNetworkImage(
            imageUrl: ad.imageUrl ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => const _LoadingIndicator(),
            errorWidget: (context, url, error) => const _ErrorWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlide(String url) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => const _LoadingIndicator(),
          errorWidget: (context, url, error) => const _ErrorWidget(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (imageSliders.isEmpty) {
      return SizedBox(
        height: size.height / 4,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1.0, // Changed from 1.1 to valid value
            enlargeCenterPage: true,
            height: size.height / 4,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildIndicators(),
        ),
      ],
    );
  }

  List<Widget> _buildIndicators() {
    final items = widget.isAds ? widget.ads : widget.urls;
    if (items == null) return [];

    return items.map((item) {
      final index = items.indexOf(item);
      return Container(
        width: 8.0.w,
        height: 8.0.h,
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _current == index
              ? AppColors.primaryColor
              : AppColors.secondaryElement,
        ),
      );
    }).toList();
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 50,
      ),
    );
  }
}
