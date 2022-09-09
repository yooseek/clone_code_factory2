import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/rating/model/rating_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  // NetworkImage
  // AssetImage
  final ImageProvider avatarImage;
  // 리뷰 리스트 이미지
  final List<Image> images;
  // 별점
  final int rating;
  // 이메일
  final String email;
  // 리뷰내용
  final String content;

  const RatingCard({
    Key? key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  }) : super(key: key);

  factory RatingCard.fromModel({required RatingModel model}) {
    return RatingCard(
      avatarImage: NetworkImage(
          model.user.imageUrl
      ),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      rating: model.rating,
      email: model.user.username,
      content: model.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (images.length > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0,),
            child: SizedBox(
              height: 100,
              child: _Images(
                images: images,
              ),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header({
    Key? key,
    required this.avatarImage,
    required this.email,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      // 좌 우로 스크롤 할 수 있는 형태
      scrollDirection: Axis.horizontal,
      children:
          // import 'package:collection/collection.dart';
          // map을 이용할 때 인덱스까지 가져올 수 있다.
          images
              .mapIndexed(
                (index, e) => Padding(
                  padding: EdgeInsets.only(
                      right: index == images.length - 1 ? 0 : 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: e,
                  ),
                ),
              )
              .toList(),
    );
  }
}
