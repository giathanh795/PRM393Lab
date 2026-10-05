import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/local_storage_service.dart';

class Lab93CrudDatabaseScreen extends StatefulWidget {
  const Lab93CrudDatabaseScreen({super.key});

  @override
  State<Lab93CrudDatabaseScreen> createState() => _Lab93CrudDatabaseScreenState();
}

class _Lab93CrudDatabaseScreenState extends State<Lab93CrudDatabaseScreen> {
  static const String _dbFileName = 'contacts_database.json';
  final List<Contact> _contacts = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load database or seed with initial sample if first run
  Future<void> _initDatabase() async {
    setState(() => _isLoading = true);
    final data = await LocalStorageService.readJson(_dbFileName);

    if (data.isEmpty) {
      // Seed default data for immediate testing
      _contacts.addAll([
        Contact(
          id: 1,
          name: 'Nguyen Van A',
          phone: '0901234567',
          email: 'vana@example.com',
          role: 'Colleague',
        ),
        Contact(
          id: 2,
          name: 'Tran Thi B',
          phone: '0912345678',
          email: 'thib@example.com',
          role: 'Client',
        ),
        Contact(
          id: 3,
          name: 'Le Van C',
          phone: '0987654321',
          email: 'vanc@example.com',
          role: 'Friend',
        ),
      ]);
      await _autoSave();
    } else {
      _contacts.clear();
      _contacts.addAll(
        data.map((item) => Contact.fromJson(item as Map<String, dynamic>)),
      );
    }

    setState(() => _isLoading = false);
  }

  /// Step 4: Auto-Save JSON after every CRUD change
  Future<void> _autoSave() async {
    final jsonList = _contacts.map((c) => c.toJson()).toList();
    await LocalStorageService.writeJson(_dbFileName, jsonList);
  }

  /// Step 3: Add / Edit / Delete CRUD Operations
  void _openContactFormModal({Contact? existingContact}) {
    final isEditing = existingContact != null;
    final nameController = TextEditingController(text: existingContact?.name ?? '');
    final phoneController = TextEditingController(text: existingContact?.phone ?? '');
    final emailController = TextEditingController(text: existingContact?.email ?? '');
    String selectedRole = existingContact?.role ?? 'Friend';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.person_add,
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 8),
                  Text(isEditing ? 'Edit Contact' : 'Add New Contact'),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone *',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Phone is required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Category / Role',
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: ['Friend', 'Colleague', 'Client', 'Family'].map((role) {
                          return DropdownMenuItem(value: role, child: Text(role));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedRole = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.pop(ctx);
                    final messenger = ScaffoldMessenger.of(context);

                    setState(() {
                      if (isEditing) {
                        existingContact.name = nameController.text.trim();
                        existingContact.phone = phoneController.text.trim();
                        existingContact.email = emailController.text.trim();
                        existingContact.role = selectedRole;
                      } else {
                        final nextId = _contacts.isEmpty
                            ? 1
                            : (_contacts.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1);
                        _contacts.insert(
                          0,
                          Contact(
                            id: nextId,
                            name: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            email: emailController.text.trim(),
                            role: selectedRole,
                          ),
                        );
                      }
                    });

                    await _autoSave();

                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing ? 'Contact updated!' : 'Contact added & saved to JSON!',
                          ),
                          backgroundColor: Colors.purple,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'Save Changes' : 'Add Contact'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(Contact contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${contact.name}" from the JSON database?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final messenger = ScaffoldMessenger.of(context);
              setState(() {
                _contacts.removeWhere((c) => c.id == contact.id);
              });
              await _autoSave();
              if (mounted) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Contact deleted & JSON file updated!'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = _contacts.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.phone.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.role.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Lab 9.3 - JSON CRUD Database'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openContactFormModal(),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('New Contact'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : Column(
              children: [
                // Step 2: Search Bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search contacts by name, phone, role...',
                      prefixIcon: const Icon(Icons.search, color: Colors.purple),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),

                // Database counter banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Contacts: ${_contacts.length} (${filteredContacts.length} shown)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.autorenew, size: 14, color: Colors.purple),
                            SizedBox(width: 4),
                            Text(
                              'Auto-saved to JSON',
                              style: TextStyle(fontSize: 11, color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Contact list
                Expanded(
                  child: filteredContacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No contacts in mini database.'
                                    : 'No matching contacts found.',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          itemCount: filteredContacts.length,
                          itemBuilder: (context, index) {
                            final contact = filteredContacts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: 1.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple.shade50,
                                  child: Text(
                                    contact.name.isNotEmpty
                                        ? contact.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        contact.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        contact.role,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 13, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(contact.phone, style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                    if (contact.email.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.email, size: 13, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(contact.email, style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                      onPressed: () =>
                                          _openContactFormModal(existingContact: contact),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () => _confirmDelete(contact),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
