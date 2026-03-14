import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
	const ErrorState({required this.message, required this.onRetry, super.key});

	final String message;
	final VoidCallback onRetry;

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Padding(
				padding: const EdgeInsets.all(24),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						Text(
							message,
							textAlign: TextAlign.center,
						),
						const SizedBox(height: 12),
						ElevatedButton(
							onPressed: onRetry,
							child: const Text('Retry'),
						),
					],
				),
			),
		);
	}
}