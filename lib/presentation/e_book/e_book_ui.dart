import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/images.dart';
import 'e_book_controller.dart';

class EbookScreen extends GetView<EBookController> {
  const EbookScreen({super.key});

  Widget _buildTopicItem(String iconPath, String title, double itemWidth,  {bool isSelected = false}){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child:  Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: isSelected ? AssetImage(LocalImage.topicImageChoosed) : AssetImage(LocalImage.topicImage),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  width: 34,
                  height: 34,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: itemWidth * 0.03),
            width: itemWidth * 0.5,
            child: SizedBox(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Image.asset(
                    isSelected ? LocalImage.topicNameChoosed : LocalImage.topicName,
                    fit: BoxFit.fill,
                    height: 28,
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.green.shade700 : Colors.black,
                        ),
                      ),
                    ) ,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTopicItem(double itemWidth){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: itemWidth,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.8)
      ),
    );
  }

  Widget _storyItem(double width, String iconPath, String title){
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                ClipRRect(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.bookSmallElibrary),
                        fit: BoxFit.cover
                      )
                    ),
                  )
                ),
                Image.asset(
                  iconPath,
                  width: 34,
                  height: 38,
                )
              ],
            ),
            SizedBox(width: width * 0.11),
            Container(
              width: width * 0.94,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            )
          ]
        )
      ),
    );
  }

  Widget _buildTopicCard(Size size, double cardWidth, double cardHeight) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.only(right: cardWidth * 0.05),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(LocalImage.categoryElibrary),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: cardWidth * 0.14, top: cardHeight * 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Topic",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            ),
          ),
          Container(
            height: cardHeight * 0.62,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                _buildTopicItem(LocalImage.appInfo, 'Family', cardWidth, isSelected: true),
                _buildTopicItem(LocalImage.avatarParent, 'Dreams', cardWidth),
                _buildTopicItem(LocalImage.avatarParent, 'Animals', cardWidth),
                _buildTopicItem(LocalImage.appInfo, 'Nature', cardWidth),
                _buildTopicItem(LocalImage.appInfo, 'Science', cardWidth),
                _buildTopicItem(LocalImage.appInfo, 'History', cardWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedStoriesCard(double width, double height){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.8,
                  height: height * 0.8,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      _storyItem(width * 0.6, LocalImage.appInfo, 'Family’s first stories'),
                      _storyItem(width * 0.6, LocalImage.avatarParent, 'Family’s second stories'),
                      _storyItem(width * 0.6,LocalImage.avatarParent, 'Animals'),
                      _storyItem(width * 0.6,LocalImage.appInfo, 'Nature'),
                      _storyItem(width * 0.6,LocalImage.appInfo, 'Science'),
                      _storyItem(width * 0.6,LocalImage.appInfo, 'History'),
                    ],
                  )
                )
              ],
            ),
          ),
        ]
    );
  }

  Widget _buildVideoBookPlayer(double width, double height, String imagePath){
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        ClipRRect(
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImage.bookElibrary),
                fit: BoxFit.cover
              )
            ),
          )
        ),
        Image.asset(
          imagePath,
          width: width * 0.96,
          height: height,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(LocalImage.backgroundBlue),
              fit: BoxFit.fill
            )
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: size.width * 0.08,
                          height: size.width * 0.08,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(LocalImage.backButton),
                              fit: BoxFit.cover
                            )
                          )
                        ),
                        Container(
                          width: size.width * 0.28,
                          height: size.height * 0.16,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100]?.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          margin: const EdgeInsets.only(top: 0, right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CircleAvatar(
                                radius: size.width * 0.04,
                                backgroundImage: const AssetImage(LocalImage.avatarParent),
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Linoel Messi",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFE53935),
                                    ),
                                  ),
                                  Text(
                                    "Grade 5",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF616161),
                                    )
                                  )
                                ],
                              )
                            ]
                          )
                        )
                      ]
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.01,
                          right: size.width * 0.01,
                          top: size.height * 0.01,
                          bottom: size.height * 0.01
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTopicCard(size, size.width * 0.31, size.height * 0.9),
                            _buildVideoBookPlayer(size.width * 0.33, size.height * 0.74, LocalImage.images),
                            _buildRelatedStoriesCard(size.width * 0.28, size.height * 0.56)
                          ]
                        )
                      )
                    )
                  ]
                )
              )
            ],
          )
        )
      )
    );
  }
}