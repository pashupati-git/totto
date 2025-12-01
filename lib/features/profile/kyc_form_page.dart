import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totto/data/models/kyc_model.dart';
import 'package:totto/features/home/home_screen.dart';
import 'package:totto/features/profile/providers/kyc_provider.dart';
import 'package:totto/l10n/app_localizations.dart';

import '../../common/appbar/common_app_bar.dart';
import '../../common/custom_text_field.dart';
import '../../common/primary_button.dart';

class KycPageGate extends ConsumerWidget
{
    const KycPageGate({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final kycStatusAsync = ref.watch(kycStatusProvider);

        return kycStatusAsync.when(
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (err, stack) => Scaffold(appBar: AppBar(title: Text(l10n.kycErrorTitle)), body: Center(child: Text(l10n.kycErrorLoadingStatus(err.toString())))),
            data: (kycModel)
            {
                if (kycModel == null || kycModel.isRejected)
                {
                    return KycFormPage(wasRejected: kycModel?.isRejected ?? false);
                }
                if (kycModel.isVerified)
                {
                    return _AlreadyVerifiedView(kycModel: kycModel);
                }
                return const _PendingVerificationView();
            },
        );
    }
}

class KycFormPage extends ConsumerStatefulWidget
{
    final bool wasRejected;
    const KycFormPage({super.key, this.wasRejected = false});

    @override
    ConsumerState<KycFormPage> createState() => _KycFormPageState();
}

class _KycFormPageState extends ConsumerState<KycFormPage>
{
    final PageController _pageController = PageController();
    int _currentStep = 0;

    @override
    void dispose()
    {
        _pageController.dispose();
        super.dispose();
    }

    void _nextPage()
    {
        if (_currentStep < 3)
        {
            _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
            );
        }
    }

    void _submitKyc() async
    {
        final l10n = AppLocalizations.of(context)!;
        FocusScope.of(context).unfocus();
        try
        {
            await ref.read(kycProvider.notifier).submitOrUpdateKyc();
            if (mounted)
            {
                _pageController.animateToPage(4, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
            }
        }
        catch (e)
        {
            if (mounted)
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.kycSubmissionFailed(e.toString())), backgroundColor: Colors.red),
                );
            }
        }
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                shape: const Border(),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(l10n.kycFormTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                actions: const[SizedBox(width: 56)],
            ),
            body: Column(
                children: [
                    if (widget.wasRejected)
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: Colors.red.shade100,
                        child: Text(
                            l10n.kycRejectedMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w500),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                        child: _KycProgressStepper(currentStep: _currentStep),
                    ),
                    Expanded(
                        child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (page) => setState(() => _currentStep = page),
                            children: [
                                _BasicInfoStep(onNext: _nextPage),
                                _AddressStep(onNext: _nextPage),
                                _IdentityStep(onNext: _nextPage),
                                _BusinessDetailsStep(onSubmit: _submitKyc),
                                const _SuccessStep(),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}

class _AlreadyVerifiedView extends StatelessWidget
{
    final KycModel kycModel;
    const _AlreadyVerifiedView({required this.kycModel});

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                shape: const Border(),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(l10n.kycVerifiedTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                actions: const[SizedBox(width: 56)],
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Icon(Icons.verified_user, color: Colors.green, size: 80),
                            const SizedBox(height: 24),
                            Text(l10n.kycAlreadyVerified, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            PrimaryButton(text: l10n.updateKycInformation, onPressed: ()
                                {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const KycFormPage())
                                    );
                                }
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

class _PendingVerificationView extends StatelessWidget
{
    const _PendingVerificationView();

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                shape: const Border(),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(l10n.kycSubmittedTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                actions: const[SizedBox(width: 56)],
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Icon(Icons.hourglass_top_rounded, color: Colors.orange, size: 80),
                            const SizedBox(height: 24),
                            Text(l10n.kycSubmittedTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Text(
                                l10n.kycPendingReview,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

class _KycProgressStepper extends StatelessWidget
{
    const _KycProgressStepper({required this.currentStep});
    final int currentStep;
    @override
    Widget build(BuildContext context)
    {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (index)
                {
                    bool isActive = index <= currentStep;
                    return Row(children: [CircleAvatar(radius: 12,
                                backgroundColor: isActive ? Colors.red : Colors.grey.shade300, child: Text('${index + 1}',
                                    style: const TextStyle(color: Colors.white, fontSize: 12))),
                            if (index < 3) Container(width: 40, height: 2,
                                color: isActive ? Colors.red : Colors.grey.shade300)]);
                }
            ));
    }
}

abstract class KycStepWidget extends ConsumerWidget
{
    const KycStepWidget({super.key});
    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final kycState = ref.watch(kycProvider);
        return kycState.when(
            data: (kycData) => buildForm(context, ref, kycData),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack)
            {
                final kycData = kycState.value;
                if (kycData != null) return buildForm(context, ref, kycData);
                return Center(child: Text(l10n.kycErrorLoadingData(err.toString())));
            },
        );
    }
    Widget buildForm(BuildContext context, WidgetRef ref, KycModel kycData);
}

class _BasicInfoStep extends KycStepWidget
{
    final VoidCallback onNext;
    const _BasicInfoStep({required this.onNext});
    @override
    Widget buildForm(BuildContext context, WidgetRef ref, KycModel kycData)
    {
        return _BasicInfoForm(onNext: onNext);
    }
}

class _BasicInfoForm extends ConsumerStatefulWidget
{
    const _BasicInfoForm({required this.onNext});
    final VoidCallback onNext;
    @override
    ConsumerState<_BasicInfoForm> createState() => _BasicInfoFormState();
}

class _BasicInfoFormState extends ConsumerState<_BasicInfoForm>
{
    late final TextEditingController _fullNameController, _dobController, _phoneController, _emailController;
    @override
    void initState()
    {
        super.initState();
        final kycData = ref.read(kycProvider).value;
        _fullNameController = TextEditingController(text: kycData?.fullName ?? '');
        _dobController = TextEditingController();
        _phoneController = TextEditingController(text: kycData?.phoneNumber ?? '');
        _emailController = TextEditingController(text: kycData?.emailAddress ?? '');
        if (kycData?.dateOfBirth != null)
        {
            _dobController.text = "${kycData!.dateOfBirth!.day}/${kycData.dateOfBirth!.month}/${kycData.dateOfBirth!.year}";
        }
    }
    @override
    void dispose()
    {
        _fullNameController.dispose();
        _dobController.dispose();
        _phoneController.dispose();
        _emailController.dispose();
        super.dispose();
    }
    Future<void> _selectDate(BuildContext context) async
    {
        final kycNotifier = ref.read(kycProvider.notifier);
        final kycData = ref.read(kycProvider).value!;
        final DateTime? picked = await showDatePicker(context: context, initialDate: kycData.dateOfBirth ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
        if (picked != null)
        {
            kycNotifier.updateData(kycData.copyWith(dateOfBirth: picked));
            _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        }
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final kycNotifier = ref.read(kycProvider.notifier);
        final kycData = ref.watch(kycProvider).value!;

        String? genderValue;
        switch (kycData.gender)
        {
            case 'M': genderValue = l10n.kycMale;
                break;
            case 'F': genderValue = l10n.kycFemale;
                break;
            case 'O': genderValue = l10n.kycOther;
                break;
            default: genderValue = kycData.gender;
        }

        return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(l10n.kycBasicInformation, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _fullNameController, hintText: l10n.kycFullName, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(fullName: val))),
                    const SizedBox(height: 16),
                    TextFormField(controller: _dobController, readOnly: true, onTap: () => _selectDate(context), decoration: InputDecoration(hintText: l10n.kycDobHint, border: const OutlineInputBorder(), suffixIcon: Padding(padding: const EdgeInsets.all(6.0), child: Image.asset('assets/logos/calendar_icon.png', width: 28, height: 28)))),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                        value: genderValue,
                        decoration: InputDecoration(hintText: l10n.kycChooseGender, border: const OutlineInputBorder()),
                        items: [l10n.kycMale, l10n.kycFemale, l10n.kycOther].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                        onChanged: (val)
                        {
                            String genderCode = '';
                            if (val == l10n.kycMale) genderCode = 'M';
                            if (val == l10n.kycFemale) genderCode = 'F';
                            if (val == l10n.kycOther) genderCode = 'O';
                            kycNotifier.updateData(kycData.copyWith(gender: genderCode));
                        },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _phoneController, hintText: l10n.kycAddPhoneNumber, keyboardType: TextInputType.phone, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(phoneNumber: val))),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _emailController, hintText: l10n.kycAddEmailAddress, keyboardType: TextInputType.emailAddress, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(emailAddress: val))),
                    const SizedBox(height: 32),
                    PrimaryButton(text: l10n.kycNextButton, onPressed: widget.onNext),
                ],
            ),
        );
    }
}

class _AddressStep extends KycStepWidget
{
    final VoidCallback onNext;
    const _AddressStep({required this.onNext});
    @override
    Widget buildForm(BuildContext context, WidgetRef ref, KycModel kycData)
    {
        return _AddressForm(onNext: onNext);
    }
}

class _AddressForm extends ConsumerStatefulWidget
{
    const _AddressForm({required this.onNext});
    final VoidCallback onNext;
    @override
    ConsumerState<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<_AddressForm>
{
    late final TextEditingController _pProv, _pDist, _pMuni, _pWard, _pArea;
    late final TextEditingController _cProv, _cDist, _cMuni, _cWard, _cArea;
    @override
    void initState()
    {
        super.initState();
        final d = ref.read(kycProvider).value!;
        _pProv = TextEditingController(text: d.permanentProvince);
        _pDist = TextEditingController(text: d.permanentDistrict);
        _pMuni = TextEditingController(text: d.permanentMunicipality);
        _pWard = TextEditingController(text: d.permanentWard);
        _pArea = TextEditingController(text: d.permanentArea);
        _cProv = TextEditingController(text: d.currentProvince);
        _cDist = TextEditingController(text: d.currentDistrict);
        _cMuni = TextEditingController(text: d.currentMunicipality);
        _cWard = TextEditingController(text: d.currentWard);
        _cArea = TextEditingController(text: d.currentArea);
    }
    @override
    void dispose()
    {
        _pProv.dispose();
        _pDist.dispose();
        _pMuni.dispose();
        _pWard.dispose();
        _pArea.dispose();
        _cProv.dispose();
        _cDist.dispose();
        _cMuni.dispose();
        _cWard.dispose();
        _cArea.dispose();
        super.dispose();
    }
    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final kycNotifier = ref.read(kycProvider.notifier);
        final kycData = ref.watch(kycProvider).value!;
        return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(l10n.kycPermanentAddress, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _pProv, hintText: l10n.kycProvince, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(permanentProvince: val))),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _pDist, hintText: l10n.kycDistrict, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(permanentDistrict: val))),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _pMuni, hintText: l10n.kycMunicipality, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(permanentMunicipality: val))),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _pWard, hintText: l10n.kycWardNumber, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(permanentWard: val))),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _pArea, hintText: l10n.kycToleStreetArea, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(permanentArea: val))),
                    const SizedBox(height: 32),
                    Text(l10n.kycCurrentAddress, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    CheckboxListTile(
                        title: Text(l10n.kycSameAsPermanent),
                        value: kycData.currentSameAsPermanent,
                        onChanged: (val) => kycNotifier.updateData(kycData.copyWith(currentSameAsPermanent: val ?? false)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                    ),
                    if (!kycData.currentSameAsPermanent) ...[
                        const SizedBox(height: 16),
                        CustomTextField(controller: _cProv, hintText: l10n.kycProvince, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(currentProvince: val))),
                        const SizedBox(height: 16),
                        CustomTextField(controller: _cDist, hintText: l10n.kycDistrict, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(currentDistrict: val))),
                        const SizedBox(height: 16),
                        CustomTextField(controller: _cMuni, hintText: l10n.kycMunicipality, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(currentMunicipality: val))),
                        const SizedBox(height: 16),
                        CustomTextField(controller: _cWard, hintText: l10n.kycWardNumber, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(currentWard: val))),
                        const SizedBox(height: 16),
                        CustomTextField(controller: _cArea, hintText: l10n.kycToleStreetArea, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(currentArea: val))),
                    ],
                    const SizedBox(height: 32),
                    PrimaryButton(text: l10n.kycNextButton, onPressed: widget.onNext),
                ],
            ),
        );
    }
}

class _IdentityStep extends KycStepWidget
{
    final VoidCallback onNext;
    const _IdentityStep({required this.onNext});
    @override
    Widget buildForm(BuildContext context, WidgetRef ref, KycModel kycData)
    {
        return _IdentityForm(onNext: onNext);
    }
}

class _IdentityForm extends ConsumerStatefulWidget
{
    const _IdentityForm({required this.onNext});
    final VoidCallback onNext;
    @override
    ConsumerState<_IdentityForm> createState() => _IdentityFormState();
}

class _IdentityFormState extends ConsumerState<_IdentityForm>
{
    late final TextEditingController _docNumberController;
    @override
    void initState()
    {
        super.initState();
        _docNumberController = TextEditingController(text: ref.read(kycProvider).value!.documentNumber);
    }
    @override
    void dispose()
    {
        _docNumberController.dispose();
        super.dispose();
    }
    Widget _buildUploadBox({required String title, required String buttonText, required VoidCallback onPressed, String? selectedFileName,})
    {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            decoration: BoxDecoration(color: const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400),),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(selectedFileName ?? title, style: const TextStyle(color: Colors.black54, fontSize: 14), textAlign: TextAlign.center,),
                    const SizedBox(height: 8),
                    OutlinedButton(
                        onPressed: onPressed,
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),),
                        child: Text(buttonText),
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final kycNotifier = ref.read(kycProvider.notifier);
        final kycData = ref.watch(kycProvider).value!;

        String? documentTypeValue;
        if (kycData.documentType != null)
        {
            final docType = kycData.documentType!.toLowerCase().replaceAll(' ', '_');
            if (docType == 'citizenship') documentTypeValue = l10n.kycCitizenship;
            else if (docType == 'passport') documentTypeValue = l10n.kycPassport;
            else if (docType == 'driver\'s_license') documentTypeValue = l10n.kycDriversLicense;
        }

        return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(l10n.kycIdentityVerification, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                        value: documentTypeValue,
                        decoration: InputDecoration(hintText: l10n.kycChooseDocument, border: const OutlineInputBorder()),
                        items: [l10n.kycCitizenship, l10n.kycPassport, l10n.kycDriversLicense].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                        onChanged: (val)
                        {
                            String docTypeCode = '';
                            if (val == l10n.kycCitizenship) docTypeCode = 'citizenship';
                            if (val == l10n.kycPassport) docTypeCode = 'passport';
                            if (val == l10n.kycDriversLicense) docTypeCode = 'driver\'s_license';
                            kycNotifier.updateData(kycData.copyWith(documentType: docTypeCode));
                        },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _docNumberController, hintText: l10n.kycDocumentNumber, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(documentNumber: val))),
                    const SizedBox(height: 24),
                    Text(l10n.kycUploadDocumentImage, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildUploadBox(title: l10n.kycUploadDocFront, buttonText: kycData.documentFrontImage == null ? l10n.kycUploadButton : l10n.kycChangeButton, selectedFileName: kycData.documentFrontImage?.path.split('/').last,
                        onPressed: () async
                        {
                            final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (image != null)
                            {
                                kycNotifier.updateData(kycData.copyWith(documentFrontImage: File(image.path)));
                            }
                        },
                    ),
                    const SizedBox(height: 16),
                    _buildUploadBox(title: l10n.kycUploadDocBack, buttonText: kycData.documentBackImage == null ? l10n.kycUploadButton : l10n.kycChangeButton, selectedFileName: kycData.documentBackImage?.path.split('/').last,
                        onPressed: () async
                        {
                            final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (image != null)
                            {
                                kycNotifier.updateData(kycData.copyWith(documentBackImage: File(image.path)));
                            }
                        },
                    ),
                    const SizedBox(height: 16),
                    _buildUploadBox(title: l10n.kycUploadShopVideo, buttonText: kycData.documentVideo == null ? l10n.kycUploadVideoButton : l10n.kycChangeVideoButton, selectedFileName: kycData.documentVideo?.path.split('/').last,
                        onPressed: () async
                        {
                            final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
                            if (video != null)
                            {
                                kycNotifier.updateData(kycData.copyWith(documentVideo: File(video.path)));
                            }
                        },
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(text: l10n.kycNextButton, onPressed: widget.onNext),
                ],
            ),
        );
    }
}

class _BusinessDetailsStep extends KycStepWidget
{
    final VoidCallback onSubmit;
    const _BusinessDetailsStep({required this.onSubmit});
    @override
    Widget buildForm(BuildContext context, WidgetRef ref, KycModel kycData)
    {
        return _BusinessDetailsForm(onSubmit: onSubmit);
    }
}

class _BusinessDetailsForm extends ConsumerStatefulWidget
{
    const _BusinessDetailsForm({required this.onSubmit});
    final VoidCallback onSubmit;
    @override
    ConsumerState<_BusinessDetailsForm> createState() => _BusinessDetailsFormState();
}

class _BusinessDetailsFormState extends ConsumerState<_BusinessDetailsForm>
{
    late final TextEditingController _bizNameController, _panController;
    @override
    void initState()
    {
        super.initState();
        final d = ref.read(kycProvider).value!;
        _bizNameController = TextEditingController(text: d.businessName);
        _panController = TextEditingController(text: d.panVatNumber);
    }
    @override
    void dispose()
    {
        _bizNameController.dispose();
        _panController.dispose();
        super.dispose();
    }
    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final kycNotifier = ref.read(kycProvider.notifier);
        final kycState = ref.watch(kycProvider);
        final kycData = kycState.value!;
        return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(l10n.kycBusinessDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(l10n.kycForVendorsOnly, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _bizNameController, hintText: l10n.kycBusinessName, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(businessName: val))),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _panController, hintText: l10n.kycPanVatNumber, onChanged: (val) => kycNotifier.updateData(kycData.copyWith(panVatNumber: val))),
                    const SizedBox(height: 16),
                    FormBuilderImagePicker(
                        name: 'business_license',
                        decoration: InputDecoration(labelText: l10n.kycUploadBusinessLicense),
                        maxImages: 1,
                        onChanged: (images)
                        {
                            if (images != null && images.isNotEmpty && images.first is XFile)
                            {
                                kycNotifier.updateData(kycData.copyWith(businessLicenseImage: File((images.first as XFile).path)));
                            }
                        },
                    ),
                    CheckboxListTile(
                        title: Text(l10n.kycAgreement),
                        value: kycData.agreedToTerms,
                        onChanged: (val) => kycNotifier.updateData(kycData.copyWith(agreedToTerms: val ?? false)),
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                        text: kycState.isLoading ? l10n.kycSubmittingButton : l10n.kycSubmitButton,
                        onPressed: kycData.agreedToTerms && !kycState.isLoading ? widget.onSubmit : null,
                    ),
                ],
            ),
        );
    }
}

class _SuccessStep extends StatelessWidget
{
    const _SuccessStep();
    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return Center(
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const CircleAvatar(radius: 40, backgroundColor: Colors.red, child: Icon(Icons.check, color: Colors.white, size: 50)),
                        const SizedBox(height: 24),
                        Text(l10n.kycSuccessTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text(l10n.kycSuccessMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 48),
                        PrimaryButton(
                            text: l10n.kycGoToHome,
                            onPressed: ()
                            {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    (Route<dynamic> route) => false,
                                );
                            },
                        ),
                    ],
                ),
            ),
        );
    }
}

void onKycButtonPressed(BuildContext context, WidgetRef ref) async
{
    final l10n = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try
    {
        final kycModel = await ref.refresh(kycStatusProvider.future);

        Navigator.of(context, rootNavigator: true).pop();

        if (kycModel == null || kycModel.isRejected)
        {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KycPageGate()));
        }
        else if (kycModel.isPending)
        {
            _showKycInfoDialog(
                context,
                title: l10n.kycSubmittedTitle,
                content: l10n.kycSubmittedContent,
            );
        }
        else if (kycModel.isVerified)
        {
            _showKycInfoDialog(
                context,
                title: l10n.kycVerifiedTitle,
                content: l10n.kycVerifiedContent,
            );
        }
    }
    catch (e)
    {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorFetchingKyc(e.toString())), backgroundColor: Colors.red),
        );
    }
}

void _showKycInfoDialog(BuildContext context, {required String title, required String content})
{
    final l10n = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
                TextButton(
                    child: Text(l10n.okButton),
                    onPressed: () => Navigator.of(context).pop(),
                ),
            ],
        ),
    );
}
