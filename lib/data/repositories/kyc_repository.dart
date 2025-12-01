import 'package:dio/dio.dart';
import 'package:totto/config/api_client.dart';
import 'package:totto/data/models/kyc_model.dart';

class KycRepository
{
    final Dio _dio = ApiClient().dio;

    Future<KycModel?> fetchKycStatus() async
    {
        const String endpointPath = '/auth/kyc/';
        try
        {
            final response = await _dio.get(endpointPath);

            final responseMap = response.data as Map<String, dynamic>;

            final List<dynamic> kycList = responseMap['data'] as List<dynamic>;

            if (kycList.isNotEmpty)
            {
                return KycModel.fromJson(kycList.first);
            }
            return null;
        }
        on DioException catch (e)
        {
            if (e.response?.statusCode == 404)
            {
                return null;
            }
            print('--- REPOSITORY ERROR: Failed to fetch KYC status: ${e.response?.data}');
            throw Exception('Failed to fetch KYC status.');
        }
    }

    Future<void> submitKyc(KycModel data) async
    {
        const String endpointPath = '/auth/kyc/';
        try
        {
            final formData = await _createFormData(data);
            await _dio.post(endpointPath, data: formData);
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to submit KYC: ${e.response?.data}');
            throw Exception('Failed to submit KYC: ${e.response?.data['detail'] ?? 'An unknown error occurred.'}');
        }
    }

    Future<void> updateKyc(KycModel data) async
    {
        if (data.id == null) throw Exception('KYC ID is missing for update.');
        final String endpointPath = '/auth/kyc/${data.id}/';
        try
        {
            final formData = await _createFormData(data);
            await _dio.patch(endpointPath, data: formData);
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to update KYC: ${e.response?.data}');
            throw Exception('Failed to update KYC: ${e.response?.data['detail'] ?? 'An unknown error occurred.'}');
        }
    }

    Future<FormData> _createFormData(KycModel data) async
    {
        final Map<String, dynamic> textData =
            {
                'full_name': data.fullName,
                if (data.dateOfBirth != null) 'dob': data.dateOfBirth!.toIso8601String().substring(0, 10),
                if (data.gender != null) 'gender': data.gender!.substring(0, 1).toUpperCase(),
                'phone_number': data.phoneNumber,
                'email': data.emailAddress,
                'permanent_province': data.permanentProvince,
                'permanent_district': data.permanentDistrict,
                'permanent_municipality': data.permanentMunicipality,
                'permanent_ward_number': data.permanentWard,
                'permanent_area': data.permanentArea,
                'current_same_as_permanent': data.currentSameAsPermanent.toString(),
                'current_province': data.currentProvince,
                'current_district': data.currentDistrict,
                'current_municipality': data.currentMunicipality,
                'current_ward_number': data.currentWard,
                'current_area': data.currentArea,
                if (data.documentType != null) 'document_type': data.documentType!.toLowerCase().replaceAll(' ', '_'),
                'document_number': data.documentNumber,
                'business_name': data.businessName,
                'pan_vat_number': data.panVatNumber,
                'agreed_to_terms': data.agreedToTerms.toString(),
            };

        textData.removeWhere((key, value) => value is String && value.isEmpty);

        final formData = FormData.fromMap(textData);

        if (data.documentFrontImage != null)
        {
            formData.files.add(MapEntry('document_front', await MultipartFile.fromFile(data.documentFrontImage!.path, filename: data.documentFrontImage!.path.split('/').last)));
        }
        if (data.documentBackImage != null)
        {
            formData.files.add(MapEntry('document_back', await MultipartFile.fromFile(data.documentBackImage!.path, filename: data.documentBackImage!.path.split('/').last)));
        }
        if (data.documentVideo != null)
        {
            formData.files.add(MapEntry('document_video', await MultipartFile.fromFile(data.documentVideo!.path, filename: data.documentVideo!.path.split('/').last)));
        }
        if (data.businessLicenseImage != null)
        {
            formData.files.add(MapEntry('business_license', await MultipartFile.fromFile(data.businessLicenseImage!.path, filename: data.businessLicenseImage!.path.split('/').last)));
        }

        return formData;
    }
}
