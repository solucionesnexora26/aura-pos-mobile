import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../entities/product_entity.dart';

class ExcelUtils {
  ExcelUtils._();

  static const _uuid = Uuid();

  static const _headers = [
    'nombre',
    'descripcion',
    'sku',
    'codigo_barras',
    'categoria',
    'marca',
    'precio',
    'costo',
    'impuesto_%',
    'tipo_unidad',
    'controlar_stock',
    'stock',
    'stock_minimo',
    'tiene_variantes',
    'activo',
  ];

  static const _unitTypes = {
    'unidad': 'unit',
    'kg': 'weightKg',
    'g': 'weightG',
    'lb': 'weightLb',
  };

  static Future<void> downloadTemplate() async {
    final excel = Excel.createExcel();
    excel.rename('Plantilla', 'Plantilla Productos');

    final sheet = excel['Plantilla Productos'];

    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#5B5FEF'),
      fontColorHex: ExcelColor.white,
      horizontalAlign: HorizontalAlign.Center,
    );

    for (var i = 0; i < _headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(_headers[i]);
      cell.cellStyle = headerStyle;
    }

    sheet.setColumnWidth(0, 25);
    sheet.setColumnWidth(1, 30);
    sheet.setColumnWidth(2, 15);
    sheet.setColumnWidth(3, 15);
    sheet.setColumnWidth(4, 15);
    sheet.setColumnWidth(5, 15);
    sheet.setColumnWidth(6, 12);
    sheet.setColumnWidth(7, 12);
    sheet.setColumnWidth(8, 10);
    sheet.setColumnWidth(9, 12);
    sheet.setColumnWidth(10, 12);
    sheet.setColumnWidth(11, 10);
    sheet.setColumnWidth(12, 12);
    sheet.setColumnWidth(13, 12);
    sheet.setColumnWidth(14, 8);

    final exampleData = [
      ['Café Americano', 'Café negro 250ml', 'CAFE001', '7501234567890', 'Bebidas', 'Café Plus', '35.00', '15.00', '16', 'unidad', 'si', '100', '10', 'no', 'si'],
      ['Croissant', 'Croissant de mantequilla', 'CRO001', '7501234567891', 'Panadería', '', '28.00', '10.00', '16', 'unidad', 'si', '50', '5', 'no', 'si'],
      ['Jugo de Naranja', 'Jugo natural 500ml', 'JUGO001', '7501234567892', 'Bebidas', 'Fruta Fresca', '45.00', '20.00', '16', 'unidad', 'si', '30', '5', 'no', 'si'],
    ];

    for (var row = 0; row < exampleData.length; row++) {
      for (var col = 0; col < exampleData[row].length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        cell.value = TextCellValue(exampleData[row][col]);
      }
    }

    final instructionsSheet = excel['Instrucciones'];
    final instructions = [
      ['Campo', 'Requerido', 'Descripción', 'Ejemplo'],
      ['nombre', 'Sí', 'Nombre del producto', 'Café Americano'],
      ['descripcion', 'No', 'Descripción del producto', 'Café negro 250ml'],
      ['sku', 'No', 'Código SKU único', 'CAFE001'],
      ['codigo_barras', 'No', 'Código de barras (EAN/UPC)', '7501234567890'],
      ['categoria', 'No', 'Nombre de la categoría', 'Bebidas'],
      ['marca', 'No', 'Nombre de la marca', 'Café Plus'],
      ['precio', 'Sí', 'Precio de venta (número)', '35.00'],
      ['costo', 'No', 'Costo de adquisición', '15.00'],
      ['impuesto_%', 'No', 'Porcentaje de impuesto', '16'],
      ['tipo_unidad', 'No', 'unidad, kg, g, lb', 'unidad'],
      ['controlar_stock', 'No', 'si o no', 'si'],
      ['stock', 'No', 'Cantidad en inventario', '100'],
      ['stock_minimo', 'No', 'Umbral de stock bajo', '10'],
      ['tiene_variantes', 'No', 'si o no', 'no'],
      ['activo', 'No', 'si o no (default: si)', 'si'],
    ];

    for (var row = 0; row < instructions.length; row++) {
      for (var col = 0; col < instructions[row].length; col++) {
        final cell = instructionsSheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
        cell.value = TextCellValue(instructions[row][col]);
        if (row == 0) {
          cell.cellStyle = CellStyle(
            bold: true,
            backgroundColorHex: ExcelColor.fromHexString('#5B5FEF'),
            fontColorHex: ExcelColor.white,
          );
        }
      }
    }

    instructionsSheet.setColumnWidth(0, 18);
    instructionsSheet.setColumnWidth(1, 12);
    instructionsSheet.setColumnWidth(2, 40);
    instructionsSheet.setColumnWidth(3, 25);

    final fileBytes = excel.save();
    if (fileBytes == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/plantilla_productos.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(fileBytes, flush: true);

    await Share.shareXFiles([XFile(filePath)], text: 'Plantilla de productos Aura POS');
  }

  static Future<List<Map<String, dynamic>>> importFromExcel(Uint8List fileBytes) async {
    final excel = Excel.decodeBytes(fileBytes);
    if (excel.tables.isEmpty) return [];

    Sheet? dataSheet;
    for (final sheet in excel.tables.values) {
      if (sheet.maxRows < 1 || sheet.maxColumns < 1) continue;
      final firstCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
      final header = firstCell.value?.toString().toLowerCase().trim();
      if (header == 'nombre') {
        dataSheet = sheet;
        break;
      }
    }

    if (dataSheet == null) {
      for (final sheet in excel.tables.values) {
        if (sheet.maxRows < 2) continue;
        dataSheet = sheet;
        break;
      }
    }

    if (dataSheet == null) return [];
    if (dataSheet.maxRows < 2) return [];

    final headers = <String>[];
    for (var col = 0; col < dataSheet.maxColumns; col++) {
      final cell = dataSheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      headers.add(cell.value?.toString().toLowerCase().replaceAll(' ', '_') ?? '');
    }

    final products = <Map<String, dynamic>>[];

    for (var row = 1; row < dataSheet.maxRows; row++) {
      final name = _getCellValue(dataSheet, row, headers.indexOf('nombre'));
      if (name == null || name.isEmpty) continue;

      final product = <String, dynamic>{
        'name': name,
        'description': _getCellValue(dataSheet, row, headers.indexOf('descripcion')),
        'sku': _getCellValue(dataSheet, row, headers.indexOf('sku')),
        'barcode': _getCellValue(dataSheet, row, headers.indexOf('codigo_barras')),
        'categoryName': _getCellValue(dataSheet, row, headers.indexOf('categoria')),
        'brandName': _getCellValue(dataSheet, row, headers.indexOf('marca')),
        'price': _parseDouble(_getCellValue(dataSheet, row, headers.indexOf('precio')) ?? '0'),
        'cost': _parseDouble(_getCellValue(dataSheet, row, headers.indexOf('costo')) ?? '0'),
        'taxRate': _parseDouble(_getCellValue(dataSheet, row, headers.indexOf('impuesto_%')) ?? '16'),
        'unitType': _mapUnitType(_getCellValue(dataSheet, row, headers.indexOf('tipo_unidad'))),
        'trackStock': _parseBool(_getCellValue(dataSheet, row, headers.indexOf('controlar_stock'))),
        'stockQuantity': _parseDouble(_getCellValue(dataSheet, row, headers.indexOf('stock')) ?? '0'),
        'lowStockThreshold': _parseDouble(_getCellValue(dataSheet, row, headers.indexOf('stock_minimo')) ?? '0'),
        'hasVariants': _parseBool(_getCellValue(dataSheet, row, headers.indexOf('tiene_variantes'))),
        'isActive': _parseBool(_getCellValue(dataSheet, row, headers.indexOf('activo'))),
        'id': _uuid.v4(),
      };

      products.add(product);
    }

    return products;
  }

  static String? _getCellValue(Sheet sheet, int row, int col) {
    if (col < 0) return null;
    final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
    return cell.value?.toString();
  }

  static double _parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0;
  }

  static bool _parseBool(String? value) {
    if (value == null) return true;
    final lower = value.toLowerCase();
    return lower == 'si' || lower == 'sí' || lower == 'true' || lower == '1' || lower == 'yes';
  }

  static ProductUnitTypeEntity _mapUnitType(String? value) {
    if (value == null) return ProductUnitTypeEntity.unit;
    final lower = value.toLowerCase();
    return switch (lower) {
      'kg' => ProductUnitTypeEntity.weightKg,
      'g' => ProductUnitTypeEntity.weightG,
      'lb' => ProductUnitTypeEntity.weightLb,
      _ => ProductUnitTypeEntity.unit,
    };
  }
}
