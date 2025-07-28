import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/setoran_model.dart';
import '../utils/theme.dart';

class RecentActivityCard extends StatelessWidget {
  final SetoranModel setoran;

  const RecentActivityCard({
    super.key,
    required this.setoran,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor().withOpacity(0.1),
          child: Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: 20,
          ),
        ),
        title: Text(
          '${setoran.jenisDisplayName} - ${setoran.surah}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(setoran.statusDisplayName),
            Text(
              DateFormat('dd MMM yyyy').format(setoran.tanggal),
              style: TextStyle(
                color: AppTheme.gray500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: setoran.status == SetoranStatus.diterima
            ? Chip(
                label: Text(
                  '+${setoran.poin} poin',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppTheme.successGreen,
              )
            : null,
      ),
    );
  }

  Color _getStatusColor() {
    switch (setoran.status) {
      case SetoranStatus.pending:
        return AppTheme.warningOrange;
      case SetoranStatus.diterima:
        return AppTheme.successGreen;
      case SetoranStatus.ditolak:
        return AppTheme.errorRed;
      case SetoranStatus.selesai:
        return AppTheme.primaryGreen;
    }
  }

  IconData _getStatusIcon() {
    switch (setoran.status) {
      case SetoranStatus.pending:
        return Icons.pending;
      case SetoranStatus.diterima:
        return Icons.check_circle;
      case SetoranStatus.ditolak:
        return Icons.cancel;
      case SetoranStatus.selesai:
        return Icons.done_all;
    }
  }
}