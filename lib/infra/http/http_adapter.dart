import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    final defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final Map<String, String> finalHeaders =
        (headers?.cast<String, String>() ?? {})..addAll(defaultHeaders);
    Response? response;
    try {
      if (method == 'post') {
        response = await client.post(
          Uri.parse(url),
          headers: finalHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      } else if (method == 'get') {
        response = await client.get(Uri.parse(url), headers: finalHeaders);
      }
    } catch (_) {
      throw HttpError.serverError;
    }

    if (response == null) {
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return {};
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
