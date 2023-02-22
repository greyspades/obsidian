import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;
import 'dart:convert';

String encryption(String plainText, String plainKey, String plainIV) {
  final key = Key.fromUtf8(plainKey);
  final iv = IV.fromUtf8(plainIV);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}

String decryption(String plainText, String plainKey, String plainIV) {
  final key = Key.fromUtf8(plainKey);
  final iv = IV.fromUtf8(plainIV);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final decrypted = encrypter.decrypt(Encrypted.from64(plainText), iv: iv);

  return decrypted;
}

String base64ToHex(String source) =>
    base64Decode(LineSplitter.split(source).join())
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join();

dynamic extractPayload(String payload, String keyString, String ivString) {
  var iv = CryptoPack.sha256
      .convert(ConvertPack.utf8.encode(ivString))
      .toString()
      .substring(0, 16); // Consider the first 16 bytes of all 64 bytes
  var key = CryptoPack.sha256
      .convert(ConvertPack.utf8.encode(keyString))
      .toString()
      .substring(0, 32); // Consider the first 32 bytes of all 64 bytes
  IV ivObj = EncryptPack.IV.fromUtf8(iv);
  Key keyObj = EncryptPack.Key.fromUtf8(key);
  final encrypter = EncryptPack.Encrypter(
      EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc)); // Apply CBC mode
  String firstBase64Decoding = String.fromCharCodes(
      ConvertPack.base64.decode(payload)); // First Base64 decoding
  final decrypted = encrypter.decrypt(
      EncryptPack.Encrypted.fromBase64(firstBase64Decoding),
      iv: ivObj);
  //  // Second Base64 decoding (during decryption)
  // return decrypted;

  return firstBase64Decoding;
}
