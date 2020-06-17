import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ImageConfigResponse {
  bool success;
  Result result;

  ImageConfigResponse({
    this.success,
    this.result,
  });

  factory ImageConfigResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : ImageConfigResponse(
          success: convertValueByType(jsonRes['success'], bool, stack: "Root-success"),
          result: Result.fromJson(jsonRes['result']),
        );

  Map<String, dynamic> toJson() => {
        'success': success,
        'result': result,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Result {
  String midBannerImage1;
  int updated;
  String referEntry;
  String assistantHint;
  String midBannerSubtitle1;
  String midBannerTitle2;
  String midBannerTitle1;
  String midBannerLink1;
  String midBannerImage2;
  String midBannerSubtitle2;
  String assistantBicode;
  String assistantWechatId;
  String referBanner;
  String midBannerLink2;
  String midBannerNeedName1;
  String midBannerNeedName2;
  String competitionBannerImage;
  String competitionBannerLink;
  String competitionRankingLink;

  Result(
      {this.midBannerImage1,
      this.updated,
      this.referEntry,
      this.assistantHint,
      this.midBannerSubtitle1,
      this.midBannerTitle2,
      this.midBannerTitle1,
      this.midBannerLink1,
      this.midBannerImage2,
      this.midBannerSubtitle2,
      this.assistantBicode,
      this.assistantWechatId,
      this.referBanner,
      this.midBannerLink2,
      this.midBannerNeedName1,
      this.midBannerNeedName2,
      this.competitionBannerImage,
      this.competitionBannerLink,
      this.competitionRankingLink});

  factory Result.fromJson(jsonRes) => jsonRes == null
      ? null
      : Result(
          midBannerImage1: convertValueByType(jsonRes['mid_banner_image1'], String,
              stack: "Result-mid_banner_image1"),
          updated: convertValueByType(jsonRes['updated'], int, stack: "Result-updated"),
          referEntry:
              convertValueByType(jsonRes['refer_entry'], String, stack: "Result-refer_entry"),
          assistantHint:
              convertValueByType(jsonRes['assistant_hint'], String, stack: "Result-assistant_hint"),
          midBannerSubtitle1: convertValueByType(jsonRes['mid_banner_subtitle1'], String,
              stack: "Result-mid_banner_subtitle1"),
          midBannerTitle2: convertValueByType(jsonRes['mid_banner_title2'], String,
              stack: "Result-mid_banner_title2"),
          midBannerTitle1: convertValueByType(jsonRes['mid_banner_title1'], String,
              stack: "Result-mid_banner_title1"),
          midBannerLink1: convertValueByType(jsonRes['mid_banner_link1'], String,
              stack: "Result-mid_banner_link1"),
          midBannerImage2: convertValueByType(jsonRes['mid_banner_image2'], String,
              stack: "Result-mid_banner_image2"),
          midBannerSubtitle2: convertValueByType(jsonRes['mid_banner_subtitle2'], String,
              stack: "Result-mid_banner_subtitle2"),
          assistantBicode: convertValueByType(jsonRes['assistant_bicode'], String,
              stack: "Result-assistant_bicode"),
          assistantWechatId: convertValueByType(jsonRes['assistant_wechat_id'], String,
              stack: "Result-assistant_wechat_id"),
          referBanner:
              convertValueByType(jsonRes['refer_banner'], String, stack: "Result-refer_banner"),
          midBannerLink2: convertValueByType(jsonRes['mid_banner_link2'], String,
              stack: "Result-mid_banner_link2"),
          midBannerNeedName1: convertValueByType(jsonRes['mid_banner_need_name1'], String,
              stack: "Result-mid_banner_need_name1"),
          midBannerNeedName2: convertValueByType(jsonRes['mid_banner_need_name2'], String,
              stack: "Result-mid_banner_need_name1"),
          competitionBannerImage: convertValueByType(jsonRes['competition_banner_image'], String,
              stack: "Result-competition_banner_image"),
          competitionBannerLink: convertValueByType(jsonRes['competition_banner_link'], String,
              stack: "Result-competition_banner_link"),
          competitionRankingLink: convertValueByType(jsonRes['competition_ranking_link'], String,
              stack: "Result-competition_ranking_link"),
        );

  Map<String, dynamic> toJson() => {
        'mid_banner_image1': midBannerImage1,
        'updated': updated,
        'refer_entry': referEntry,
        'assistant_hint': assistantHint,
        'mid_banner_subtitle1': midBannerSubtitle1,
        'mid_banner_title2': midBannerTitle2,
        'mid_banner_title1': midBannerTitle1,
        'mid_banner_link1': midBannerLink1,
        'mid_banner_image2': midBannerImage2,
        'mid_banner_subtitle2': midBannerSubtitle2,
        'assistant_bicode': assistantBicode,
        'assistant_wechat_id': assistantWechatId,
        'refer_banner': referBanner,
        'mid_banner_link2': midBannerLink2,
        'competition_banner_image': competitionBannerImage,
        'competition_banner_link': competitionBannerLink,
        'competition_ranking_link': competitionRankingLink
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
