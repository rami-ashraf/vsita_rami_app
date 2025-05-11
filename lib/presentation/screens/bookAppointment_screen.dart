import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/navigation_bar.dart';
import '../../core/rounded_back_button.dart';
import '../../data/doctorData.dart';
import '../../logic/appointment_cubit/appointment_cubit.dart';
import '../../logic/appointment_cubit/appointment_states.dart';
import 'home_screen.dart';


class BookAppointmentScreen extends StatefulWidget {
  final DoctorsData doctor;

  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  late List<String> timeSlots;
  String? selectedTime;
  String selectedType = 'In Person';
  DateTime selectedDate = DateTime.now();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeSlots = generateTimeSlots(widget.doctor.startTime, widget.doctor.endTime);

    if (timeSlots.isEmpty) {
      timeSlots = ["14:00:00 PM", "14:30:00 PM", "15:00:00 PM"];
    }

    selectedTime = timeSlots.isNotEmpty ? timeSlots[0] : null;
  }

  List<String> generateTimeSlots(String start, String end) {
    try {
      final format = DateFormat('HH:mm:ss');
      final DateTime startTime = format.parse(start.split(" ")[0]);
      final DateTime endTime = format.parse(end.split(" ")[0]);

      List<String> slots = [];
      DateTime current = startTime;

      while (current.isBefore(endTime)) {
        final timePart = format.format(current);
        final period = start.split(" ")[1];
        slots.add("$timePart $period");
        current = current.add(const Duration(minutes: 30));
      }

      return slots;
    } catch (e) {
      debugPrint('Time parsing error: $e');
      return [];
    }
  }

  String _formatAppointmentTime(DateTime date, String timeSlot) {
    try {
      final timePart = timeSlot.split(" ")[0];
      final timeFormat = DateFormat('HH:mm:ss');
      final time = timeFormat.parse(timePart);

      final appointmentDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      return DateFormat('EEEE, MMMM d, y h:mm a').format(appointmentDateTime);
    } catch (e) {
      debugPrint('Error formatting appointment time: $e');
      return '';
    }
  }

  String _getNextTimeSlot(String currentSlot) {
    try {
      final format = DateFormat('HH:mm:ss');
      final timePart = currentSlot.split(" ")[0];
      final time = format.parse(timePart);
      final nextTime = time.add(const Duration(minutes: 30));
      return "${format.format(nextTime)} ${currentSlot.split(" ")[1]}";
    } catch (e) {
      debugPrint('Error calculating next time slot: $e');
      return currentSlot;
    }
  }

  void _submitAppointment(BuildContext context) {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    final appointmentTime = _formatAppointmentTime(selectedDate, selectedTime!);
    final appointmentEndTime = _formatAppointmentTime(
        selectedDate,
        _getNextTimeSlot(selectedTime!)
    );

    debugPrint('''
    Booking Details:
    - Doctor ID: ${widget.doctor.id}
    - Date: ${selectedDate.toString()}
    - Time Slot: $selectedTime
    - Formatted Start: $appointmentTime
    - Formatted End: $appointmentEndTime
    - Price: ${widget.doctor.appointPrice}
    - Notes: ${notesController.text}
    ''');

    context.read<BookingCubit>().bookAppointment(
      doctorId: widget.doctor.id,
      appointmentTime: appointmentTime,
      appointmentEndTime: appointmentEndTime,
      appointmentPrice: (widget.doctor.appointPrice)?.toDouble() ?? 0.0,
      notes: notesController.text.isNotEmpty ? notesController.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookAppointmentStates>(
      listener: (context, state) {
        if (state is BookAppointmentErrorState) {
          final errorMessage = state.error.trim().isEmpty ? 'Something went wrong' : state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }

        if (state is BookAppointmentSucessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(
          leading: RoundedBackButton(
            onPressed: () => Navigator.pop(context),
            iconColor: Colors.black,
          ),
          title: const Text(
            "Book Appointment",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: const [CustomPopupMenu()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Select Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(5, (index) {
                    DateTime date = DateTime.now().add(Duration(days: index));
                    bool isSelected = date.day == selectedDate.day;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('E, MMM d').format(date),
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Available time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: timeSlots.map((time) {
                      final isSelected = time == selectedTime;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Appointment Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAppointmentOption("In Person", Icons.people),
                      _buildAppointmentOption("Video Call", Icons.videocam),
                      _buildAppointmentOption("Phone Call", Icons.call),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              BlocBuilder<BookingCubit, BookAppointmentStates>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is BookAppointmentLoadingState
                          ? null
                          : () => _submitAppointment(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is BookAppointmentLoadingState
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Book Appointment",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentOption(String label, IconData icon) {
    final isSelected = selectedType == label;
    return GestureDetector(
      onTap: () => setState(() => selectedType = label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.black)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}