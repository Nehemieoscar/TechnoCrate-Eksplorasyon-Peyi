import 'package:flutter/material.dart';
import 'package:explorasyon_peyi/models/models.dart';
import 'package:explorasyon_peyi/services/favorite_service.dart';

class PeyiDetailPage extends StatefulWidget {
  final Peyi peyi;

  const PeyiDetailPage({required this.peyi, super.key});

  @override
  State<PeyiDetailPage> createState() => _PeyiDetailPageState();
}

class _PeyiDetailPageState extends State<PeyiDetailPage> {
  late FavoriteService _sevisFavori;
  bool _seFavori = false;

  @override
  void initState() {
    super.initState();
    _sevisFavori = FavoriteService();
    _tchekeSiFavori();
  }

  Future<void> _tchekeSiFavori() async {
    final isFav = await _sevisFavori.seFavori(widget.peyi.name);
    setState(() {
      _seFavori = isFav;
    });
  }

  Future<void> _chanjeFavori() async {
    await _sevisFavori.chanjeFavori(widget.peyi.name);
    setState(() {
      _seFavori = !_seFavori;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _seFavori
                ? '${widget.peyi.name} ajoute nan favori'
                : '${widget.peyi.name} retire de favori',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peyi.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _seFavori ? Icons.favorite : Icons.favorite_border,
              color: _seFavori ? Colors.red : Colors.white,
            ),
            onPressed: _chanjeFavori,
            tooltip: _seFavori ? 'Retire de favori' : 'Ajoute nan favori',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Drapeau en grand
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: widget.peyi.flagUrl.isNotEmpty
                  ? Image.network(
                      widget.peyi.flagUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.flag,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.flag,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
            ),

            // Infos du pays
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du pays
                  Text(
                    widget.peyi.name,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Carte d'information
                  _buildInfoCard(
                    icon: Icons.location_city,
                    title: 'Kapital',
                    value: widget.peyi.capital,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.public,
                    title: 'Rejyon',
                    value: widget.peyi.region,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),

                  if (widget.peyi.population != null)
                    _buildInfoCard(
                      icon: Icons.people,
                      title: 'Popilasyon',
                      value: widget.peyi.formatPopulation(),
                      color: Colors.orange,
                    ),

                  const SizedBox(height: 24),

                  // Bouton d'action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _chanjeFavori,
                      icon: Icon(
                        _seFavori ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(
                        _seFavori ? 'Retire de Favori' : 'Ajoute nan Favori',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: _seFavori ? Colors.red : Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
