package com.shopsphere.common.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PasswordHashUtilTest {

    @Test
    @DisplayName("Verify BCrypt hash generation and positive verification")
    void testBCryptHashingAndVerification() {
        String rawPassword = "SecurePassword@2026";
        String hashed = PasswordHashUtil.hash(rawPassword);

        assertNotNull(hashed);
        assertTrue(hashed.startsWith("$2a$"), "Hash should start with BCrypt identifier $2a$");
        assertTrue(PasswordHashUtil.verify(rawPassword, hashed), "Password should match hashed value");
    }

    @Test
    @DisplayName("Verify wrong password is rejected")
    void testWrongPasswordRejected() {
        String rawPassword = "CorrectPassword@123";
        String hashed = PasswordHashUtil.hash(rawPassword);

        assertFalse(PasswordHashUtil.verify("WrongPassword", hashed), "Invalid password must return false");
        assertFalse(PasswordHashUtil.verify("", hashed), "Empty password must return false");
        assertFalse(PasswordHashUtil.verify(null, hashed), "Null password must return false");
    }

    @Test
    @DisplayName("Verify null or empty password cannot be hashed")
    void testNullOrEmptyInputThrowsException() {
        assertThrows(IllegalArgumentException.class, () -> PasswordHashUtil.hash("   "));
        assertThrows(IllegalArgumentException.class, () -> PasswordHashUtil.hash(null));
    }
}

