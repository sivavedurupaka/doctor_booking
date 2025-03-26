
import '../models/doctor.dart' as doctor;
import '../models/doctor_category.dart' as category;

class DoctorRepository {
  Future<List<category.DoctorCategory>> fetchDoctorCategories() async {
    return category.DoctorCategory.values;
  }

  Future<List<doctor.Doctor>> fetchDoctors() async {
    return doctor.Doctor.sampleDoctors;
  }

  doctor.Doctor? fetchDoctorById(String doctorId) {
    try {
      return doctor.Doctor.sampleDoctors.firstWhere(
        (doc) => doc.id == doctorId,
      );
    } catch (e) {
      return null; // Return null if the doctor is not found
    }
  }
}

extension on Future<List<doctor.Doctor>> {
  doctor.Doctor? firstWhere(bool Function(dynamic doc) param0) {
    return null;
  }
}
