import 'package:flutter/material.dart';

IconData getCategoryIcon(int code) {
  switch (code) {
    case 0xe59c:
      return Icons.store_mall_directory_rounded;
    case 0xe532:
      return Icons.restaurant_rounded;
    case 0xe3f7:
      return Icons.local_hospital_rounded;
    case 0xe559:
      return Icons.school_rounded;
    case 0xe1b1:
      return Icons.laptop_mac_rounded;
    case 0xe08f:
      return Icons.account_balance_rounded;
    case 0xe068:
      return Icons.domain_rounded;
    case 0xe84f:
      return Icons.precision_manufacturing_rounded;
    case 0xe30b:
      return Icons.inventory_2_rounded;
    case 0xe3b6:
      return Icons.local_shipping_rounded;
    case 0xe070:
      return Icons.agriculture_rounded;
    case 0xe2e2:
      return Icons.gavel_rounded;
    case 0xe0ee:
      return Icons.badge_rounded;
    case 0xe163:
      return Icons.campaign_rounded;
    case 0xe318:
      return Icons.hotel_rounded;
    case 0xe5fc:
      return Icons.spa_rounded;
    case 0xe317:
      return Icons.home_repair_service_rounded;
    case 0xe1d7:
      return Icons.directions_car_rounded;
    case 0xe06e:
      return Icons.account_balance_rounded;
    case 0xe412:
      return Icons.business_center_rounded;
    case 0xe602:
      return Icons.store_mall_directory_rounded;
    case 0xe3a8:
      return Icons.local_shipping_rounded;
    case 0xe2f1:
      return Icons.hardware_rounded;
    case 0xe3a6:
      return Icons.local_pharmacy_rounded;
    case 0xe003:
      return Icons.account_balance_rounded;
    case 0xe6f2:
      return Icons.work_rounded;
    case 0xe466:
      return Icons.palette_rounded;
    default:
      // ignore: non_const_argument_for_const_parameter
      return IconData(code, fontFamily: 'MaterialIcons');
  }
}
