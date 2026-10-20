package com.shopsphere.common.config;

import java.io.InputStream;
import java.util.Properties;

/**
 * Centralized Configuration Manager adhering to Twelve-Factor App principles.
 * Inspects Environment Variables first, System Properties second, and application.properties fallback.
 */
public class AppConfig {

    private static final Properties properties = new Properties();

    static {
        try (InputStream in = AppConfig.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (in != null) {
                properties.load(in);
            }
        } catch (Exception ignored) {}
    }

    private AppConfig() {}

    public static String get(String key, String defaultValue) {
        String envKey = key.toUpperCase().replace('.', '_');
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) {
            return envVal.trim();
        }

        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }

        return properties.getProperty(key, defaultValue);
    }

    public static int getInt(String key, int defaultValue) {
        String val = get(key, null);
        if (val != null) {
            try {
                return Integer.parseInt(val);
            } catch (NumberFormatException ignored) {}
        }
        return defaultValue;
    }

    public static boolean getBoolean(String key, boolean defaultValue) {
        String val = get(key, null);
        if (val != null) {
            return Boolean.parseBoolean(val);
        }
        return defaultValue;
    }

    // Standard Database Configs
    public static String getDbHost() { return get("db.host", "localhost"); }
    public static int getDbPort() { return getInt("db.port", 3306); }
    public static String getDbName() { return get("db.name", "shopsphere"); }
    public static String getDbUser() { return get("db.user", "shopsphere_user"); }
    public static String getDbPassword() { return get("db.password", "shopsphere_pass"); }
    public static int getDbMaxPoolSize() { return getInt("db.pool.max", 10); }

    // RMI & Network Configs
    public static int getRmiPort() { return getInt("rmi.port", 1099); }
    public static String getRmiHost() { return get("rmi.host", "localhost"); }
    public static int getNetworkPort() { return getInt("network.port", 9090); }
}

