import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/core/di/service_locator.dart';
import 'package:go/core/widgets/cutom_form_field.dart';
import 'package:go/core/widgets/logo_with_text.dart';
import 'package:go/features/home/data/models/destnation_model.dart';
import 'package:go/features/home/data/repository/repo.dart';
import 'package:go/features/home/logic/cubit.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:go/features/home/presentation/shared_widgets.dart';

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
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            body: Stack(
              children: [
                const Map(),
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
                        child: Column(
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
                            LogoWithText(text: ''),
                            const SizedBox(height: 8),
                            CustomFormField(
                              hint: 'Where do you want to go?',
                              controller: _destinationController,
                              onChanged: (value) => cubit.searchPlaces(value!),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.places.length,
                              itemBuilder: (context, index) {
                                return PlaceItem(
                                  placeName: state.places[index].displayName,
                                  onTap: () => cubit.moveTo(
                                    DestinationModel(
                                      lat: state.places[index].lat,
                                      lon: state.places[index].lon,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
