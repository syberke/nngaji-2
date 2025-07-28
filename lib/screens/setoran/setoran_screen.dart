import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/setoran_provider.dart';
import '../../models/setoran_model.dart';
import '../../utils/theme.dart';
import '../../widgets/recent_activity_card.dart';
import 'upload_setoran_screen.dart';

class SetoranScreen extends StatefulWidget {
  const SetoranScreen({super.key});

  @override
  State<SetoranScreen> createState() => _SetoranScreenState();
}

class _SetoranScreenState extends State<SetoranScreen> {
  @override
  void initState() {
    super.initState();
    _loadSetoran();
  }

  void _loadSetoran() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      Provider.of<SetoranProvider>(context, listen: false)
          .fetchSetoranBySiswa(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setoran Hafalan'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SetoranProvider>(
        builder: (context, setoranProvider, child) {
          if (setoranProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (setoranProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    setoranProvider.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.gray600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadSetoran,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadSetoran();
            },
            child: setoranProvider.setoranList.isEmpty
                ? _buildEmptyState()
                : _buildSetoranList(setoranProvider.setoranList),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UploadSetoranScreen(),
            ),
          ).then((_) => _loadSetoran());
        },
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Setoran Baru'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 60),
        Icon(
          Icons.upload_outlined,
          size: 80,
          color: AppTheme.gray400,
        ),
        const SizedBox(height: 24),
        Text(
          'Belum Ada Setoran',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Mulai setoran hafalan atau murojaah pertama Anda dengan menekan tombol di bawah.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.gray600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UploadSetoranScreen(),
              ),
            ).then((_) => _loadSetoran());
          },
          icon: const Icon(Icons.add),
          label: const Text('Buat Setoran Pertama'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSetoranList(List<SetoranModel> setoranList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: setoranList.length,
      itemBuilder: (context, index) {
        final setoran = setoranList[index];
        return RecentActivityCard(setoran: setoran);
      },
    );
  }
}