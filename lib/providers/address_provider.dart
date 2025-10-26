import 'package:flutter/material.dart';

class Address {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;
  final DateTime createdAt;

  Address({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
    required this.createdAt,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'],
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
      isDefault: map['isDefault'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get fullAddress {
  final parts = [
    addressLine1,
    addressLine2, 
    city,
    state,
    postalCode,
    country,
  ];

  // Filter out nulls and empty strings
  return parts.where((part) => part != null && part.isNotEmpty).join(', ');
}


  Address copyWith({
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
  }) {
    return Address(
      id: id,
      userId: userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt,
    );
  }
}

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get default address
  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // Add new address
  Future<bool> addAddress({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    bool isDefault = false,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // await FirebaseFirestore.instance.collection('addresses').add(addressData);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // If this is set as default, remove default from other addresses
      if (isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          if (_addresses[i].isDefault) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        }
      }

      final address = Address(
        id: 'address_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        postalCode: postalCode,
        country: country,
        isDefault: isDefault,
        createdAt: DateTime.now(),
      );

      _addresses.add(address);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add address: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  

  // Update address
  Future<bool> updateAddress({
    required String addressId,
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // await FirebaseFirestore.instance
      //     .collection('addresses')
      //     .doc(addressId)
      //     .update(updateData);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final addressIndex = _addresses.indexWhere((address) => address.id == addressId);
      if (addressIndex != -1) {
        // If this is set as default, remove default from other addresses
        if (isDefault == true) {
          for (int i = 0; i < _addresses.length; i++) {
            if (i != addressIndex && _addresses[i].isDefault) {
              _addresses[i] = _addresses[i].copyWith(isDefault: false);
            }
          }
        }

        _addresses[addressIndex] = _addresses[addressIndex].copyWith(
          fullName: fullName,
          phoneNumber: phoneNumber,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          state: state,
          postalCode: postalCode,
          country: country,
          isDefault: isDefault,
        );
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update address: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // await FirebaseFirestore.instance
      //     .collection('addresses')
      //     .doc(addressId)
      //     .delete();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _addresses.removeWhere((address) => address.id == addressId);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete address: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Set default address
  Future<bool> setDefaultAddress(String addressId) async {
    return await updateAddress(
      addressId: addressId,
      isDefault: true,
    );
  }

  // Load user addresses
  Future<void> loadUserAddresses(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // final snapshot = await FirebaseFirestore.instance
      //     .collection('addresses')
      //     .where('userId', isEqualTo: userId)
      //     .orderBy('createdAt', descending: true)
      //     .get();
      // 
      // _addresses = snapshot.docs
      //     .map((doc) => Address.fromMap(doc.data()))
      //     .toList();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Add sample address for demo
      if (_addresses.isEmpty) {
        _addresses = [
          Address(
            id: 'address_1',
            userId: userId,
            fullName: 'John Doe',
            phoneNumber: '+1234567890',
            addressLine1: '123 Main Street',
            addressLine2: 'Apt 4B',
            city: 'New York',
            state: 'NY',
            postalCode: '10001',
            country: 'United States',
            isDefault: true,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
        ];
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load addresses: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Get address by ID
  Address? getAddressById(String addressId) {
    try {
      return _addresses.firstWhere((address) => address.id == addressId);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
