import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 24),
            Text(
              'Booking Confirmed!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 48),
            FilledButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
