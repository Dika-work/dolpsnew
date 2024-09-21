// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../utils/constant/custom_size.dart';
// import '../../widgets/dropdown.dart';

// class LaporanDealer extends StatefulWidget {
//   const LaporanDealer({super.key});

//   @override
//   State<LaporanDealer> createState() => _LaporanDealerState();
// }

// class _LaporanDealerState extends State<LaporanDealer> {
//   List<String> months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Des'
//   ];

//   List<String> years = ['2021', '2022', '2023', '2024', '2025'];

//   String selectedYear = DateTime.now().year.toString();
//   String selectedMonth = ""; // Jangan diinisialisasi langsung

//   SamarindaSource? samarindaSource;
//   final controller = Get.put(SamarindaController());
//   final networkConn = Get.find<NetworkManager>();

//   @override
//   void initState() {
//     super.initState();
//     // Inisialisasi selectedMonth di dalam initState()
//     selectedMonth = months[DateTime.now().month - 1];

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchDataAndRefreshSource();
//     });
//   }

//   Future<void> _fetchDataAndRefreshSource() async {
//     if (!await networkConn.isConnected()) {
//       SnackbarLoader.errorSnackBar(
//         title: 'Koneksi Terputus',
//         message: 'Anda telah kehilangan koneksi internet.',
//       );
//     }
//     try {
//       await controller.fetchLaporanSamarinda(int.parse(selectedYear));
//     } catch (e) {
//       controller.samarindaModel.assignAll(
//           _generateDefaultData()); // Jika gagal ambil data, gunakan data default
//     }
//     _updateLaporanSource();
//   }

// // Metode untuk menghasilkan data default (bulan 1-12, hasil = 0)
//   List<SamarindaModel> _generateDefaultData() {
//     List<SamarindaModel> defaultData = [];
//     for (int i = 1; i <= 12; i++) {
//       defaultData.add(SamarindaModel(
//         bulan: i,
//         tahun: int.parse(selectedYear),
//         sumberData: "do_global",
//         hasil: 0,
//       ));
//       defaultData.add(SamarindaModel(
//         bulan: i,
//         tahun: int.parse(selectedYear),
//         sumberData: "do_harian",
//         hasil: 0,
//       ));
//     }
//     return defaultData;
//   }

//   void _updateLaporanSource() {
//     setState(() {
//       samarindaSource = SamarindaSource(
//         selectedYear: int.parse(selectedYear),
//         selectedMonth: months.indexOf(selectedMonth) + 1,
//         samarindaModel: controller.samarindaModel,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return  Scaffold(
//        appBar: AppBar(
//         title: Text(
//           'Laporan samarinda',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(
//                CustomSize.sm,  CustomSize.sm,CustomSize.sm,0),
//                children: [
//                 Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: DropDownWidget(
//                     value: selectedYear,
//                     items: years,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedYear = newValue!;
//                         print('INI TAHUN YANG DI PILIH $selectedYear');
//                         _fetchDataAndRefreshSource();
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: CustomSize.sm),
//                 Expanded(
//                   flex: 1,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       _fetchDataAndRefreshSource();
//                     },
//                     style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: CustomSize.md)),
//                     child: const Icon(Iconsax.calendar_search),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: CustomSize.spaceBtwInputFields),
//                ],
//       ),
//     );
//   }
// }