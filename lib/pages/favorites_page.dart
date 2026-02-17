import 'package:flutter/material.dart';
import 'package:explorasyon_peyi/models/models.dart';
import 'package:explorasyon_peyi/services/favorite_service.dart';
import 'package:explorasyon_peyi/services/api_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoriteService _sevisFavori;
  List<Peyi> _favoritePeyis = [];
  bool _apChaje = false;

  @override
  void initState() {
    super.initState();
    _sevisFavori = FavoriteService();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _apChaje = true;
    });

    try {
      final favoriteNames = await _sevisFavori.jwennFavori();
      final allPeyis = await ApiService.jwennToutPeyi();

      final favorites = allPeyis
          .where((peyi) => favoriteNames.contains(peyi.name))
          .toList();

      setState(() {
        _favoritePeyis = favorites;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erè pandan chaje favoris: $e')));
      }
    } finally {
      setState(() {
        _apChaje = false;
      });
    }
  }

  Future<void> _removeFavorite(String countryName) async {
    await _sevisFavori.retireFavori(countryName);
    await _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$countryName retire de favoris')));
    }
  }

  Future<void> _clearAllFavorites() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Efase Tout Favori'),
        content: const Text('Ou sèten ou vle efase tout favori yo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anile'),
          ),
          TextButton(
            onPressed: () async {
              await _sevisFavori.efaseToutFavori();
              await _loadFavorites();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tout favori efase')),
                );
              }
            },
            child: const Text('Efase'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori yo'),
        elevation: 0,
        actions: [
          if (_favoritePeyis.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllFavorites,
              tooltip: 'Efase tout favori',
            ),
        ],
      ),
      body: _apChaje
          ? const Center(child: CircularProgressIndicator())
          : _favoritePeyis.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pa gen favori',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoute peyi yo kòm favori pou wè yo isit la',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.explore),
                    label: const Text('Eksplore Peyi yo'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _favoritePeyis.length,
              itemBuilder: (context, index) {
                final peyi = _favoritePeyis[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        peyi.flagUrl,
                        width: 50,
                        height: 35,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 35,
                            color: Colors.grey[300],
                            child: const Icon(Icons.flag, size: 20),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      peyi.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${peyi.capital} • ${peyi.region}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFavorite(peyi.name),
                    )
                  ),
                );
              },
            ),
    );
  }
}
