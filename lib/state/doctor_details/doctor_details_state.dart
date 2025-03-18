import 'package:equatable/equatable.dart';
import '../../models/doctor.dart';

enum DoctorDetailsStatus { initial, loading, loaded, error }

class DoctorDetailsState extends Equatable {
  final DoctorDetailsStatus status;
  final Doctor? doctor;  // ✅ Ensure this is present
  final String? errorMessage;

  const DoctorDetailsState({
    this.status = DoctorDetailsStatus.initial,
    this.doctor,
    this.errorMessage,
  });

  DoctorDetailsState copyWith({
    DoctorDetailsStatus? status,
    Doctor? doctor,
    String? errorMessage,
  }) {
    return DoctorDetailsState(
      status: status ?? this.status,
      doctor: doctor ?? this.doctor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, doctor, errorMessage];
}
