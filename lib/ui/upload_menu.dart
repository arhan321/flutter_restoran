import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadMenuPage extends StatefulWidget {
  const UploadMenuPage({super.key});

  @override
  State<UploadMenuPage> createState() => _UploadMenuPageState();
}

class _UploadMenuPageState extends State<UploadMenuPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaMenuController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  String? _selectedRestoran;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  final List<String> _restoranList = [
    'Kafe kita',
    'Melting Pot',
    'Kafein',
    'Istana Emas',
  ];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // Bisa diganti ke ImageSource.camera
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Dropdown restoran
              DropdownButtonFormField<String>(
                value: _selectedRestoran,
                decoration: const InputDecoration(
                  labelText: 'Pilih Restoran',
                  border: OutlineInputBorder(),
                ),
                items: _restoranList.map((resto) {
                  return DropdownMenuItem<String>(
                    value: resto,
                    child: Text(resto),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRestoran = value;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Pilih restoran terlebih dahulu';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nama Menu
              TextFormField(
                controller: _namaMenuController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama menu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Deskripsi
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Harga
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Upload Gambar
              const Text(
                'Upload Foto Menu:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : const Center(child: Text('Tap untuk pilih gambar')),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Submit
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedImage != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Berhasil'),
                          content: Text(
                              'Menu "${_namaMenuController.text}" berhasil diupload ke restoran "$_selectedRestoran".'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );

                      _formKey.currentState!.reset();
                      _namaMenuController.clear();
                      _deskripsiController.clear();
                      _hargaController.clear();
                      setState(() {
                        _selectedRestoran = null;
                        _selectedImage = null;
                      });
                    } else if (_selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon upload gambar terlebih dahulu'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Upload Menu',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
