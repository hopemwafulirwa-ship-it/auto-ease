import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/mechanic/domain/job_request.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';

part 'mechanic_repository.g.dart';

class MechanicRepository {
  final SupabaseClient _supabase;
  MechanicRepository(this._supabase);

  Future<JobRequest?> fetchJobRequest(String id) async {
    final data = await _supabase
        .from('job_requests')
        .select()
        .eq('id', id)
        .single();
    return JobRequest.fromJson(data);
  }

  Stream<JobRequest?> watchJobRequest(String id) {
    return _supabase
        .from('job_requests')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) => data.isNotEmpty ? JobRequest.fromJson(data.first) : null);
  }

  Stream<List<JobRequest>> watchJobRequests() {
    return _supabase
        .from('job_requests')
        .stream(primaryKey: ['id'])
        .order('requested_at', ascending: false)
        .map((data) => data.map((json) => JobRequest.fromJson(json)).toList());
  }

  Future<void> updateJobStatus(String id, JobStatus status) async {
    await _supabase
        .from('job_requests')
        .update({'status': status.name})
        .eq('id', id);
  }
}

@Riverpod(keepAlive: true)
MechanicRepository mechanicRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MechanicRepository(supabase);
}

@riverpod
Stream<JobRequest?> jobRequest(Ref ref, String id) {
  final mechanicRepository = ref.watch(mechanicRepositoryProvider);
  return mechanicRepository.watchJobRequest(id);
}

@riverpod
Stream<List<JobRequest>> jobRequests(Ref ref) {
  final mechanicRepository = ref.watch(mechanicRepositoryProvider);
  return mechanicRepository.watchJobRequests();
}

@riverpod
Future<JobRequest?> jobRequestFuture(Ref ref, String id) {
  final mechanicRepository = ref.watch(mechanicRepositoryProvider);
  return mechanicRepository.fetchJobRequest(id);
}
