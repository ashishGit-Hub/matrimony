import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimonial_app/features/register_module/model/proffesional_detail_model.dart';
import 'package:matrimonial_app/features/register_module/view/about_yourself_screen.dart';
import 'package:matrimonial_app/features/register_module/view_model/proffesional_details_service.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';

class ProfessionalDetailsScreen extends StatefulWidget {
  final bool isRegisteredScreen;
  const ProfessionalDetailsScreen({super.key, this.isRegisteredScreen = true});

  @override
  ProfessionalDetailsScreenState createState() => ProfessionalDetailsScreenState();
}

class ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  Education? selectedEducation;
  JobType? selectedJobType;
  CompanyType? selectedCompanyType;
  Occupation? selectedOccupation;
  AnnualIncome? selectedAnnualIncome;

  late Future<void> dataFuture;

  List<Education> educationList = [];
  List<JobType> jobTypeList = [];
  List<CompanyType> companyTypeList = [];
  List<Occupation> occupationList = [];
  List<AnnualIncome> annualIncomeList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dataFuture = loadDropdownData();
  }

  Future<void> loadDropdownData() async {
    try {

      final education = await ProfessionalService.fetchEducationList();
      final jobTypes = await ProfessionalService.fetchJobTypeList();
      final companyTypes = await ProfessionalService.fetchCompanyTypeList();
      final occupations = await ProfessionalService.fetchOccupationList();
      final incomes = await ProfessionalService.fetchAnnualIncomeList();

      setState(() {
        educationList = education;
        jobTypeList = jobTypes;
        companyTypeList = companyTypes;
        occupationList = occupations;
        annualIncomeList = incomes;

        String savedEdu = Preferences.getString('education', defaultValue: '');
        String savedJobType = Preferences.getString('jobType', defaultValue: '');
        String savedCompanyType = Preferences.getString('companyType', defaultValue: '');
        String savedOccupation = Preferences.getString('occupation', defaultValue: '');
        String savedIncome = Preferences.getString('annualIncome', defaultValue: '');


        selectedEducation = education.firstWhere(
              (e) => e.name == savedEdu,
          orElse: () => education.first,
        );
        selectedJobType = jobTypes.firstWhere(
              (j) => j.name == savedJobType,
          orElse: () => jobTypes.first,
        );
        selectedCompanyType = companyTypes.firstWhere(
              (c) => c.name == savedCompanyType,
          orElse: () => companyTypes.first,
        );
        selectedOccupation = occupations.firstWhere(
              (o) => o.name == savedOccupation,
          orElse: () => occupations.first,
        );
        selectedAnnualIncome = incomes.firstWhere(
              (a) => a.range == savedIncome,
          orElse: () => incomes.first,
        );
      });
    } catch (e) {
      print("❌ Error loading dropdown data: $e");
    }
  }

  Future<void> _submit() async {
    if (selectedEducation == null ||
        selectedJobType == null ||
        selectedCompanyType == null ||
        selectedOccupation == null ||
        selectedAnnualIncome == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final success = await ProfessionalService.submitProfessionalDetails(
      educationId: selectedEducation!.eid,
      jobTypeId: selectedJobType!.jtid,
      companyTypeId: selectedCompanyType!.ctid,
      occupationId: selectedOccupation!.oid,
      annualIncomeId: selectedAnnualIncome!.aid,
    );

    setState(() => isLoading = false);

    if (success) {
      // ✅ Save locally for reuse
      Preferences.setString('education', selectedEducation!.name);
      Preferences.setString('jobType', selectedJobType!.name);
      Preferences.setString('companyType', selectedCompanyType!.name);
      Preferences.setString('occupation', selectedOccupation!.name);
      Preferences.setString('annualIncome', selectedAnnualIncome!.range);
      Preferences.setString(AppConstants.registrationStep, "Sixth");
      if(widget.isRegisteredScreen){
        Navigator.push(context, MaterialPageRoute(builder: (_) => AboutYourselfScreen()));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Professional Details updated successfully")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        scrolledUnderElevation: 0,
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text("Professional Details", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder(
          future: dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 30),
                  Text("Please provide your professional details:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  _buildDropdown<Education>(
                    label: "Highest Education",
                    value: selectedEducation,
                    items: educationList,
                    getLabel: (e) => e.name,
                    onChanged: (val) => setState(() => selectedEducation = val),
                  ),
                  SizedBox(height: 15),
                  _buildDropdown<JobType>(
                    label: "Job Type",
                    value: selectedJobType,
                    items: jobTypeList,
                    getLabel: (e) => e.name,
                    onChanged: (val) => setState(() => selectedJobType = val),
                  ),
                  SizedBox(height: 15),
                  _buildDropdown<CompanyType>(
                    label: "Company Type",
                    value: selectedCompanyType,
                    items: companyTypeList,
                    getLabel: (e) => e.name,
                    onChanged: (val) => setState(() => selectedCompanyType = val),
                  ),
                  SizedBox(height: 15),
                  _buildDropdown<Occupation>(
                    label: "Occupation",
                    value: selectedOccupation,
                    items: occupationList,
                    getLabel: (e) => e.name,
                    onChanged: (val) => setState(() => selectedOccupation = val),
                  ),
                  SizedBox(height: 15),
                  _buildDropdown<AnnualIncome>(
                    label: "Annual Income",
                    value: selectedAnnualIncome,
                    items: annualIncomeList,
                    getLabel: (e) => e.range,
                    onChanged: (val) => setState(() => selectedAnnualIncome = val),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: Size(double.infinity, 50),
          ),
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(widget.isRegisteredScreen ? "Continue" : "Update", style: TextStyle(color: Colors.white70)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                value: 0.8,
                strokeWidth: 4,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(Colors.orange),
              ),
            ),
            Text("4 of 5", style: TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Professional Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Next Step: About Yourself", style: TextStyle(color: Colors.grey)),
            Text("Prev. Step: Personal Details", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(label),
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getLabel(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
