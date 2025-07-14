import 'package:flutter/material.dart';
import 'package:matrimonal_app/core/constant/color_constant.dart';
import 'package:matrimonal_app/features/match_module/model/match_model.dart';
import 'package:matrimonal_app/features/match_module/view_model/match_service.dart';
import 'package:matrimonal_app/services/sharepref.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String userId;

  const ProfileDetailScreen({super.key, required this.userId});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  MatchModel? profile;
  bool isLoading = true;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  Future<void> fetchProfileDetails() async {
    final token = await SharedPrefs.getToken();

    final result = await MatchService.getProfileDetails(widget.userId, token!);
    if (result != null) {
      setState(() {
        profile = result;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by criteria",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? const Center(child: Text("No profile found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: profile!.galleries != null &&
                  profile!.galleries!.isNotEmpty
                  ? PageView.builder(
                controller: _pageController,
                itemCount: profile!.galleries!.length,
                itemBuilder: (context, index) {
                  final gallery = profile!.galleries![index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://matrimony.sqcreation.site/${gallery.imagePath}",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                            'assets/images/default_image.png',
                            fit: BoxFit.cover,
                          ),
                    ),
                  );
                },
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://matrimony.sqcreation.site/${profile!.profile ?? ""}",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                        'assets/images/default_image.png',
                        fit: BoxFit.fill,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (profile!.galleries != null &&
                profile!.galleries!.length > 1)
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: profile!.galleries!.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.orange,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              profile!.name ?? "--",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _infoItem(Icons.cake, "${profile!.age ?? "--"} yrs"),
                _infoItem(Icons.height, "${profile!.height ?? "--"} cm"),
                _infoItem(Icons.school, profile!.education?.name ?? "--"),
                _infoItem(Icons.location_on, profile!.city?.name ?? "--"),
                _infoItem(Icons.work, profile!.occupation?.name ?? "--"),
              ],
            ),
            const Divider(height: 40),
            const Text("Interested with this profile?",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text("Yes, Interested",
                        style: TextStyle(color: ColorConstant.black)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text("No", style: TextStyle(color: ColorConstant.black)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("About:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(profile!.myself ?? "Not provided",
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            const Text("Basic Details:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text("Email: ${profile!.email ?? "--"}"),
            Text("Mobile: ${profile!.mobile ?? "--"}"),
            Text("Gender: ${profile!.gender ?? "--"}"),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
