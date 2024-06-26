import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/transporter/repository/transporter_repository.dart';
import 'package:medicare/models/order_model.dart';

final transporterControllerProvider = Provider((ref) {
  final transporterRepository = ref.read(transporterRepositoryProvider);
  return TransporterController(transporterRepository: transporterRepository);
});

class TransporterController {
  TransporterController({required this.transporterRepository});
  final TransporterRepository transporterRepository;

  Stream<List<OrderModel>> availableTransporterOrder() {
    return transporterRepository.streamOrdersWithoutTransporter();
  }

  Stream<List<OrderModel>> acceptedOrders() {
    return transporterRepository.streamOrdersForTransporter();
  }

  Future<void> acceptOrder(String orderId) async {
    await transporterRepository.acceptOrder(orderId);
  }

  Future<void> orderCompleted(String orderId) async {
    await transporterRepository.orderCompleted(orderId);
  }
}
