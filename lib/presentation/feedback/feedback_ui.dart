import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/feedback/feedback_controller.dart';
import 'package:EngKid/utils/app_color.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackController controller = Get.find<FeedbackController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/feedback_form.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(size),
                  SizedBox(height: size.height * 0.03),
                  _buildStorySelection(size),
                  SizedBox(height: size.height * 0.03),
                  _buildRatingSection(size),
                  SizedBox(height: size.height * 0.03),
                  _buildCommentSection(size),
                  SizedBox(height: size.height * 0.04),
                  _buildSubmitButton(size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: size.width * 0.12,
            height: size.width * 0.12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.primary,
              size: size.width * 0.06,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: Text(
            'Gửi Phản Hồi',
            style: TextStyle(
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStorySelection(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn bài đọc *',
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w600,
              color: AppColor.blue,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          _buildSearchInput(size),
          _buildSearchResults(size),
        ],
      ),
    );
  }

  Widget _buildSearchInput(Size size) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        color: AppColor.lightBlue.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài đọc...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: size.width * 0.04,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(size.width * 0.04),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor.primary,
                  size: size.width * 0.05,
                ),
              ),
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.black87,
              ),
              onTap: () {
                if (controller.searchController.text.isNotEmpty) {
                  controller.showSearchResults.value = true;
                }
              },
            ),
          ),
          Obx(() {
            if (controller.isSearching.value) {
              return Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: SizedBox(
                  width: size.width * 0.04,
                  height: size.width * 0.04,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primary,
                  ),
                ),
              );
            } else if (controller.searchController.text.isNotEmpty) {
              return IconButton(
                onPressed: controller.clearSearch,
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey[600],
                  size: size.width * 0.05,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults(Size size) {
    return Obx(() {
      if (!controller.showSearchResults.value ||
          controller.searchResults.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.only(top: size.height * 0.01),
        constraints: BoxConstraints(
          maxHeight: size.height * 0.2,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.primary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(size.width * 0.03),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final reading = controller.searchResults[index];
            return ListTile(
              title: Text(
                reading.name,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'ID: ${reading.id}',
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: Colors.grey[600],
                ),
              ),
              leading: Container(
                width: size.width * 0.08,
                height: size.width * 0.08,
                decoration: BoxDecoration(
                  color: AppColor.lightBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                ),
                child: Icon(
                  Icons.book,
                  color: AppColor.primary,
                  size: size.width * 0.04,
                ),
              ),
              onTap: () => controller.selectStory(reading),
              dense: true,
            );
          },
        ),
      );
    });
  }

  Widget _buildRatingSection(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đánh giá *',
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w600,
              color: AppColor.blue,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => controller.setRating(index + 1),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      child: Icon(
                        index < controller.rating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: index < controller.rating.value
                            ? Colors.amber
                            : Colors.grey[400],
                        size: size.width * 0.08,
                      ),
                    ),
                  );
                }),
              )),
          SizedBox(height: size.height * 0.01),
          Obx(() => Center(
                child: Text(
                  controller.rating.value > 0
                      ? '${controller.rating.value}/5 sao'
                      : 'Chưa đánh giá',
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCommentSection(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhận xét',
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w600,
              color: AppColor.blue,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(size.width * 0.03),
              color: AppColor.lightBlue.withOpacity(0.3),
            ),
            child: TextFormField(
              controller: controller.commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Chia sẻ ý kiến của bạn về ứng dụng...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: size.width * 0.04,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(size.width * 0.04),
              ),
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(Size size) {
    return Center(
      child: Obx(() => GestureDetector(
            onTap:
                controller.isLoading.value ? null : controller.submitFeedback,
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.07,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: controller.isLoading.value
                      ? [Colors.grey, Colors.grey[400]!]
                      : [AppColor.primary, AppColor.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(size.width * 0.08),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: controller.isLoading.value
                    ? SizedBox(
                        width: size.width * 0.06,
                        height: size.width * 0.06,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Gửi Phản Hồi',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          )),
    );
  }
}
