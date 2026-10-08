/**
 * 
 */
package com.koreab2b.mro.util;

import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * @author jiwon
 *
 */
public class HmacSha256Util {
	// 바이트 배열을 16진수 문자열로 변환 메서드
	private static String bytesToHex(byte[] bytes) {
		StringBuilder hexString = new StringBuilder();
		for (byte b : bytes) {
			String hex = Integer.toHexString(0xFF & b);
			if (hex.length() == 1) hexString.append('0');
			hexString.append(hex);
		}
		return hexString.toString();
	}

	public static String hmacGenerate(String method, String uri, String clientId, String secretKey) {
		String[] parts = uri.split("\\?");
		if (parts.length > 2) throw new RuntimeException("invalid uri format");

		String queryString = "";
		if (parts.length == 2) queryString = parts[1];

		SimpleDateFormat dateFormatGmt = new SimpleDateFormat("yyyyMMddHHmmss");
		dateFormatGmt.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
		String timestamp = dateFormatGmt.format(new Date());
		
		// 메세지 조합
		String message = timestamp + method + queryString + secretKey;
		
		// HMAC 알고리즘
		String algorithm = "HmacSHA256";
		// secretKey 바이트 배열로 변환
		byte[] secretKeyBytes = secretKey.getBytes(StandardCharsets.UTF_8);
		String signature = "";
		try {
			SecretKeySpec secretKeySpec = new SecretKeySpec(secretKeyBytes, algorithm);
			// MAC 객체 생성
			Mac mac = Mac.getInstance(algorithm);
			mac.init(secretKeySpec);
			// 메시지를 바이트 배열로 변환하여 HMAC 생성
			byte[] hmacBytes = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
			// HMAC을 HEX 문자열로 변환
			signature = bytesToHex(hmacBytes);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// ex) client_id=HANJIN timestamp=20230730121212 signature=HASH값 ?? 각 값의 사이에는 공백포함
		String authorization = String.format("client_id=%s timestamp=%s signature=%s",
				new Object[] { clientId, timestamp, signature });
		return authorization;
	}
}
