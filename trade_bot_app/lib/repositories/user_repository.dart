import '../data/users.dart'; // Statik kullanıcı verilerini içe aktarın
import '../models/user_model.dart';

class UserRepository {
  List<Map<String, dynamic>> _users = [
    ...users
  ]; // Statik kullanıcı listesini başlat

  Future<List<Map<String, dynamic>>> _readUsers() async {
    // JSON'u simüle etmek için statik listeyi döndür
    return _users;
  }

  Future<void> _writeUsers(List<Map<String, dynamic>> updatedUsers) async {
    // Güncellenmiş kullanıcıları listeye yaz
    _users = updatedUsers;
  }

  Future<User> createUser(String username) async {
    final users = await _readUsers();
    if (users.any((user) => user['username'] == username)) {
      throw Exception('User already exists');
    }

    final newUser = {
      "username": username,
      "balance": 10000.0, // Varsayılan bakiye
      "coins": [],
      "history": []
    };

    users.add(newUser);
    await _writeUsers(users);

    return User.fromJson(newUser);
  }

  Future<User> getUser(String username) async {
    final users = await _readUsers();
    final user = users.firstWhere(
      (user) => user['username'] == username,
      orElse: () => throw Exception('User not found'),
    );

    return User.fromJson(user);
  }

  Future<void> resetUser(String username) async {
    final users = await _readUsers();
    final userIndex = users.indexWhere((user) => user['username'] == username);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    users[userIndex]['balance'] = 10000.0;
    users[userIndex]['coins'] = [];
    users[userIndex]['history'] = [];

    await _writeUsers(users);
  }

  Future<void> trade({
    required String username,
    required String symbol,
    required double amount,
    required String action,
    required double currentPrice,
  }) async {
    final usersList = await _readUsers();
    final userIndex =
        usersList.indexWhere((user) => user['username'] == username);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final user = usersList[userIndex];

    if (currentPrice <= 0.0) {
      throw Exception('Invalid coin price');
    }

    if (action == 'BUY') {
      final totalCost = amount * currentPrice;

      if (user['balance'] < totalCost) {
        throw Exception('Insufficient balance to buy');
      }

      user['balance'] -= totalCost;

      // Coin ekle veya güncelle
      final coinIndex =
          user['coins'].indexWhere((coin) => coin['symbol'] == symbol);
      if (coinIndex != -1) {
        user['coins'][coinIndex]['amount'] += amount;
      } else {
        user['coins'].add({'symbol': symbol, 'amount': amount});
      }
    } else if (action == 'SELL') {
      final coinIndex =
          user['coins'].indexWhere((coin) => coin['symbol'] == symbol);
      if (coinIndex == -1 || user['coins'][coinIndex]['amount'] < amount) {
        throw Exception('Insufficient coin amount to sell');
      }

      final totalGain = amount * currentPrice;

      user['balance'] += totalGain;
      user['coins'][coinIndex]['amount'] -= amount;

      if (user['coins'][coinIndex]['amount'] == 0) {
        user['coins'].removeAt(coinIndex);
      }
    }

    // İşlemi kaydet
    user['history'].add({
      'action': action,
      'symbol': symbol,
      'amount': amount,
      'price': currentPrice,
      'date': DateTime.now().toIso8601String(),
    });

    await _writeUsers(usersList);
  }
}
