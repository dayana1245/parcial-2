import 'package:flutter/material.dart';
import 'database/db_helper.dart';

class DiaryPage extends StatefulWidget {
  final int userId; // 🔹 Se guarda el id del usuario logueado

  const DiaryPage({super.key, required this.userId});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final _formKey = GlobalKey<FormState>();

  // 🎨 COLORES
  final Color mainColor = const Color(0xFF7C4DFF);
  final Color secondaryColor = const Color(0xFFD1C4E9);
  final Color backgroundColor = const Color(0xFFF5F3FF);

  // CAMPOS DEL DIARIO
  double moodLevel = 5;
  String dailyFeeling = '';

  Future<void> saveDiary() async {
    await DBHelper().insertDiary({
      'userId': widget.userId,
      'moodLevel': moodLevel,
      'dailyFeeling': dailyFeeling,
      'date': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registro guardado exitosamente 💾'),
        backgroundColor: mainColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Bitácora de Ánimo"),
        backgroundColor: mainColor,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("🧠 Estado de Ánimo"),
              SliderField(
                "Nivel de ánimo (1-10)",
                moodLevel,
                1,
                10,
                (v) => setState(() => moodLevel = v),
                mainColor,
              ),
              textField("¿Cómo te sientes hoy?", (v) => dailyFeeling = v),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton.icon(
                  onPressed: saveDiary,
                  icon: const Icon(Icons.save),
                  label: const Text("Guardar registro"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: mainColor,
            fontSize: 18,
          ),
        ),
      );

  Widget textField(String label, Function(String) onChanged) => TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: mainColor),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: onChanged,
      );
}

class SliderField extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;
  final Color color;

  const SliderField(
      this.label, this.value, this.min, this.max, this.onChanged, this.color,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        sliderTheme: SliderThemeData(
          activeTrackColor: color,
          inactiveTrackColor: color.withOpacity(0.3),
          thumbColor: color,
          overlayColor: color.withOpacity(0.1),
          valueIndicatorColor: color,
          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value.toStringAsFixed(0),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
