import 'dart:convert';
import 'package:http/http.dart' as http;

Future sendEmail({
  required String? name,
  required String? email,
  required String subject,
  required String message,
  required String emailSendTo,
}) async {
  final serviceId = 'service_tavxldm';
  final templateId = 'template_zaga4a6';
  final userId = 'user_E0bSTbQqqZZQkK5kmbSRP';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {'origin': 'http//localhost', 'Content-Type': 'application/json'},
    body: jsonEncode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'user_subject': subject,
        'send_to': emailSendTo,
        'user_email': email,
        'user_message': message,
      }
    }),
  );
  print(response.body);
}
