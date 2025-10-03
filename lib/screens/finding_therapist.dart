import 'package:flutter/material.dart';
import 'package:mental_healthcare/screens/homescreen.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

// --- Data Models ---
class Therapist {
  final String name;
  final String specialty;
  final String imageUrl;
  // final Icon icon;

  const Therapist({
    required this.name,
    required this.specialty,
    required this.imageUrl,
  });
}

// --- Resources Screen Implementation ---

class FindingTherapist extends StatelessWidget {
  final String title = 'Resources';
  const FindingTherapist({super.key});

  final List<Therapist> mockTherapists = const [
    Therapist(
      name: 'Dr. Alex M.',
      specialty: 'Specializes in anxiety and depression',
      imageUrl:
          'https://www.shutterstock.com/image-photo/portrait-mature-doctor-standing-hospital-260nw-694854949.jpg',
    ),
    Therapist(
      name: 'Dr. Casey M.',
      specialty: 'Specializes in anxiety and depression',
      imageUrl:
          'https://static1.squarespace.com/static/54d50ceee4b05797b34869cf/54de4dcae4b05ae6225b992c/63656097c3d95d53f7295f93/1667589125700/bigstock-Doctor-physician--Isolated-ov-33908342.jpg?format=1500w',
    ),
    Therapist(
      name: 'Dr. Fahad R.',
      specialty: 'Specializes in anxiety and depression',
      imageUrl:
          'https://e7.pngegg.com/pngimages/396/707/png-clipart-health-care-physician-family-medicine-nursing-real-doctor-service-medicine-thumbnail.png',
    ),
    Therapist(
      name: 'Dr. Emily S.',
      specialty: 'Specializes in grief and trauma',
      imageUrl:
          'https://img1.wsimg.com/isteam/stock/3719/:/rs=w:600,h:300,cg:true,m/cr=w:600,h:300',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stripedColor,
      body: Stack(
        children: [
          // const _StripedBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const _CustomAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const _ZipCodeSearch(),
                        const SizedBox(height: 15),

                        // Map Placeholder
                        const _MapPlaceholder(),
                        const SizedBox(height: 25),

                        // Nearby Practitioners Section
                        const Text(
                          'Nearby Practitioners',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Therapist List
                        ...mockTherapists
                            .map(
                              (therapist) => Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: TherapistTile(therapist: therapist),
                              ),
                            )
                            .toList(),

                        const SizedBox(
                          height: 100,
                        ), // Padding above the bottom nav bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(currentScreen: title),
          ),
        ],
      ),
    );
  }
}

// --- Custom Widgets for Resources Screen ---

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 350),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textColorPrimary,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

class _ZipCodeSearch extends StatelessWidget {
  const _ZipCodeSearch();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Enter Zip Code...',
          hintStyle: TextStyle(
            color: AppColors.textColorSecondary.withOpacity(0.6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          border: InputBorder.none,
          suffixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey background for map
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.stripedColor, width: 1),
        image: const DecorationImage(
          image: NetworkImage(
            'https://www.sparxsys.com/sites/default/files/sampleMap.JPG',
          ),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.location_on,
        color: AppColors.error, // Red pin color
        size: 50,
      ),
    );
  }
}

class TherapistTile extends StatelessWidget {
  final Therapist therapist;
  const TherapistTile({required this.therapist});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing profile for ${therapist.name}')),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              // Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  therapist.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Therapist',
                      style: TextStyle(
                        color: AppColors.textColorSecondary,
                        fontSize: 12,
                      ),
                    ),
                    // Name
                    Text(
                      therapist.name,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Specialty
                    Text(
                      therapist.specialty,
                      style: TextStyle(
                        color: AppColors.textColorSecondary.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron Icon
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.textColorSecondary,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
