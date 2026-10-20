package com.shopsphere.dao.db;

import com.shopsphere.common.config.AppConfig;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;
import java.io.File;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Production Database Connection Pool utilizing HikariCP.
 * Features automated MySQL detection with intelligent embedded H2 fallback for zero-dependency local testing.
 */
public class DBConnectionPool {

    private static final Logger logger = LoggerFactory.getLogger(DBConnectionPool.class);
    private static volatile HikariDataSource dataSource;
    private static final Object lock = new Object();
    private static boolean isEmbeddedMode = false;

    private DBConnectionPool() {}

    public static DataSource getDataSource() {
        if (dataSource == null) {
            synchronized (lock) {
                if (dataSource == null) {
                    initDataSource();
                }
            }
        }
        return dataSource;
    }

    private static void initDataSource() {
        boolean mysqlReachable = isPortOpen(AppConfig.getDbHost(), AppConfig.getDbPort(), 1500);

        if (mysqlReachable) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                HikariConfig config = new HikariConfig();

                String jdbcUrl = String.format(
                        "jdbc:mysql://%s:%d/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8",
                        AppConfig.getDbHost(),
                        AppConfig.getDbPort(),
                        AppConfig.getDbName()
                );

                config.setJdbcUrl(jdbcUrl);
                config.setUsername(AppConfig.getDbUser());
                config.setPassword(AppConfig.getDbPassword());
                config.setMaximumPoolSize(AppConfig.getDbMaxPoolSize());
                config.setMinimumIdle(2);
                config.setIdleTimeout(30000);
                config.setConnectionTimeout(10000);
                config.setMaxLifetime(1800000);
                config.setPoolName("shopsphere-MySQL-Pool");

                config.addDataSourceProperty("cachePrepStmts", "true");
                config.addDataSourceProperty("prepStmtCacheSize", "250");
                config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

                dataSource = new HikariDataSource(config);
                logger.info("Connected to MySQL at {}:{}", AppConfig.getDbHost(), AppConfig.getDbPort());
                return;
            } catch (Exception e) {
                logger.warn("MySQL pool initialization failed: {}. Falling back to embedded mode.", e.getMessage());
            }
        }

        // Embedded H2 Database Fallback (In MySQL compatibility mode)
        try {
            isEmbeddedMode = true;
            Class.forName("org.h2.Driver");
            String homeDir = System.getProperty("user.home");
            File dbDir = new File(homeDir, ".shopsphere");
            if (!dbDir.exists()) {
                dbDir.mkdirs();
            }

            String h2Url = String.format("jdbc:h2:%s/h2_shopsphere;MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;DB_CLOSE_DELAY=-1;AUTO_SERVER=TRUE",
                    dbDir.getAbsolutePath());

            HikariConfig h2Config = new HikariConfig();
            h2Config.setJdbcUrl(h2Url);
            h2Config.setUsername("sa");
            h2Config.setPassword("");
            h2Config.setMaximumPoolSize(10);
            h2Config.setMinimumIdle(2);
            h2Config.setPoolName("shopsphere-H2-EmbeddedPool");

            dataSource = new HikariDataSource(h2Config);
            logger.info("Activated embedded database at {}", h2Url);

            // Initialize tables & seed data if fresh database
            try (Connection conn = dataSource.getConnection()) {
                DatabaseInitializer.initializeIfEmpty(conn);
            }
        } catch (Exception e) {
            logger.error("Failed to initialize embedded database pool: {}", e.getMessage(), e);
        }
    }

    private static boolean isPortOpen(String host, int port, int timeoutMs) {
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(host, port), timeoutMs);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource != null && !dataSource.isClosed()) {
            return dataSource.getConnection();
        }
        initDataSource();
        if (dataSource != null) {
            return dataSource.getConnection();
        }
        throw new SQLException("Database connection pool is uninitialized");
    }

    public static boolean isEmbedded() {
        return isEmbeddedMode;
    }

    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            logger.info("Closing HikariCP database pool...");
            dataSource.close();
            dataSource = null;
        }
    }
}

