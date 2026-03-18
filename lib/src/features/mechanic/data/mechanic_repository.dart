import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/mechanic/domain/job_request.dart';
import 'package:auto_ease/src/features/mechanic/data/mock_job_requests.dart';

part 'mechanic_repository.g.dart';

class MechanicRepository {
  Future<JobRequest?> fetchJobRequest(String id) async {
    return kMockJobRequests.firstWhere((job) => job.id == id);
  }

  Stream<JobRequest?> watchJobRequest(String id) {
    return Stream.value(kMockJobRequests.firstWhere((job) => job.id == id));
  }
}

@Riverpod(keepAlive: true)
MechanicRepository mechanicRepository(MechanicRepositoryRef ref) {
  return MechanicRepository();
}

@riverpod
Stream<JobRequest?> jobRequest(JobRequestRef ref, String id) {
  final mechanicRepository = ref.watch(mechanicRepositoryProvider);
  return mechanicRepository.watchJobRequest(id);
}

@riverpod
Future<JobRequest?> jobRequestFuture(JobRequestFutureRef ref, String id) {
  final mechanicRepository = ref.watch(mechanicRepositoryProvider);
  return mechanicRepository.fetchJobRequest(id);
}
