import 'package:flutter/material.dart';
import 'package:explorasyon_peyi/models/models.dart';
import 'package:explorasyon_peyi/services/api_service.dart';
import 'package:explorasyon_peyi/services/favorite_service.dart';
import 'package:explorasyon_peyi/services/auth_service.dart';
import 'package:explorasyon_peyi/pages/favorites_page.dart';
import 'package:explorasyon_peyi/pages/peyi_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Peyi> lisPeyi = [];
  List<Peyi> lisPeyiFiltre = [];
  bool apChaje = true;
  String? mesajEre;
  TextEditingController controllerRechech = TextEditingController();
  late FavoriteService _sevisFavori;
  late AuthService _sevisOtentifikasyon;
  String? _nonItilizate;

  @override
  void initState() {
    super.initState();
    _sevisFavori = FavoriteService();
    _sevisOtentifikasyon = AuthService();
    _chajePeyi();
    _chajeNonItilizate();
    controllerRechech.addListener(_filtrePeyi);
  }

  Future<void> _chajeNonItilizate() async {
    final itil = await _sevisOtentifikasyon.jwennItilizateAktif();
    setState(() {
      _nonItilizate = itil?.nonItilizate;
    });
  }

  @override
  void dispose() {
    controllerRechech.dispose();
    super.dispose();
  }

  Future<void> _chajePeyi() async {
    setState(() {
      apChaje = true;
      mesajEre = null;
    });

    try {
      List<Peyi> data = await ApiService.jwennToutPeyi();
      setState(() {
        lisPeyi = data;
        lisPeyiFiltre = data;
        apChaje = false;
      });
    } catch (e) {
      setState(() {
        mesajEre = e.toString();
        apChaje = false;
      });
    }
  }

  void _filtrePeyi() {
    final query = controllerRechech.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        lisPeyiFiltre = lisPeyi;
      } else {
        lisPeyiFiltre = lisPeyi.where((peyi) {
          return peyi.name.toLowerCase().contains(query) ||
              peyi.capital.toLowerCase().contains(query) ||
              peyi.region.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _jereDekoneksyon() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dekoneksyon'),
        content: const Text('Ou sèten ou vle dekonekte?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anile'),
          ),
          TextButton(
            onPressed: () async {
              await _sevisOtentifikasyon.dekonekte();
              if (mounted) {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/auth');
              }
            },
            child: const Text('Dekonekte'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌍 Explore Peyi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
            tooltip: 'Favori yo',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.public, size: 50, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    'Explore Peyi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _nonItilizate != null
                        ? 'Bonjou, $_nonItilizate!'
                        : 'Bonjou!',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Paj Akèy'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Favori yo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Dekonekte'),
              onTap: () {
                Navigator.pop(context);
                _jereDekoneksyon();
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (apChaje) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Chajman peyi yo...'),
          ],
        ),
      );
    }
    if (mesajEre != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                mesajEre!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _chajePeyi,
                child: const Text('Reeseye'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controllerRechech,
            decoration: InputDecoration(
              hintText: 'Chèche yon peyi...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Expanded(
          child: lisPeyiFiltre.isEmpty
              ? const Center(child: Text('Pa gen peyi'))
              : ListView.builder(
                  itemCount: lisPeyiFiltre.length,
                  itemBuilder: (context, index) {
                    Peyi country = lisPeyiFiltre[index];
                    return FutureBuilder<bool>(
                      future: _sevisFavori.seFavori(country.name),
                      builder: (context, favSnapshot) {
                        bool seFavoriLocal =
                            favSnapshot.hasData && favSnapshot.data!;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: _buildFlag(country.flagUrl),
                            title: Text(
                              country.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kapital: ${country.capital}'),
                                Text('Rejyon: ${country.region}'),
                                if (country.population != null)
                                  Text(
                                    'Popilasyon: ${country.formatPopulation()}',
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                seFavoriLocal
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: seFavoriLocal ? Colors.red : Colors.grey,
                              ),
                              onPressed: () async {
                                await _sevisFavori.chanjeFavori(country.name);
                                setState(() {});
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PeyiDetailPage(peyi: country),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFlag(String? flagUrl) {
    if (flagUrl == null || flagUrl.isEmpty) {
      return Container(
        width: 50,
        height: 30,
        color: Colors.grey[300],
        child: const Icon(Icons.flag, size: 20),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        flagUrl,
        width: 50,
        height: 30,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 50,
            height: 30,
            color: Colors.grey[300],
            child: const Icon(Icons.flag, size: 20),
          );
        },
      ),
    );
  }
}
