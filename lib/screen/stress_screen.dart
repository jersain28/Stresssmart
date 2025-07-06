import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StressScreen extends StatefulWidget {
  const StressScreen({super.key});

  @override
  State<StressScreen> createState() => _StressScreenState();
}

class _StressScreenState extends State<StressScreen> {
  int valor = 0; // Valor inicial, puedes cambiarlo
  double get progreso => valor / 100;
  String get nivel => obtenerNivelEstres(valor);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseSize = screenWidth < screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(baseSize * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nivel de Estrés',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: baseSize * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: baseSize * 0.04),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: baseSize * 0.40,
                      height: baseSize * 0.40,
                      child: CircularProgressIndicator(
                        value: progreso,
                        strokeWidth: baseSize * 0.04,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$valor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: baseSize * 0.16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: baseSize * 0.01,
                        ),
                        SizedBox(
                          width: baseSize * 0.30, // Limita el ancho máximo del texto
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              nivel,
                              style: TextStyle(
                                color: nivel == 'ALTO'
                                    ? Colors.red
                                    : nivel == 'MODERADO'
                                        ? Colors.orange
                                        : nivel == 'NORMAL'
                                            ? Colors.green
                                            : Colors.blue,
                                fontSize: baseSize * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: baseSize * 0.10),
                Column(
                  children: [
                    Container(
                      width: baseSize * 0.35,
                      height: baseSize * 0.13,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(baseSize * 0.07),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          // Simula una nueva medición aleatoria
                          int nuevoValor = (1 + (99 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)).toInt();
                          setState(() {
                            valor = nuevoValor;
                          });

                          await FirebaseFirestore.instance.collection('mediciones_estres').add({
                            'valor': valor,
                            'nivel': nivel,
                            'fecha': DateTime.now(),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Medición guardada: $nivel',
                                style: const TextStyle(fontSize: 14), // Tamaño de texto más pequeño
                                textAlign: TextAlign.center,
                              ),
                              behavior: SnackBarBehavior.floating, // Flotante, más compacto
                              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Márgenes para smartwatch
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Menos padding
                              duration: const Duration(seconds: 2), // Más corto si lo deseas
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(baseSize * 0.07),
                          ),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          'Medir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: baseSize * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: baseSize * 0.02),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String obtenerNivelEstres(int valor) {
    if (valor >= 1 && valor <= 29) {
      return 'BAJO';
    } else if (valor >= 30 && valor <= 59) {
      return 'NORMAL';
    } else if (valor >= 60 && valor <= 79) {
      return 'MODERADO';
    } else if (valor >= 80 && valor <= 99) {
      return 'ALTO';
    } else {
      return 'DESCONOCIDO';
    }
  }
}
