import '../../craft_dynamic.dart';
import '../network/local_repository.dart';

class LocalDataUtil {
  static refreshBeneficiaries(List<dynamic> beneficiaries) {
    final beneficiaryRepository = BeneficiaryRepository();

    beneficiaryRepository.clearTable();
    for (var beneficiary in beneficiaries) {
      beneficiaryRepository
          .insertBeneficiary(Beneficiary.fromJson(beneficiary));
    }
  }
}
