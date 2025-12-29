# Challenge Key: Mobile SecOps Troubleshooting

**Development Team – TeamOne**
- Muhammad Izwan bin Ahmad
- Ahmad Azfar Hakimi bin Mohammad Fauzy
- Afiq Danial bin Mohd Asrinnihar

This guide contains the solutions for the intentional bugs introduced in the Rentverse Mobile App for the troubleshooting session.

## 1. Authorization Header Bug
*   **File**: `lib/core/network/interceptors.dart`
*   **Issue**: Typo in header key (`authorizatiom`) and missing space in value (`Bearer$token`).
*   **Fix**:
    ```dart
    // Before: options.headers['authorizatiom'] = 'Bearer$token';
    // After:  options.headers['Authorization'] = 'Bearer $token';
    ```

## 2. OTP Endpoint Typos
*   **File**: `lib/features/auth/data/source/auth_api_service.dart`
*   **Issue**: Incorrect endpoint paths.
    *   Send OTP: `/auth/otp/sent` (should be `/auth/otp/send`)
    *   Verify OTP: `/auth/otp/verifi` (should be `/auth/otp/verify`)
*   **Fix**: Correct the paths in the `post` calls.

## 3. Token Refresh Logic Bug
*   **File**: `lib/features/auth/data/repository/auth_repository_impl.dart`
*   **Issue**: Trying to access a nested `data['data']` map that doesn't exist in the parsed object.
*   **Fix**:
    ```dart
    // Before: if (data != null && data['data'] != null) { ... }
    // After:  if (data != null) { 
    //            final newAccessToken = data['accessToken'] as String?;
    //            ... 
    //         }
    ```

## 4. Local Storage Token Corruption
*   **File**: `lib/features/auth/data/source/auth_local_service.dart`
*   **Issue**: 
    1. Saving with the key `"TOKEN_KEY"` (string) instead of the constant `TOKEN_KEY`.
    2. Adding a leading space `" $token"` which corrupts the token string.
*   **Fix**:
    ```dart
    // Before: await _sharedPreferences.setString("TOKEN_KEY", " $token");
    // After:  await _sharedPreferences.setString(TOKEN_KEY, token);
    ```

## 5. Network Security Hardening (Bonus/Requirement)
*   **Task**: Enforce HTTPS and disable cleartext traffic.
*   **Steps**:
    1.  Create `android/app/src/main/res/xml/network_security_config.xml`.
    2.  Add domain config for `rvapi.ilhamdean.cloud`.
    3.  Update `AndroidManifest.xml` to set `android:usesCleartextTraffic="false"` and point to the config.

## 6. Incorrect OTP Response Casting
*   **File**: `lib/features/auth/data/source/auth_api_service.dart`
*   **Issue**: Methods `sendOtp` and `verifyOtp` were hardcoded to cast the response data as `Map<String, int>`.
*   **Analysis**: If the backend returns string UUIDs or tokens, the cast fails with a `TypeError`.
*   **Fix**: Change to `Map<String, dynamic>`.

## 7. Exception Silencing in Repository
*   **File**: `lib/features/auth/data/repository/auth_repository_impl.dart`
*   **Issue**: `sendOtp` and `verifyOtp` only caught `DioException`.
*   **Analysis**: Deserialization errors (like the `TypeError` above) were escaping the try-catch block, resulting in silent failures in the UI.
*   **Fix**: Add a generic `catch (e)` block to wrap all errors into a `DataFailed` state.
