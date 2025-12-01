import 'dart:io';

class KycModel
{
    final int? id;
    final String status;
    bool get isVerified => status == 'VERIFIED';
    bool get isPending => status == 'PENDING';
    bool get isRejected => status == 'REJECTED';

    // Form fields
    final String fullName;
    final DateTime? dateOfBirth;
    final String? gender;
    final String phoneNumber;
    final String emailAddress;

    final String permanentProvince;
    final String permanentDistrict;
    final String permanentMunicipality;
    final String permanentWard;
    final String permanentArea;
    final bool currentSameAsPermanent;
    final String currentProvince;
    final String currentDistrict;
    final String currentMunicipality;
    final String currentWard;
    final String currentArea;

    final String? documentType;
    final String documentNumber;
    final File? documentFrontImage;
    final File? documentBackImage;
    final File? documentVideo;

    final String businessName;
    final String panVatNumber;
    final File? businessLicenseImage;
    final bool agreedToTerms;

    final String? documentFrontUrl;
    final String? documentBackUrl;
    final String? documentVideoUrl;
    final String? businessLicenseUrl;

    KycModel({
        this.id,
        this.status = 'PENDING',
        this.fullName = '',
        this.dateOfBirth,
        this.gender,
        this.phoneNumber = '',
        this.emailAddress = '',
        this.permanentProvince = '',
        this.permanentDistrict = '',
        this.permanentMunicipality = '',
        this.permanentWard = '',
        this.permanentArea = '',
        this.currentSameAsPermanent = false,
        this.currentProvince = '',
        this.currentDistrict = '',
        this.currentMunicipality = '',
        this.currentWard = '',
        this.currentArea = '',
        this.documentType,
        this.documentNumber = '',
        this.documentFrontImage,
        this.documentBackImage,
        this.documentVideo,
        this.businessName = '',
        this.panVatNumber = '',
        this.businessLicenseImage,
        this.agreedToTerms = false,
        this.documentFrontUrl,
        this.documentBackUrl,
        this.documentVideoUrl,
        this.businessLicenseUrl,
    });

    factory KycModel.fromJson(Map<String, dynamic> json)
    {
        final status = json['status'] as String? ?? 'PENDING';
        return KycModel(
            id: json['id'] as int?,
            status: status,
            fullName: json['full_name'] as String? ?? '',
            dateOfBirth: DateTime.tryParse(json['dob'] as String? ?? ''),
            gender: json['gender'] as String?,
            phoneNumber: json['phone_number'] as String? ?? '',
            emailAddress: json['email'] as String? ?? '',
            permanentProvince: json['permanent_province'] as String? ?? '',
            permanentDistrict: json['permanent_district'] as String? ?? '',
            permanentMunicipality: json['permanent_municipality'] as String? ?? '',
            permanentWard: json['permanent_ward_number'] as String? ?? '',
            permanentArea: json['permanent_area'] as String? ?? '',
            currentSameAsPermanent: json['current_same_as_permanent'] as bool? ?? false,
            currentProvince: json['current_province'] as String? ?? '',
            currentDistrict: json['current_district'] as String? ?? '',
            currentMunicipality: json['current_municipality'] as String? ?? '',
            currentWard: json['current_ward_number'] as String? ?? '',
            currentArea: json['current_area'] as String? ?? '',
            documentType: json['document_type'] as String?,
            documentNumber: json['document_number'] as String? ?? '',
            businessName: json['business_name'] as String? ?? '',
            panVatNumber: json['pan_vat_number'] as String? ?? '',
            documentFrontUrl: json['document_front'] as String?,
            documentBackUrl: json['document_back'] as String?,
            documentVideoUrl: json['document_video'] as String?,
            businessLicenseUrl: json['business_license'] as String?,
        );
    }

    KycModel copyWith({
        int? id,
        bool? isVerified,
        String? fullName,
        DateTime? dateOfBirth,
        String? gender,
        String? phoneNumber,
        String? emailAddress,
        String? permanentProvince,
        String? permanentDistrict,
        String? permanentMunicipality,
        String? permanentWard,
        String? permanentArea,
        bool? currentSameAsPermanent,
        String? currentProvince,
        String? currentDistrict,
        String? currentMunicipality,
        String? currentWard,
        String? currentArea,
        String? documentType,
        String? documentNumber,
        File? documentFrontImage,
        File? documentBackImage,
        File? documentVideo,
        String? businessName,
        String? panVatNumber,
        File? businessLicenseImage,
        bool? agreedToTerms,
    })
    {
        return KycModel(
            id: id ?? this.id,
            status: status ?? this.status,
            fullName: fullName ?? this.fullName,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            gender: gender ?? this.gender,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            emailAddress: emailAddress ?? this.emailAddress,
            permanentProvince: permanentProvince ?? this.permanentProvince,
            permanentDistrict: permanentDistrict ?? this.permanentDistrict,
            permanentMunicipality: permanentMunicipality ?? this.permanentMunicipality,
            permanentWard: permanentWard ?? this.permanentWard,
            permanentArea: permanentArea ?? this.permanentArea,
            currentSameAsPermanent: currentSameAsPermanent ?? this.currentSameAsPermanent,
            currentProvince: currentProvince ?? this.currentProvince,
            currentDistrict: currentDistrict ?? this.currentDistrict,
            currentMunicipality: currentMunicipality ?? this.currentMunicipality,
            currentWard: currentWard ?? this.currentWard,
            currentArea: currentArea ?? this.currentArea,
            documentType: documentType ?? this.documentType,
            documentNumber: documentNumber ?? this.documentNumber,
            documentFrontImage: documentFrontImage ?? this.documentFrontImage,
            documentBackImage: documentBackImage ?? this.documentBackImage,
            documentVideo: documentVideo ?? this.documentVideo,
            businessName: businessName ?? this.businessName,
            panVatNumber: panVatNumber ?? this.panVatNumber,
            businessLicenseImage: businessLicenseImage ?? this.businessLicenseImage,
            agreedToTerms: agreedToTerms ?? this.agreedToTerms,
            documentFrontUrl: documentFrontUrl ?? this.documentFrontUrl,
            documentBackUrl: documentBackUrl ?? this.documentBackUrl,
            documentVideoUrl: documentVideoUrl ?? this.documentVideoUrl,
            businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
        );
    }
}
