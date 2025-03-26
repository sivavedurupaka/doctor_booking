class DoctorCategory {
  final String id;
  final String name;
  final String icon;

  DoctorCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  static List<DoctorCategory> values = [
    DoctorCategory(id: "1", name: "General", icon: "assets/icons/general.png"),
    DoctorCategory(id: "2", name: "Dentist", icon: "assets/icons/dentist.png"),
    DoctorCategory(id: "3", name: "Cardiologist", icon: "assets/icons/cardiologist.png"),
  ];

  static var Dentist;

  static var General;
}
