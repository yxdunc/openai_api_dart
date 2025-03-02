// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CompletionApiParametersToJson(
    CompletionApiParameters instance) {
  final val = <String, dynamic>{
    'prompt': instance.prompt,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('suffix', instance.suffix);
  writeNotNull('user', instance.user);
  val['model'] = _$EngineEnumMap[instance.model];
  val['max_tokens'] = instance.maxTokens;
  val['temperature'] = instance.temperature;
  val['top_p'] = instance.topP;
  val['n'] = instance.n;
  val['stream'] = instance.stream;
  writeNotNull('logprobs', instance.logprobs);
  val['echo'] = instance.echo;
  writeNotNull('stop', instance.stop);
  val['presence_penalty'] = instance.presencePenalty;
  val['frequency_penalty'] = instance.frequencyPenalty;
  val['best_of'] = instance.bestOf;
  writeNotNull('logit_bias', instance.logitBias);
  return val;
}

const _$EngineEnumMap = {
  Engine.text_ada_001: 'text-ada-001',
  Engine.text_babbage_001: 'text-babbage-001',
  Engine.text_curie_001: 'text-curie-001',
  Engine.text_davinci_002: 'text-davinci-002',
};

CompletionApiResult _$CompletionApiResultFromJson(Map<String, dynamic> json) =>
    CompletionApiResult(
      json['id'] as String,
      json['object'] as String,
      json['created'] as int,
      json['model'] as String,
      (json['choices'] as List<dynamic>)
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompletionApiResultToJson(
        CompletionApiResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'model': instance.model,
      'choices': instance.choices,
    };

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      json['text'] as String,
      json['index'] as int,
      json['finish_reason'] as String,
      logprobs: json['logprobs'] == null
          ? null
          : Logprobs.fromJson(json['logprobs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'text': instance.text,
      'index': instance.index,
      'logprobs': instance.logprobs,
      'finish_reason': instance.finishReason,
    };

Logprobs _$LogprobsFromJson(Map<String, dynamic> json) => Logprobs(
      (json['text_offset'] as List<dynamic>).map((e) => e as int).toList(),
      (json['token_logprobs'] as List<dynamic>).map((e) => e as num).toList(),
      (json['tokens'] as List<dynamic>).map((e) => e as String).toList(),
      (json['top_logprobs'] as List<dynamic>)
          .map((e) => Map<String, num>.from(e as Map))
          .toList(),
    );

Map<String, dynamic> _$LogprobsToJson(Logprobs instance) => <String, dynamic>{
      'text_offset': instance.textOffset,
      'token_logprobs': instance.tokenLogprobs,
      'tokens': instance.tokens,
      'top_logprobs': instance.topLogprobs,
    };
