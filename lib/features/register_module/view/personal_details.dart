import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/features/register_module/view/proffesionaldetail_screen.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/preferences.dart';
import '../model/register_model.dart';
import '../view_model/personal_detail_service.dart';

class PersonalScreen extends StatefulWidget {
  final bool isRegisteredScreen;
  const PersonalScreen({super.key, this.isRegisteredScreen = true});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  List<StateModel> stateList = [];
  List<CityModel> cityList = [];

  StateModel? selectedState;
  CityModel? selectedCity;

  bool isLoading = false;
  bool isStateLoading = true;
  bool isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefilledData();
    _fetchStates();
  }

  Future<void> _loadPrefilledData() async {
      _heightController.text = Preferences.getString('height') ?? '';
      _weightController.text = Preferences.getString('weight') ?? '';
    setState(() => isInitialLoading = false);
  }

  Future<void> _fetchStates() async {
    final res = await http.get(Uri.parse("https://matrimony.sqcreation.site/api/get/state/list"));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List<dynamic> data = json['data'];

      // Convert JSON to list of StateModel first
      final List<StateModel> fetchedStates = data.map((e) => StateModel.fromJson(e)).toList();

      final storedState = Preferences.getString('state', defaultValue: "") != "null"
          ? Preferences.getString('state').replaceAll('"', '')
          : null;


      // Match the stored state from Preferences
      final matchedState = fetchedStates.firstWhere(
            (r) => r.name.trim().toLowerCase() == storedState?.trim().toLowerCase(),
        orElse: () => fetchedStates.first,
      );

      log("Matched: $matchedState ");
      setState(() {
        stateList = fetchedStates;
        selectedState = matchedState;
      });

      if (selectedState != null) {
        _fetchCities(selectedState!.sid);
      }
    }
  }

  Future<void> _fetchCities(int stateId) async {
    final url = Uri.parse("https://matrimony.sqcreation.site/api/get/city/list/$stateId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List data = decoded['data'];

        setState(() {
          cityList = data.map((json) => CityModel.fromJson(json)).toList();
        });

        final city = Preferences.getString('city',defaultValue: '') != "null" ? Preferences.getString('city').replaceAll('"', '') : null;
        final matchCity = cityList.firstWhere(
              (r) => r.name.trim().toLowerCase() == city?.toLowerCase(),
          orElse: () => cityList.first,
        );
        selectedCity = matchCity;

      }
    } catch (e) {
      print("❌ Exception in city API: $e");
    }
  }

  Future<void> _submit() async {
    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();

    if (height.isEmpty || weight.isEmpty || selectedState == null || selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields including state and city")),
      );
      return;
    }

    final token = Preferences.getString(AppConstants.token, defaultValue: "");
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User is not logged in")),
      );
      return;
    }

    setState(() => isLoading = true);

    final success = await updateHeightWeight(
      height: height,
      weight: weight,
      stateId: selectedState!.sid.toString(),
      cityId: selectedCity!.cityid.toString(),
      token: token,
    );

    setState(() => isLoading = false);

    if (success) {
      Preferences.setString('height', height);
      Preferences.setString('weight', weight);
      Preferences.setString('state', selectedState?.name.toString() ?? '');
      Preferences.setString('city', selectedCity?.name.toString() ?? "");

      Preferences.setString(AppConstants.registrationStep, "Fifth");
      if(widget.isRegisteredScreen){
        navigate(ProfessionalDetailsScreen());
      }else{
        showSnackBar("Personal Details Updated Successfully", false);
      }
    } else {
      showSnackBar("Failed to update personal details", true);
    }
  }

  /// Show SnackBar
  Future<void> showSnackBar(String message, bool isError) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isError ? Colors.white : Colors.black),
        ),
        backgroundColor: isError ? Colors.red : Colors.blueAccent,
      ),
    );
  }

  /// Navigate to new screen
  Future<void> navigate(Widget screen) async {
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Personal Details", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        value: 0.6,
                        strokeWidth: 4,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation(Colors.green),
                      ),
                    ),
                    const Text("3 of 5", style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Personal Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Next Step: Professional Details",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height (in cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (in kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            stateList.isEmpty
                ? CircularProgressIndicator()
            : DropdownButtonFormField<StateModel>(
              value: selectedState,
              hint: const Text("Select State"),
              items: stateList.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedState = val;
                  selectedCity = null;
                });
                if (val != null) _fetchCities(val.sid);
              },
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<CityModel>(
              value: selectedCity,
              hint: const Text("Select City"),
              items: cityList.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCity = val;
                });
              },
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(widget.isRegisteredScreen ? "Continue" : "Update", style: TextStyle(color: Colors.white70)),
        ),
      ),
    );
  }
}
