import 'package:gebeya/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gebeya/providers/auth_provider.dart';
import 'package:gebeya/providers/address_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load user addresses when settings page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<AddressProvider>(context, listen: false)
            .loadUserAddresses(authProvider.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, AddressProvider>(
      builder: (context, authProvider, addressProvider, child) {
        final user = authProvider.user;
        final defaultAddress = addressProvider.defaultAddress;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, secondaryColor],
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showProfileDialog(context, authProvider),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: user?.profileImageUrl != null
                                    ? NetworkImage(user!.profileImageUrl!)
                                    : null,
                                child: user?.profileImageUrl == null
                                    ? Icon(
                                        Icons.account_circle,
                                        color: black.withOpacity(0.3),
                                        size: 100,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              user?.name ?? 'Guest User',
                              style: TextStyle(
                                color: black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              user?.email ?? 'guest@example.com',
                              style: TextStyle(
                                color: black.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ListTile(
                      leading: Icon(Icons.person, color: black),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: black),
                      onTap: () => _showProfileDialog(context, authProvider),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined, color: black),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipping Address',
                            style: TextStyle(color: black, fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            defaultAddress?.fullAddress ?? 'No address added',
                            style: TextStyle(
                              color: black.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: black),
                      onTap: () => _showAddressDialog(context, addressProvider, authProvider),
                    ),
                    Divider(color: Colors.black),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'General settings',
                        style: TextStyle(
                          color: black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.notifications, color: black),
                      title: Text(
                        'Notifications',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Notifications ${value ? 'enabled' : 'disabled'}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.dark_mode, color: black),
                      title: Text(
                        'Dark Mode',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Dark mode ${value ? 'enabled' : 'disabled'}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.language, color: black),
                      title: Text(
                        'Language',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'English',
                            style: TextStyle(color: black.withOpacity(0.7)),
                          ),
                          Icon(Icons.arrow_forward_ios, color: black),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language selection coming soon!'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.security, color: black),
                      title: Text(
                        'Change Password',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: black),
                      onTap: () => _showChangePasswordDialog(context, authProvider),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.help, color: black),
                      title: Text(
                        'Help & Support',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: black),
                      onTap: () => _showHelpDialog(context),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.info_outline, color: black),
                      title: Text(
                        'About',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: black),
                      onTap: () => _showAboutDialog(context),
                    ),
                    SizedBox(height: 30),
                    if (user != null && !user.email.startsWith('guest'))
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _showLogoutDialog(context, authProvider),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProfileDialog(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    final nameController = TextEditingController(text: user?.name ?? '');
    final phoneController = TextEditingController(text: user?.phoneNumber ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await authProvider.updateProfile(
                name: nameController.text.trim(),
                phoneNumber: phoneController.text.trim().isNotEmpty
                    ? phoneController.text.trim()
                    : null,
              );
              Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Profile updated!' : 'Update failed'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context, AddressProvider addressProvider, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Addresses'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: addressProvider.addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 50, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No addresses added yet'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: addressProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = addressProvider.addresses[index];
                    return Card(
                      child: ListTile(
                        title: Text(address.fullName),
                        subtitle: Text(address.fullAddress),
                        trailing: address.isDefault
                            ? Chip(label: Text('Default'), backgroundColor: Colors.green)
                            : null,
                        onTap: () {
                          Navigator.pop(context);
                          _showEditAddressDialog(context, addressProvider, address);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddAddressDialog(context, addressProvider, authProvider);
            },
            child: Text('Add New'),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, AddressProvider addressProvider, AuthProvider authProvider) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalController = TextEditingController();
    final countryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Address'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address Line 1'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(labelText: 'State'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: postalController,
                  decoration: InputDecoration(labelText: 'Postal Code'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final success = await addressProvider.addAddress(
                  userId: authProvider.user!.id,
                  fullName: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  addressLine1: addressController.text.trim(),
                  city: cityController.text.trim(),
                  state: stateController.text.trim(),
                  postalCode: postalController.text.trim(),
                  country: countryController.text.trim(),
                  isDefault: addressProvider.addresses.isEmpty,
                );
                Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Address added!' : 'Failed to add address'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context, AddressProvider addressProvider, address) {
    // Implementation for editing address
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit address functionality coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthProvider authProvider) {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Current Password'),
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Required';
                  if (value!.length < 6) return 'Must be at least 6 characters';
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                validator: (value) {
                  if (value != newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final success = await authProvider.changePassword(
                  currentPassword: currentPasswordController.text,
                  newPassword: newPasswordController.text,
                );
                Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Password changed!' : 'Failed to change password'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.signOut();
              Navigator.pop(context);
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/signin');
              }
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Contact us:'),
            SizedBox(height: 16),
            Text('📧 Email: support@ecommerce.com'),
            Text('📞 Phone: +1 (555) 123-4567'),
            Text('💬 Live Chat: Available 24/7'),
            SizedBox(height: 16),
            Text('Common Issues:'),
            Text('• Forgot password: Use "Forgot Password" on sign in'),
            Text('• Order issues: Check Orders tab'),
            Text('• Account problems: Contact support'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "About App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.shopping_cart,
                size: 40,
                color: grey,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "This is a comprehensive e-commerce platform built with Flutter. "
              "It features user authentication, product browsing, shopping cart, "
              "order management, and user profile settings. The app is designed "
              "to provide a seamless shopping experience for users.",
            ),
            SizedBox(height: 10),
            Text("Version: 1.0.0"),
            Text("Developed by: Miftah Fentaw"),
            Text("Framework: Flutter"),
            Text("State Management: Provider"),
            Text("Backend Ready: Firebase"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}