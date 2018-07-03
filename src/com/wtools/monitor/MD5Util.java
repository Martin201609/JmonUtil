package com.wtools.monitor;

import java.security.MessageDigest;

public class MD5Util
{
	public static String MD5String(String string) {
		byte[] bytes = (byte[]) null;
		MessageDigest messageDigest = null;
		try {
			messageDigest = MessageDigest.getInstance("MD5");
			messageDigest.update(string.getBytes());
			bytes = messageDigest.digest();

			StringBuffer stringBuffer = new StringBuffer();

			for (int i = 0; i < bytes.length; ++i) {
				int digest = bytes[i];

				if (digest < 0) {
					digest += 256;
				}

				if (digest < 16) {
					stringBuffer.append("0");
				}

				stringBuffer.append(Integer.toHexString(digest));
			}

			return stringBuffer.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "";
	}

	public static void main(String[] args) {
		System.out.println(MD5String("1111").toUpperCase());
	}
}
