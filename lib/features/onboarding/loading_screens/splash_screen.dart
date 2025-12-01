import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/constants/image_strings.dart';
import 'language_selection_page.dart';

class SplashScreen extends StatefulWidget
{
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin
{
    late AnimationController _controller;
    late Animation<double> _animation;

    @override
    void initState()
    {
        super.initState();

        _controller = AnimationController(
            vsync: this,
            duration: const Duration(seconds: 3),
        );

        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
        ..addListener(()
            {
                setState(()
                    {
                    }
                );
            }
        );

        _controller.forward();

        Timer(const Duration(seconds: 4), ()
            {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LanguageSelectionScreen(),
                    ),
                );
            }
        );
    }

    @override
    void dispose()
    {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                    children: [
                        const Spacer(flex: 2),
                        Image.asset(
                            Images.applogo,
                            width: 200,
                        ),

                        const Spacer(flex: 3),

                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                                value: _animation.value,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD80015)),
                                minHeight: 6,
                            ),
                        ),

                        const SizedBox(height: 70),
                    ],
                ),
            ),
        );
    }
}
