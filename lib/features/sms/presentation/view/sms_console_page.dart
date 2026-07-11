import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sms_bloc.dart';
import '../bloc/sms_event.dart';
import '../bloc/sms_state.dart';

class SmsConsolePage extends StatefulWidget {
  const SmsConsolePage({super.key});

  @override
  State<SmsConsolePage> createState() => _SmsConsolePageState();
}

class _SmsConsolePageState extends State<SmsConsolePage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SmsBloc>().add(FetchCostBreakdownEvent());
  }

  @override
  void dispose() {
    phoneController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Console')),
      body: BlocConsumer<SmsBloc, SmsState>(
        listener: (context, state) {
          if (state is SmsLoaded && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!)),
            );
            phoneController.clear();
            bodyController.clear();
          } else if (state is SmsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          String totalCost = '0.0000';
          List<dynamic> rows = [];
          bool isLoading = state is SmsLoading;

          if (state is SmsLoaded) {
            totalCost = state.costBreakdown.totalCostSum;
            rows = state.costBreakdown.rows;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            key: const Key('sms_console_padding'),
            child: Column(
              children: [
                TextField(
                  key: const Key('phone_field'),
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  key: const Key('message_field'),
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: 'Message'),
                ),
                const SizedBox(height: 12),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        key: const Key('send_button'),
                        onPressed: () {
                          context.read<SmsBloc>().add(
                                SendSmsEvent(
                                  to: phoneController.text,
                                  body: bodyController.text,
                                ),
                              );
                        },
                        child: const Text('Send'),
                      ),
                const SizedBox(height: 12),
                Text(
                  'Total: €$totalCost',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, i) {
                      final row = rows[i];
                      return ListTile(
                        title: Text(row.provider),
                        trailing: Text('€${row.totalCost}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
