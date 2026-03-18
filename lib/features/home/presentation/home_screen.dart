import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/core/constants/string_manager.dart';
import 'package:go/core/di/service_locator.dart';
import 'package:go/core/widgets/custom_button.dart';
import 'package:go/core/widgets/cutom_form_field.dart';
import 'package:go/core/widgets/logo_with_text.dart';
import 'package:go/features/home/data/models/order_model.dart';
import 'package:go/features/home/data/repository/repo.dart';
import 'package:go/features/home/logic/cubit.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:go/features/home/presentation/shared_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _destinationController;

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(getIt<HomeRepository>())..init(context),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.error) {
            Fluttertoast.showToast(msg: state.error);
          }
        },
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  const Map(),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: ColorManager.navyLight,
                      child: IconButton(
                        onPressed: () => cubit.moveTo(
                          LatLng(
                            state.position!.latitude,
                            state.position!.longitude,
                          ),
                          isCurrentLocation: true,
                          zoom: 17,
                        ),
                        icon: Icon(Icons.gps_fixed, color: Colors.white),
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.25,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: ColorManager.backgroundWhite,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: state.tripStatus == TripStatus.searching
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15.h),
                                      CircularProgressIndicator(),
                                      SizedBox(height: 15.h),
                                      Text(StringManager.waitingForDriver),
                                      const Spacer(),
                                      CustomButton(
                                        text: StringManager.cancelTrip,
                                        onPressed: () => cubit.cancelOrder(),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 4,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: ColorManager.gray500,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    state.route == null
                                        ? LogoWithText(text: '')
                                        : RouteItem(
                                            route: state.route!,
                                            onTap: () => cubit.createOrder(
                                              OrderModel(
                                                destination:
                                                    state.route!.placeName,
                                                distanceKm:
                                                    state.route!.distanceKm,
                                                durationMin:
                                                    state.route!.durationMin,
                                                price: state.route!.price,
                                                destinationLat: state
                                                    .route!
                                                    .points[1]
                                                    .latitude,
                                                destinationLng: state
                                                    .route!
                                                    .points[1]
                                                    .longitude,
                                                passengerId:
                                                    getIt<FirebaseAuth>()
                                                        .currentUser!
                                                        .uid,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(height: 8),
                                    CustomFormField(
                                      hint: StringManager.createTripHint,
                                      controller: _destinationController,
                                      onChanged: (value) =>
                                          cubit.searchPlaces(value ?? ''),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: state.places.length,
                                      itemBuilder: (context, index) {
                                        return PlaceItem(
                                          placeName:
                                              state.places[index].displayName,
                                          onTap: () => cubit.drawRoute(
                                            LatLng(
                                              state.places[index].lat,
                                              state.places[index].lon,
                                            ),
                                            placeName:
                                                state.places[index].displayName,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
