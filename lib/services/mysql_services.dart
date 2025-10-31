import 'package:mysql1/mysql1.dart';
import '../core/config/mysql_config.dart';

class MySQLService {
  MySqlConnection? _connection;
  
  // Singleton pattern
  static final MySQLService _instance = MySQLService._internal();
  factory MySQLService() => _instance;
  MySQLService._internal();

  // Conectar ao banco
  Future<void> connect() async {
    try {
      _connection = await MySqlConnection.connect(
        ConnectionSettings(
          host: MySQLConfig.host,
          port: MySQLConfig.port,
          user: MySQLConfig.user,
          password: MySQLConfig.password,
          db: MySQLConfig.database,
        ),
      );
      print('✅ Conectado ao MySQL');
      await _createTables();
    } catch (e) {
      print('❌ Erro ao conectar ao MySQL: $e');
      rethrow;
    }
  }

  // Criar tabelas se não existirem
  Future<void> _createTables() async {
    if (_connection == null) return;

    try {
      // Tabela de favoritos
      await _connection!.query('''
        CREATE TABLE IF NOT EXISTS favorites (
          id VARCHAR(50) PRIMARY KEY,
          title TEXT,
          url TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // Tabela de histórico de buscas
      await _connection!.query('''
        CREATE TABLE IF NOT EXISTS search_history (
          id INT AUTO_INCREMENT PRIMARY KEY,
          tag VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE KEY unique_tag (tag)
        )
      ''');

      // Tabela de preferências
      await _connection!.query('''
        CREATE TABLE IF NOT EXISTS preferences (
          key_name VARCHAR(100) PRIMARY KEY,
          value TEXT,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
      ''');

      print('✅ Tabelas criadas/verificadas');
    } catch (e) {
      print('❌ Erro ao criar tabelas: $e');
    }
  }

  // Fechar conexão
  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    print('🔌 Desconectado do MySQL');
  }

  // Getter para conexão
  MySqlConnection? get connection => _connection;
  
  // Verificar se está conectado
  bool get isConnected => _connection != null;
}