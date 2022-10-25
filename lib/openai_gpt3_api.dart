import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openai_gpt3_api/files.dart';
import 'completion.dart';
import 'invalid_request_exception.dart';

class GPT3 {
  String apiKey;

  /// Creates the OpenAI GPT-3 helper object.
  ///
  /// You should inject your personal API-key to the program by adding
  /// --dart-define=OPENAI_API_KEY=${OPENAI_API_KEY}
  /// to your flutter arguments.
  GPT3(String apiKey) : apiKey = apiKey;

  Uri _getUri(String apiEndpoint) {
    return Uri.https('api.openai.com', '/v1/$apiEndpoint');
  }

  /// Post a HTTP call to the given [url] with the data object [body].
  Future<Response> _postHttpCall(Uri url, Map<String, dynamic> body) {
    return http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  /// Catch any exceptions from the GPT-3 backend.
  void _catchExceptions(Map<String, dynamic> data) {
    if (data.containsKey('error')) {
      throw InvalidRequestException.fromJson(data['error']);
    }
  }

  /// Post a 'completion' API request to the OpenAI service.
  ///
  /// Throws an [InvalidRequestException] if something goes wrong on the backend.
  ///
  /// For more information, refer to [the OpenAI documentation](https://beta.openai.com/docs/api-reference/completions/create).
  Future<CompletionApiResult> completion(String prompt,
      {int maxTokens = 16,
      num temperature = 1,
      num topP = 1,
      int n = 1,
      bool stream = false,
      int? logProbs,
      bool echo = false,
      Engine engine = Engine.text_davinci_002,
      String? stop,
      num presencePenalty = 0,
      num frequencyPenalty = 0,
      int bestOf = 1,
      Map<String, num>? logitBias}) async {
    var data = CompletionApiParameters(prompt,
        model: engine,
        maxTokens: maxTokens,
        temperature: temperature,
        bestOf: bestOf,
        echo: echo,
        frequencyPenalty: frequencyPenalty,
        logitBias: logitBias,
        logprobs: logProbs,
        n: n,
        presencePenalty: presencePenalty,
        stop: stop,
        stream: stream,
        topP: topP);

    var reqData = data.toJson();
    print(reqData);
    var response = await _postHttpCall(_getUri('completions'), reqData);
    Map<String, dynamic> map = json.decode(response.body);
    _catchExceptions(map);
    return CompletionApiResult.fromJson(map);
  }

  /// Returns a list of files that belong to the user's organization.
  ///
  /// Throws an [InvalidRequestException] if something goes wrong on the backend.
  ///
  /// For more information, refer to [the OpenAI documentation](https://beta.openai.com/docs/api-reference/files/list)
  Future<ListFilesApiResult> listFiles() async {
    var response = await http.get(
      _getUri('files'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    Map<String, dynamic> map = json.decode(response.body);
    _catchExceptions(map);
    return ListFilesApiResult.fromJson(map);
  }

  /// Upload a file that contains document(s) to be used across various endpoints/features.
  ///
  /// Throws an [InvalidRequestException] if something goes wrong on the backend.
  ///
  /// For more information, refer to [the OpenAI documentation](https://beta.openai.com/docs/api-reference/files/upload)
  Future<UploadedFile> uploadFile(String filePath, String purpose) async {
    var request = http.MultipartRequest('POST', _getUri('files'));
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['-F'] = 'purpose=\"$purpose\"';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.files.add(http.MultipartFile.fromString('purpose', purpose));
    var response = await request.send();
    Map<String, dynamic> map =
        json.decode(await response.stream.bytesToString());
    _catchExceptions(map);
    return UploadedFile.fromJson(map);
  }

  /// Returns information about the file with the unique [id].
  ///
  /// Throws an [InvalidRequestException] if something goes wrong on the backend.
  ///
  /// For more information, refer to [the OpenAI documentation](https://beta.openai.com/docs/api-reference/files/retrieve)
  Future<UploadedFile> retrieveFile(String id) async {
    var response = await http.get(
      _getUri('files/$id'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    Map<String, dynamic> map = json.decode(response.body);
    _catchExceptions(map);
    return UploadedFile.fromJson(map);
  }

  /// Delete a file by its [id]. Only owners of organizations can delete files currently.
  ///
  /// Throws an [InvalidRequestException] if something goes wrong on the backend.
  ///
  /// For more information, refer to [the OpenAI documentation](https://beta.openai.com/docs/api-reference/files/delete)
  Future<void> deleteFile(String id) async {
    var response = await http.delete(
      _getUri('files/$id'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );
    Map<String, dynamic> map = json.decode(response.body);
    _catchExceptions(map);
    return;
  }
}

/// The OpenAI GPT-3 engine used in the API call.
///
/// For more information on the engines, refer to [the OpenAI documentation](https://beta.openai.com/docs/engines).
enum Engine {
  @JsonValue('text-ada-001')
  text_ada_001,
  @JsonValue('text-babbage-001')
  text_babbage_001,
  @JsonValue('text-curie-001')
  text_curie_001,
  @JsonValue('text-davinci-002')
  text_davinci_002,
}
