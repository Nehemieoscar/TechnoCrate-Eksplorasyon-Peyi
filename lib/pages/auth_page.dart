import 'package:flutter/material.dart';
import 'package:explorasyon_peyi/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _modeKoneksyon = true; // true => konekte, false => enskri
  final controllerImel = TextEditingController();
  final controllerModpas = TextEditingController();
  final controllerNonItilizate = TextEditingController();
  final _sevisOtentifikasyon = AuthService();
  bool _apChaje = false;
  String? mesajEre;

  @override
  void dispose() {
    controllerImel.dispose();
    controllerModpas.dispose();
    controllerNonItilizate.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() {
      _apChaje = true;
      mesajEre = null;
    });

    try {
      if (_modeKoneksyon) {
        // Koneksyon
        await _sevisOtentifikasyon.konekte(
          controllerImel.text,
          controllerModpas.text,
        );
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        // Enskripsyon
        await _sevisOtentifikasyon.enskri(
          controllerNonItilizate.text,
          controllerImel.text,
          controllerModpas.text,
        );
        if (mounted) {
          // Afficher un message de succès
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kont kreye avèk siksè! Konekte tanpri.'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );

          // Basculer vers le mode connexion
          setState(() {
            _modeKoneksyon = true;
            controllerImel.clear();
            controllerNonItilizate.clear();
            controllerModpas.clear();
            mesajEre = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        mesajEre = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _apChaje = false;
        });
      }
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _modeKoneksyon = !_modeKoneksyon;
      mesajEre = null;
      controllerImel.clear();
      controllerModpas.clear();
      controllerNonItilizate.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.public, size: 80, color: Colors.white),
                      const SizedBox(height: 16),
                      const Text(
                        'Explore Peyi',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dekouvri peyi yo nan mond lan',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre
                        Text(
                          _modeKoneksyon ? 'Konekte' : 'Kre Kont',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nom d'utilisateur (seulement pour inscription)
                        if (!_modeKoneksyon)
                          Column(
                            children: [
                              TextField(
                                controller: controllerNonItilizate,
                                decoration: InputDecoration(
                                  labelText: 'Non Itilizatè',
                                  hintText: 'Antre non itilizatè w',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                        // Email
                        TextField(
                          controller: controllerImel,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Antre email w',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Mot de passe
                        TextField(
                          controller: controllerModpas,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Modpas',
                            hintText: 'Antre modpas w',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Message d'erreur
                        if (mesajEre != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    mesajEre!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (mesajEre != null) const SizedBox(height: 16),

                        // Bouton d'action
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _apChaje ? null : _handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _apChaje
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _modeKoneksyon ? 'Konekte' : 'Kre Kont',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Basculer entre connexion/inscription
                        Center(
                          child: GestureDetector(
                            onTap: _toggleAuthMode,
                            child: RichText(
                              text: TextSpan(
                                text: _modeKoneksyon
                                    ? 'Pa gen kont ankò? '
                                    : 'Gen kont deja? ',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: _modeKoneksyon
                                        ? 'Kre yon kont'
                                        : 'Konekte',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
