class ApiEndpoints {
  static const syncProfile = "/auth/sync-profile";
  static const createPatientDetails = "/patients/details";
  static const createPharmacyDetails = "/pharmacies/details";

  static const searchMedicine = "/patients/medicines/search";
  static const medicineDetails = "/patients/medicines";
  static const reservations = "/patients/reservations";
  static const patientRequests = "/patients/requests";

  static const pharmacyDashboard = "/pharmacies/dashboard";
  static const inventory = "/pharmacies/inventory";
  static const handleRequest = "/pharmacies/requests/handle";

  static const adminMetrics = "/admin/metrics";
  static const verifyPharmacy = "/admin/pharmacies/verify";
}