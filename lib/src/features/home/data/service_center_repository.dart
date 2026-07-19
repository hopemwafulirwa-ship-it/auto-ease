import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';
import 'package:auto_ease/src/features/home/domain/service_center_model.dart';

part 'service_center_repository.g.dart';

class ServiceCenterRepository {
  final SupabaseClient _supabase;

  ServiceCenterRepository(this._supabase);

  Future<List<ServiceCenter>> fetchServiceCenters() async {
    final response = await _supabase.from('service_centers').select();
    return (response as List)
        .map((json) => ServiceCenter.fromJson(json))
        .toList();
  }

  Stream<List<ServiceCenter>> watchServiceCenters() {
    return _supabase.from('service_centers').stream(primaryKey: ['id']).map(
        (data) => data.map((json) => ServiceCenter.fromJson(json)).toList());
  }
}

@riverpod
ServiceCenterRepository serviceCenterRepository(
    Ref ref) {
  return ServiceCenterRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Stream<List<ServiceCenter>> serviceCenters(Ref ref) {
  return ref.watch(serviceCenterRepositoryProvider).watchServiceCenters();
}
