import 'dart:developer';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  Future<Map<String, dynamic>?> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    log('Inserting into: $table');
    log('Data: $data');
    final response = await client.from(table).insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>?> upsert(
    String table,
    Map<String, dynamic> data,
  ) async {
    log('Upserting into: $table');
    log('Data: $data');
    final response =
        await client
            .from(table)
            .upsert(data, onConflict: 'title,category_id')
            .select()
            .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final response = await client.from(table).select();
    _handleError(response);
    return (response as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getFiltered(
    String table,
    String column,
    dynamic value,
  ) async {
    final response = await client.from(table).select().eq(column, value);
    _handleError(response);
    return (response as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<dynamic> update(
    String table,
    Map<String, dynamic> data,
    String column,
    dynamic value,
  ) async {
    log('Updating into: $table value : $value');
    final response = await client.from(table).update(data).eq(column, value);
    _handleError(response);
    return response;
  }

  Future<dynamic> delete(String table, String column, dynamic value) async {
    final response = await client.from(table).delete().eq(column, value);
    _handleError(response);
    return response;
  }

  Future<String> uploadFileToBucket({
    required String bucketName,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      // // Upload the file
      // final path = await client.storage
      //     .from(bucketName)
      //     .uploadBinary(
      //       fileName,
      //       fileBytes,
      //       fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      //     );

      final publicUrl = client.storage.from(bucketName).getPublicUrl(fileName);
      return publicUrl;
    } on StorageException catch (e) {
      print('StorageException: ${e.message}');
      throw Exception('Upload failed: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
      throw Exception('Upload failed: $e');
    }
  }

  void _handleError(dynamic response) {
    // If it's an error object with a status or message
    if (response is PostgrestException) {
      throw Exception('Supabase Error: ${response.message}');
    }

    // If response is a map with error
    if (response is Map && response.containsKey('error')) {
      throw Exception('Error: ${response['error']}');
    }
  }
}
