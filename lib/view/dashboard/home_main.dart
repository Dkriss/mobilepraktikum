import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilepraktikum/controller/db_controller.dart';
// API Keywoard Search
import 'package:mobilepraktikum/controller/destination_api.dart';
import 'package:mobilepraktikum/model/destination_model.dart';
import 'package:mobilepraktikum/model/transportation_model.dart';
import 'package:mobilepraktikum/view/dashboard/log_note.dart';
import 'package:mobilepraktikum/view/dashboard/profile.dart';
import 'package:mobilepraktikum/view/dashboard/shopping_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///////////// UNTUK MENGAMBIL DATA PADA ADD TO CHART ///////////////////
  final DbCon = Get.put(DatabaseController());
///////// Deklarasi tipe data dari  /////////
  String searchKeyword = "";
  late DestinationApi api;
///////// Deklarasi tipe data dari  /////////
  // untuk mengatur pemberian definisi pada setiap container List Elevated Button yang diatas
  List<TransportationModel> daftarTransportation = [
    TransportationModel(title: 'Promo', icon: Icons.sell_rounded),
    TransportationModel(title: 'Hotels', icon: Icons.hotel),
    TransportationModel(title: 'Flights', icon: Icons.flight),
    TransportationModel(title: 'Trains', icon: Icons.train_rounded),
    TransportationModel(title: 'Cars', icon: Icons.car_rental)
  ];
  List<DestinationModel> DestiMo = [];
  Map<dynamic, dynamic> shoppingCart = {};
  // untuk mengatur pemberian definisi pada setiap container List informasi yang ditengah
  List<DestinationModel> daftarDestination = [
    DestinationModel(
        title: 'Horison Hotel',
        location: 'Bali, Indonesia',
        price: '\$100/night',
        icon: Icons.star,
        image: 'assets/hotel_1.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
        title: 'Mangku Resort',
        location: 'Bandung, Indonesia',
        price: '\$80/night',
        icon: Icons.star,
        image: 'assets/hotel_2.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
        title: 'Majapahit Hotel',
        location: 'Jogja, Indonesia',
        price: '\$70/night',
        icon: Icons.star,
        image: 'assets/hotel_3.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
        title: 'Louson HomeStay',
        location: 'Bogor, Indonesia',
        price: '\$120/night',
        icon: Icons.star,
        image: 'assets/hotel_4.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
      title: 'Leaf Resort & Hotel',
      location: 'Bali, Indonesia',
      price: '\$30/night',
      icon: Icons.star,
      image: 'assets/hotel_5.jpg',
      id: '',
      quantity: 10,
    ),
    DestinationModel(
        title: 'Anker & Rum Hotel',
        location: 'Surabaya, Indonesia',
        price: '\$45/night',
        icon: Icons.star,
        image: 'assets/hotel_6.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
        title: 'Ubud Nation Resort',
        location: 'Bali, Indonesia',
        price: '\$90/night',
        icon: Icons.star,
        image: 'assets/hotel_7.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
        title: 'Reddoors Badung',
        location: 'Bali, Indonesia',
        price: '\$65/night',
        icon: Icons.star,
        image: 'assets/hotel_8.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
        title: 'Resident Hotel',
        location: 'Labuan Bajo, Indonesia',
        price: '\$46/night',
        icon: Icons.star,
        image: 'assets/hotel_9.jpg',
        id: '',
        quantity: 10),
    DestinationModel(
        title: 'Melow Resort & Resto',
        location: 'Banyuwangi, Indonesia',
        price: '\$39/night',
        icon: Icons.star,
        image: 'assets/hotel_10.jpg',
        id: '',
        quantity: 10),
  ];
  void _showDestinationDialog(DestinationModel destination) {
    int quantity = 1; // Initialize quantity to 1

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(destination.title),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Location: ${destination.location}'),
                  Text('Price: ${destination.price}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity: $quantity'),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    ////// untuk menambahkan ke database dari db controller
                    onPressed: () async {
                      var result = await DbCon.storeUserName({
                        'nama_hotel': destination.title,
                        'lokasi': destination.location,
                        'quantity': destination
                            .quantity, // Add quantity to the database
                      });
                      setState(() {
                        destination.id = result;
                        DestiMo.add(destination);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  ////////////////////////////////
  void initState() {
    super.initState();
    api = DestinationApi(
        daftarDestination); // Inisialisasi API dengan data destination
  }

  List<DestinationModel> get filteredDestinations =>
      api.searchDestinations(searchKeyword);
  ////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // agar container di tengah dan navigation button di bawah tidak ikut terangkat saat keyboard muncul
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Stack(
            children: <Widget>[
              const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your Location',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Malang, Jawa Timur, Indonesia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.notifications_none_outlined,
                        size: 33,
                      ),
                    ],
                  ),
                  // jarak spasi dengan tulisan "Malang, Jawa Timur, Indonesia
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),

              // container untuk menambahkan textfield
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, top: 85, right: 0, bottom: 25),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15), // Penambahan padding horizontal
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Ini yang menyebar widget dalam Row
                        children: [
                          const Icon(
                            Icons.search,
                            size: 30,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: TextField(
                                ////////// Inisialisasi Value pencarian Text Field ////////////
                                onChanged: (value) {
                                  setState(() {
                                    // value trim  untuk menghapus whitespace di awal dan akhir string
                                    searchKeyword = value.trim();
                                  });
                                },
                                /////////// Inisialisasi Value pencarian Text Field ///////////
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Where do you wanna go',
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.find_in_page_outlined,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // container widget bagian bawah 4 tombol elevatedButton ListView dengan gerakan horizontal
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, top: 150, right: 0, bottom: 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 70, // Tinggi container
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 15, bottom: 15),
                    margin: const EdgeInsets.only(left: 0, right: 0),
                    child:
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Scroll horizontal
                        itemCount: daftarTransportation.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.3, // 30% dari lebar layar
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    // Tambahkan kondisi ini untuk memastikan ikon tidak null
                                    Icon(daftarTransportation[index].icon),
                                    Text(daftarTransportation[index].title),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Container untuk informasi di tengah serta listview informasi
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, top: 100, right: 0, bottom: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 500, // Tinggi container
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F8),
                    ),
                    // untuk menonaktifkan notifikasi overscroll
                    // warna biru jika sudah di paling atas
                    child:
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        /////////// Filterisasi ukuran destinasi ////////////
                        itemCount: filteredDestinations.length,
                        itemBuilder: (BuildContext context, int index) {
                          DestinationModel destination =
                          filteredDestinations[index];
                          ///////// Filterisasi ukuran destinasi /////////
                          return GestureDetector(
                            onTap: () => _showDestinationDialog(destination),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              // shadow hitam dibawah card
                              elevation: 10,
                              child: Column(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                    child: Image.asset(destination.image,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                                  ),
                                  const SizedBox(height: 8),
                                  // Title
                                  Text(destination.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  // Location
                                  Text(destination.location,
                                      style:
                                      TextStyle(color: Colors.grey[600])),
                                  // Price
                                  Text(destination.price,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green)),
                                  // Icon
                                  Icon(destination.icon, color: Colors.amber),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // navigation button untuk pindah layar halaman
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 20, right: 15, bottom: 25),
                child: Align(
                  // untuk menaruh container dan 4 elevatedbutton di bagian bawah layar
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Warna putih gelap
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Icon(Icons.home),
                            ),
                          ),
                          SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LogNote())),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Icon(Icons.file_copy_rounded),
                            ),
                          ),
                          SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  ///////// untuk Routes ke DestiMo Items /////////////////
                                  builder: (context) =>
                                      ShoppingCart(cartItems: DestiMo),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Icon(Icons.shopping_cart),
                            ),
                          ),
                          SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Profile())), //ke halaman profile
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Icon(Icons.person),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}