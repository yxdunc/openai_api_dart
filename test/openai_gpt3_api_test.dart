import 'package:openai_api/invalid_request_exception.dart';
import 'package:openai_api/openai_gpt3_api.dart';
import 'package:test/test.dart';

void main() {
  GPT3? api;
  // Add your API key by adding the following command to your flutter arguments
  // --dart-define=OPENAI_API_KEY=${OPENAI_API_KEY}
  const OPENAI_API_KEY =
      String.fromEnvironment('OPENAI_API_KEY', defaultValue: 'no key found in env');

  setUp(() {
    api = GPT3(OPENAI_API_KEY);
  });

  group('Completion API', () {
    test('ada parameter calls the ada engine', () async {
      var result = await api!.completion('How to write efficient tests?',
          maxTokens: 1, engine: Engine.text_ada_001);
      expect(result.model, 'text-ada-001');
    });

    test('babbage parameter calls the babbage engine', () async {
      var result = await api!.completion('How to write efficient tests?',
          maxTokens: 1, engine: Engine.text_babbage_001);
      expect(result.model, 'text-babbage-001');
    });

    test('retrieve correctly encoded response', () async {
      var result = await api!.completion('I digest utf8', maxTokens: 1, engine: Engine.text_babbage_001);
    });

    test('logprobs are not null when the parameter logProbs is given.',
        () async {
      var result = await api!.completion('How to write efficient tests?',
          maxTokens: 1, engine: Engine.text_babbage_001, logProbs: 2);
      expect(result.choices.first.logprobs, isNotNull);
    });

    test('invalid API key throws an InvalidRequestException', () async {
      api = GPT3('123123');
      expect(
          () => api!.completion('How to write efficient tests?',
              engine: Engine.text_babbage_001),
          throwsA(isA<InvalidRequestException>()));
    });
  });

  group('Files API', () {
    test('list files returns', () async {
      var result = await api!.listFiles();
      print(result.data.toString());
    });

    test('upload file uploads a file', () async {
      // Initial amount of files
      var initialResult = await api!.listFiles();
      var fileAmount = initialResult.data.length;
      var result =
          await api!.uploadFile('test_resources/test.jsonl', 'answers');
      var endResult = await api!.listFiles();
      expect(endResult.data.length - 1 == fileAmount, isTrue);

      // Clean up, API needs a while to process file.
      await (Future.delayed(const Duration(seconds: 10))
          .then((value) => api!.deleteFile(result.id)));
    });

    test('deleting a file deletes the file', () async {
      // Initial amount of files
      var initialResult = await api!.listFiles();
      var result =
          await api!.uploadFile('test_resources/test.jsonl', 'answers');

      // API needs a while to process file.
      await (Future.delayed(const Duration(seconds: 10))
          .then((value) => api!.deleteFile(result.id)));
      var endResult = await api!.listFiles();
      initialResult.data.sort((a, b) => a.id.compareTo(b.id));
      endResult.data.sort((a, b) => a.id.compareTo(b.id));
      for (var i = 0; i < initialResult.data.length; i++) {
        expect(initialResult.data[i].id, equals(endResult.data[i].id));
      }
    });

    test('retreiving a file works', () async {
      // Upload a test file
      var result =
          await api!.uploadFile('test_resources/test.jsonl', 'answers');

      var retrieve = await api!.retrieveFile(result.id);
      expect(retrieve.id, equals(result.id));
      // Clean up, API needs a while to process file.
      await (Future.delayed(const Duration(seconds: 10))
          .then((value) => api!.deleteFile(result.id)));
    });

    test(
        'invalid API key throws an InvalidRequestException when trying to delete a file',
        () async {
      api = GPT3('123123');
      expect(() => api!.deleteFile('test'),
          throwsA(isA<InvalidRequestException>()));
    });

    test(
        'invalid API key throws an InvalidRequestException when trying to upload a file',
        () async {
      api = GPT3('123123');
      expect(() => api!.uploadFile('test_resources/test.jsonl', 'answers'),
          throwsA(isA<InvalidRequestException>()));
    });

    test(
        'invalid API key throws an InvalidRequestException when trying to list your files',
        () async {
      api = GPT3('123123');
      expect(() => api!.listFiles(), throwsA(isA<InvalidRequestException>()));
    });

    test(
        'invalid API key throws an InvalidRequestException when trying to retrieve a file',
        () async {
      api = GPT3('123123');
      expect(() => api!.retrieveFile('test'),
          throwsA(isA<InvalidRequestException>()));
    });
  });
}
