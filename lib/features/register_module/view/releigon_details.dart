import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimonial_app/providers/user_provider.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimonial_app/utils/sharepref.dart';
import '../model/religion_model.dart';
import '../view_model/religion_detail_service.dart';
import 'personal_details.dart';

class ReligionDetailsScreen extends StatefulWidget {
  const ReligionDetailsScreen({super.key});

  @override
  ReligionDetailsScreenState createState() => ReligionDetailsScreenState();
}

class ReligionDetailsScreenState extends State<ReligionDetailsScreen> {
  Religion? selectedReligion;
  Caste? selectedCaste;

  List<Religion> religionList = [];
  List<Caste> casteList = [];

  bool isLoading = true;
  bool isCasteLoading = false;

  String userReligionName = '';
  String userCasteName = '';

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    initializeData();
  }

  Future<void> initializeData() async {

    try {
      religionList = await fetchReligions();

      if (religionList.isEmpty) throw Exception("No religions found");

      selectedReligion = religionList.first;
      casteList = await fetchCastes(selectedReligion!.rid);
      selectedCaste = casteList.isNotEmpty ? casteList.first : null;

      // ✅ Only prefill if already registered
        final savedReligion = Preferences.getString('religion', defaultValue: "").trim().toLowerCase();
        final savedCaste = Preferences.getString('caste', defaultValue: "").trim().toLowerCase();

        if (savedReligion.isNotEmpty) {
          final matchReligion = religionList.firstWhere(
                (r) => r.name.trim().toLowerCase() == savedReligion,
            orElse: () => religionList.first,
          );
          selectedReligion = matchReligion;
          userReligionName = matchReligion.name;

          casteList = await fetchCastes(matchReligion.rid);
          if (savedCaste.isNotEmpty) {
            selectedCaste = casteList.firstWhere(
                  (c) => c.name.trim().toLowerCase() == savedCaste,
              orElse: () => casteList.first,
            );
            userCasteName = selectedCaste!.name;
          }
        }


      setState(() => isLoading = false);
    } catch (e) {
      print("❌ Error initializing: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _onReligionChanged(Religion newReligion) async {
    setState(() {
      selectedReligion = newReligion;
      selectedCaste = null;
      isCasteLoading = true;
    });

    try {
      casteList = await fetchCastes(newReligion.rid);
      setState(() {
        selectedCaste = casteList.isNotEmpty ? casteList.first : null;
        isCasteLoading = false;
      });
    } catch (e) {
      print("❌ Failed to load castes: $e");
      setState(() {
        casteList = [];
        isCasteLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, userProvider, child){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("Religion Details", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressHeader(),
              const SizedBox(height: 30),
              Text(
                (userReligionName.isNotEmpty && userCasteName.isNotEmpty)
                    ? "Please provide your religion details (Current: $userReligionName - $userCasteName):"
                    : "Please provide your religion details:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Religion Dropdown
              DropdownButtonFormField<Religion>(
                value: selectedReligion,
                decoration: const InputDecoration(
                  labelText: "Religion",
                  border: OutlineInputBorder(),
                ),
                items: religionList.map((religion) {
                  return DropdownMenuItem(
                    value: religion,
                    child: Text(religion.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) _onReligionChanged(value);
                },
              ),
              const SizedBox(height: 20),

              /// Caste Dropdown
              isCasteLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<Caste>(
                value: selectedCaste,
                hint: const Text("Select Caste"),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: casteList.map((caste) {
                  return DropdownMenuItem(
                    value: caste,
                    child: Text(caste.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCaste = value),
              ),
              const Spacer(),

              /// Continue Button
              ElevatedButton(
                onPressed: () async {
                  if (selectedReligion == null || selectedCaste == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select religion and caste")),
                    );
                    return;
                  }

                  final token = await SharedPrefs.getToken() ?? '';
                  if (token.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login token not found. Please login again.")),
                    );
                    return;
                  }

                  final success = await updateReligionDetails(
                    religionId: selectedReligion!.rid,
                    casteId: selectedCaste!.cid,
                    token: token,
                  );

                  if (success) {
                    Preferences.setString('religion', selectedReligion!.name);
                    Preferences.setString('caste', selectedCaste!.name);

                    Preferences.setString(AppConstants.registrationStep, "Fourth");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PersonalScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to update religion details")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Continue", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProgressHeader() {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                value: 0.4,
                strokeWidth: 4,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(Colors.green),
              ),
            ),
            const Text("2 of 5", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Religion Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Next Step: Personal Details", style: TextStyle(color: Colors.grey)),
            Text("Prev. Step: Basic Details", style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
