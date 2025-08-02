import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopHours {
  final TimeOfDay open;
  final TimeOfDay close;

  ShopHours({required this.open, required this.close});
}

class StoreStatus {
  final bool isOpen;
  final String message;
  final DateTime? nextOpenTime;

  StoreStatus({required this.isOpen, required this.message, this.nextOpenTime});
}

class DynamicDeliveryTime {
  static final Map<int, ShopHours> _hours = {
    // Monday - Saturday
    1: ShopHours(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 18, minute: 0)),
    2: ShopHours(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 18, minute: 0)),
    3: ShopHours(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 18, minute: 0)),
    4: ShopHours(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 18, minute: 0)),
    5: ShopHours(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 18, minute: 0)),
    6: ShopHours(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 18, minute: 0)),
    // Sunday
    7: ShopHours(open: const TimeOfDay(hour: 13, minute: 0), close: const TimeOfDay(hour: 18, minute: 0)),
  };
  
  static StoreStatus getStoreStatus() {
    final now = DateTime.now();
    final today = now.weekday;
    final shopHours = _hours[today]!;

    final nowTime = TimeOfDay.fromDateTime(now);
    
    // Convert TimeOfDay to minutes from midnight for easy comparison
    final openMinutes = shopHours.open.hour * 60 + shopHours.open.minute;
    final closeMinutes = shopHours.close.hour * 60 + shopHours.close.minute;
    final nowMinutes = nowTime.hour * 60 + nowTime.minute;

    final isOpen = nowMinutes >= openMinutes && nowMinutes < closeMinutes;

    if (isOpen) {
      return StoreStatus(isOpen: true, message: "We're open!");
    } else {
      DateTime nextOpenTime;
      // If we are closed but it's before opening time today
      if(nowMinutes < openMinutes){
         nextOpenTime = DateTime(now.year, now.month, now.day, shopHours.open.hour, shopHours.open.minute);
      } else { // We are closed and it's after closing time, so find the next day
          var nextDay = now.add(const Duration(days: 1));
          // Look for the next open day
          while(_hours[nextDay.weekday] == null){
            nextDay = nextDay.add(const Duration(days: 1));
          }
          final nextDayHours = _hours[nextDay.weekday]!;
          nextOpenTime = DateTime(nextDay.year, nextDay.month, nextDay.day, nextDayHours.open.hour, nextDayHours.open.minute);
      }
      return StoreStatus(isOpen: false, message: "We're closed, we open at ${DateFormat.jm().format(nextOpenTime)}.", nextOpenTime: nextOpenTime);
    }
  }

  static String getDeliveryEstimate() {
    final status = getStoreStatus();
    if (status.isOpen) {
      // For simplicity, we'll return a static 14 minutes for now
      return '14 mins';
    } else if (status.nextOpenTime != null) {
      final deliveryTime = status.nextOpenTime!.add(const Duration(minutes: 14));
      return 'Delivery from ${DateFormat.jm().format(deliveryTime)}';
    }
    return '';
  }
}