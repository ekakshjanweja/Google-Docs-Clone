import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/constants/constants.dart';
import 'package:google_docs_clone/models/document_model.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:http/http.dart';

final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    client: Client(),
  ),
);

class DocumentRepository {
  final Client _client;

  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred',
      data: null,
    );
    try {
      var response = await _client.post(
        Uri.parse('$host/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );
      switch (response.statusCode) {
        case 200:
          error = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(response.body),
          );
          break;
        default:
          error = ErrorModel(
            error: response.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel?> getDocuments(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred',
      data: null,
    );
    try {
      var response = await _client.get(
        Uri.parse('$host/docs/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      switch (response.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(
                  jsonDecode(response.body)[i],
                ),
              ),
            );
            error = ErrorModel(
              error: null,
              data: documents,
            );
          }

          break;
        default:
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel?> updateDocumentTitle({
    required String token,
    required String id,
    required String title,
  }) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred',
      data: null,
    );
    try {
      var response = await _client.post(
        Uri.parse('$host/doc/title'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'id': id,
        }),
      );
      switch (response.statusCode) {
        case 200:
          error = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(response.body),
          );
          break;
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel?> getDocument(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred',
      data: null,
    );
    try {
      var response = await _client.get(
        Uri.parse('$host/docs/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      switch (response.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(
                  jsonDecode(response.body)[i],
                ),
              ),
            );
            error = ErrorModel(
              error: null,
              data: documents,
            );
          }

          break;
        default:
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> getDocumentById(
    String token,
    String id,
  ) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred',
      data: null,
    );
    try {
      var response = await _client.get(
        Uri.parse('$host/doc/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      switch (response.statusCode) {
        case 200:
          error = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(response.body),
          );
          break;
        default:
          throw 'This document does not exist.';
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }
}
