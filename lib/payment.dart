import 'package:flutter/material.dart';
import 'success_payment.dart';


class PaymentPage extends StatefulWidget {
  final Map<String, String> product;
  final int jumlahStok;

  const PaymentPage({
    Key? key,
    required this.product,
    required this.jumlahStok,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool useShipping = false;
  String? selectedPayment;
  String? selectedCourier;
  bool isEditingAddress = false;
  final TextEditingController addressController = TextEditingController(
    text: "Jl. Dr. Setiabudi No.229, Isola,\nKec. Sukasari, Kota Bandung,\nJawa Barat 40154",
  );


  @override
  Widget build(BuildContext context) {
    int price = 0;
    if (widget.product.containsKey('price')) {
      String rawPrice = widget.product['price']!.replaceAll(RegExp(r'[^0-9]'), '');
      if (rawPrice.isNotEmpty) {
        price = int.tryParse(rawPrice) ?? 0;
      }
    }

    const int appFee = 2000;
    int shippingFee = useShipping ? 10000 : 0; // contoh biaya pengiriman
    int total = (price * widget.jumlahStok) + appFee + shippingFee;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // kembali ke detail_product.dart
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            // Kartu Produk
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        widget.product['image']!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.containsKey('name') ? widget.product['name']! : 'Produk',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          buildProductInfo("Kategori", widget.product['category']),
                          buildProductInfo("Lokasi", widget.product['location']),
                          buildProductInfo("Harga", widget.product['price']),
                          buildProductInfo("Jumlah Disewa", widget.jumlahStok.toString()),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Checkbox Pengiriman
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Gunakan Jasa Pengiriman?", style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Checkbox(
                              value: useShipping,
                              onChanged: (val) {
                                setState(() {
                                  useShipping = true;
                                });
                              },
                            ),

                            const Text("Ya"),
                            Checkbox(
                              value: !useShipping,
                              onChanged: (val) {
                                setState(() {
                                  useShipping = false;
                                  selectedCourier = null;
                                });
                              },
                            ),
                            const Text("Tidak"),
                          ],
                        ),
                      ],
                    ),
                    if (useShipping) const SizedBox(height: 8),
                    if (useShipping)
                      Column(
                        children: [
                          buildCourierOption("J&T", "assets/images/j&t.png"),
                          buildCourierOption("SiCepat", "assets/images/sicepat.png"),
                          buildCourierOption("JNE", "assets/images/jne.png"),
                          const SizedBox(height: 12),

                          // === TAMBAHAN ALAMAT DI DALAM CARD ===
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Alamat + Tombol Edit
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Alamat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        isEditingAddress = true;
                                      });
                                    },
                                    icon: const Icon(Icons.edit, size: 16, color: Colors.black),
                                    label: const Text("edit", style: TextStyle(color: Colors.black)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                      minimumSize: const Size(0, 32),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Mode tampilan atau edit
                              if (!isEditingAddress)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    addressController.text,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: addressController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: "Masukkan alamat lengkap...",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditingAddress = false;
                                            });
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditingAddress = false;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          ),
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          )
                          // === END TAMBAHAN ===
                        ],
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 12),

            // Metode Pembayaran
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  buildPaymentOption("QRIS", "assets/images/qris.png"),
                  buildPaymentOption("GOPAY", "assets/images/gopay.png"),
                  buildPaymentOption("DANA", "assets/images/dana.png"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Tagihan
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detail Tagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    buildDetailRow("Biaya Produk (${widget.jumlahStok})", price * widget.jumlahStok),
                    buildDetailRow("Biaya Pengiriman", shippingFee),
                    buildDetailRow("Biaya Jasa Aplikasi", appFee),
                    const Divider(),
                    buildDetailRow("Total Tagihan", total, isBold: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Konfirmasi pembayaran"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuccessPaymentPage(),
                    ),
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductInfo(String label, String? value) {
    String textValue = "-";
    if (value != null && value.isNotEmpty) {
      textValue = value;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: textValue,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption(String method, String assetPath) {
    return ListTile(
      leading: Image.asset(assetPath, width: 30),
      title: Text(method),
      trailing: Radio<String>(
        value: method,
        groupValue: selectedPayment,
        onChanged: (val) {
          if (val != null) {
            setState(() {
              selectedPayment = val;
            });
          }
        },
      ),
    );
  }

  Widget buildCourierOption(String name, String assetPath) {
    return ListTile(
      leading: Image.asset(assetPath, width: 40),
      title: Text(name),
      trailing: Radio<String>(
        value: name,
        groupValue: selectedCourier,
        onChanged: (val) {
          if (val != null) {
            setState(() {
              selectedCourier = val;
            });
          }
        },
      ),
    );
  }

  Widget buildDetailRow(String label, int amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text("Rp. $amount", style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
