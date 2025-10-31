// lib/data/repositories/mysql_repository.dart
import '../models/gif_model.dart';
import '../../services/mysql_services.dart';

class MySQLRepository {
  final MySQLService _mysql;

  MySQLRepository(this._mysql);

  // ==================== FAVORITOS ====================
Future<List<GifModel>> getFavorites() async {
    try {
      if (!_mysql.isConnected) {
        print('MySQL não conectado ao buscar favoritos');
        return [];
      }
      
      final results = await _mysql.connection!.query(
        'SELECT id, title, url FROM favorites ORDER BY created_at DESC'
      );

      print('✅ ${results.length} favoritos encontrados');

      return results.map((row) {
        final id = _convertToString(row['id']);
        final title = _convertToString(row['title']);
        final url = _convertToString(row['url']);
        
        print('Favorito: $id - $title');
        
        return GifModel(
          id: id,
          title: title,
          url: url,
        );
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar favoritos: $e');
      return [];
    }
  }

  Future<void> addFavorite(GifModel gif) async {
    try {
      if (!_mysql.isConnected) {
        print('MySQL não conectado ao adicionar favorito');
        return;
      }
      
      // Verificar se já existe antes de inserir
      final exists = await isFavorite(gif.id);
      if (exists) {
        print('⚠️ Favorito já existe: ${gif.id}');
        return;
      }
      
      await _mysql.connection!.query(
        'INSERT INTO favorites (id, title, url) VALUES (?, ?, ?)',
        [gif.id, gif.title, gif.url],
      );
      
      print('✅ Favorito adicionado: ${gif.id} - ${gif.title}');
    } catch (e) {
      print('❌ Erro ao adicionar favorito: $e');
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      if (!_mysql.isConnected) {
        print('MySQL não conectado ao remover favorito');
        return;
      }
      
      await _mysql.connection!.query(
        'DELETE FROM favorites WHERE id = ?',
        [id],
      );
      
      print('✅ Favorito removido: $id');
    } catch (e) {
      print('❌ Erro ao remover favorito: $e');
    }
  }

  Future<bool> isFavorite(String id) async {
    try {
      if (!_mysql.isConnected) return false;
      
      final results = await _mysql.connection!.query(
        'SELECT COUNT(*) as count FROM favorites WHERE id = ?',
        [id],
      );
      
      final count = results.first['count'] as int;
      return count > 0;
    } catch (e) {
      print('❌ Erro ao verificar favorito: $e');
      return false;
    }
  }


  // ==================== HISTÓRICO ====================

  Future<List<String>> getSearchHistory() async {
    try {
      if (!_mysql.isConnected) return [];
      
      final results = await _mysql.connection!.query(
        'SELECT tag FROM search_history ORDER BY created_at DESC LIMIT 10'
      );

      return results.map((row) => row['tag'] as String).toList();
    } catch (e) {
      print('Erro ao buscar histórico: $e');
      return [];
    }
  }

  Future<void> addToHistory(String tag) async {
    try {
      if (!_mysql.isConnected) return;
      
      // INSERT com ON DUPLICATE KEY para atualizar timestamp se já existir
      await _mysql.connection!.query(
        '''
        INSERT INTO search_history (tag, created_at) 
        VALUES (?, NOW()) 
        ON DUPLICATE KEY UPDATE created_at = NOW()
        ''',
        [tag],
      );
    } catch (e) {
      print('Erro ao adicionar ao histórico: $e');
    }
  }

  Future<void> removeFromHistory(String tag) async {
    try {
      if (!_mysql.isConnected) return;
      
      await _mysql.connection!.query(
        'DELETE FROM search_history WHERE tag = ?',
        [tag],
      );
    } catch (e) {
      print('Erro ao remover do histórico: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      if (!_mysql.isConnected) return;
      
      await _mysql.connection!.query('DELETE FROM search_history');
    } catch (e) {
      print('Erro ao limpar histórico: $e');
    }
  }

  // ==================== PREFERÊNCIAS ====================

  Future<void> setPreference(String key, String value) async {
    try {
      if (!_mysql.isConnected) return;
      
      await _mysql.connection!.query(
        '''
        INSERT INTO preferences (key_name, value) 
        VALUES (?, ?) 
        ON DUPLICATE KEY UPDATE value = ?, updated_at = NOW()
        ''',
        [key, value, value],
      );
    } catch (e) {
      print('Erro ao salvar preferência: $e');
    }
  }

  Future<String?> getPreference(String key) async {
    try {
      if (!_mysql.isConnected) return null;
      
      final results = await _mysql.connection!.query(
        'SELECT value FROM preferences WHERE key_name = ?',
        [key],
      );

      if (results.isEmpty) return null;
      return results.first['value'] as String?;
    } catch (e) {
      print('Erro ao buscar preferência: $e');
      return null;
    }
  }

  Future<void> removePreference(String key) async {
    try {
      if (!_mysql.isConnected) return;
      
      await _mysql.connection!.query(
        'DELETE FROM preferences WHERE key_name = ?',
        [key],
      );
    } catch (e) {
      print('Erro ao remover preferência: $e');
    }
  }


  String _convertToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}