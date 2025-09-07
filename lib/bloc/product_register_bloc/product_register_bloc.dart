import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:mib/bloc/product_register_bloc/product_register_event.dart';
import 'package:mib/bloc/product_register_bloc/product_register_state.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/product_register_model/product_register_model.dart';
import '../../data/repositories/product_add_repository.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final AddProductRepository addProductRepo;
  final String shopId; // Inject shop ID based on logged-in user context
  final uuid = Uuid();

  CatalogBloc({required this.addProductRepo, required this.shopId}) : super(CatalogInitial()) {
    on<UploadExcelFile>(_onUploadExcelFile);
    on<DownloadSampleExcel>(_onDownloadSampleExcel);
  }

  Future<void> _onUploadExcelFile(
      UploadExcelFile event,
      Emitter<CatalogState> emit,
      ) async {
    emit(CatalogLoading());

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        emit(CatalogFailure("No file selected"));
        return;
      }

      final fileBytes = result.files.first.bytes;
      if (fileBytes == null) {
        emit(CatalogFailure("Failed to read file"));
        return;
      }

      final excel = Excel.decodeBytes(fileBytes);

      if (excel.tables.isEmpty) {
        emit(CatalogFailure("No sheets found in the Excel file"));
        return;
      }

      final table = excel.tables.values.first;
      if (table.rows.length < 2) {
        emit(CatalogFailure("Excel sheet is empty or missing data rows"));
        return;
      }

      final headers = table.rows.first
          .map((cell) => cell?.value?.toString().trim().toLowerCase() ?? "")
          .toList();

      if (headers.isEmpty || headers.every((h) => h.isEmpty)) {
        emit(CatalogFailure("Invalid headers in the Excel sheet"));
        return;
      }

      final products = <Product>[];

      for (int i = 1; i < table.rows.length; i++) {
        final row = table.rows[i];
        final dataMap = <String, String>{};

        for (int j = 0; j < headers.length; j++) {
          final key = headers[j];
          final value = (j < row.length ? row[j]?.value?.toString().trim() : "") ?? "";
          dataMap[key] = value;
        }

        try {
          final product = Product.fromJson({
            "productId": uuid.v4(),
            "shopId": shopId,
            "productName": dataMap["product name"] ?? "",
            "productDescription": dataMap["product description"] ?? "",
            "productCategory": dataMap["product category"] ?? "",
            "price": double.tryParse(dataMap["price"] ?? "") ?? 0.0,
            "quantity": int.tryParse(dataMap["quantity/stock"] ?? "") ?? 0,
            "productImages": dataMap["product images"] ?? "",
            "brand": dataMap["brand"] ?? "",
            "discountOrOffers": dataMap["discount or offers"] ?? "",
            "productLocation": dataMap["product location"] ?? "",
            "deliveryTime": dataMap["delivery time"] ?? "",
            "productRating": int.tryParse(dataMap["product rating"] ?? "") ?? 0,
            "availabilityStatus": dataMap["availability status"] ?? "",
            "warranty": dataMap["warranty"] ?? "",
          });

          products.add(product);
          await addProductRepo.addProduct(product);
        } catch (e) {
          print("Row $i skipped due to error: $e");
        }
      }

      if (products.isEmpty) {
        emit(CatalogFailure("No valid products found in the file."));
      } else {
        emit(CatalogUploadSuccess(products));
      }
    } catch (e) {
      emit(CatalogFailure("Upload Error: ${e.toString()}"));
    }
  }

  Future<void> _onDownloadSampleExcel(
      DownloadSampleExcel event,
      Emitter<CatalogState> emit,
      ) async {
    try {
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // sheet.appendRow([
      //   'Product Name',
      //   'Description',
      //   'Category',
      //   'Price (INR)',
      //   'Stock Quantity',
      //   'Image URLs',
      //   'Brand',
      //   'Discount / Offer',
      //   'Location',
      //   'Delivery Estimate',
      //   'Rating',
      //   'Availability',
      //   'Warranty Details',
      // ]);

      final encoded = excel.encode();
      if (encoded == null) throw Exception("Failed to encode Excel");

      final directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final path = '${directory.path}/sample_product_data.xlsx';
      final file = File(path);
      await file.writeAsBytes(encoded);

      emit(CatalogDownloadSuccess());
    } catch (e) {
      emit(CatalogFailure("Download Error: ${e.toString()}"));
    }
  }

}
