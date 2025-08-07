import '../models/report_model.dart';

class ReportService {
  // Singleton
  static final ReportService _instance = ReportService._internal();
  factory ReportService() => _instance;
  ReportService._internal();

  final List<Report> _reports = [];

  List<Report> get reports => List.unmodifiable(_reports);

  void addReport(Report report) {
    _reports.add(report);
  }

  void updateStatus(int index, String newStatus) {
    if (index >= 0 && index < _reports.length) {
      _reports[index].status = newStatus;
    }
  }

  void clearReports() {
    _reports.clear();
  }
}
