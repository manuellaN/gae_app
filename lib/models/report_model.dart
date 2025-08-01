import 'dart:io';

class Report {
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final List<File> images;

  Report({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.images,
  });
}
