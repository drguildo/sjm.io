+++
title = "Verifying RSA signatures using .NET and C#"
date = "2020-02-29"
+++

I recently found myself wanting a system to cryptographically sign and
verify files. I came up with the following method which uses a
combination of the OpenSSL command-line utility and the .NET
RSA class. I used the version that's part of .NET Core 3.1.

This post assumes some familiarity with encryption, specifically
public/private key encryption.

First we generate the public and private keys and sign the file:

```
# Generate the private key.
openssl genpkey -algorithm rsa -out privkey.pem -pkeyopt rsa_keygen_bits:4096
# Generate the corresponding public key
openssl rsa -in privkey.pem -outform PEM -pubout -out pubkey.pem
# Sign important.zip, storing the signature in important.zip.sig
openssl dgst -sha256 -sign privkey.pem -out important.zip.sig important.zip
```

The code for verifying the file signature should be fairly
straightforward. By default OpenSSL stores the keys in PEM format. The
.NET cryptography library doesn't seem to support loading these directly
and so I had to write some supporting code for wrangling the PEM file
into a format that the RSA class would like, specifically a byte array.

```cs
internal class RsaSignatureVerifier : IDisposable
{
    private readonly RSA _rsa;

    /// <summary>
    /// Create a new instance of <see cref="RsaSignatureVerifier"/>.
    /// </summary>
    /// <param name="publicKeyPath">
    /// The path to the public key corresponding to the private key that was used to sign files.
    /// </param>
    public RsaSignatureVerifier(string publicKeyPath)
    {
        _rsa = RSA.Create();

        byte[] pubKey = ReadPemPublicKey(publicKeyPath);

        _rsa.ImportSubjectPublicKeyInfo(pubKey, out _);
    }

    /// <summary>
    /// Verifies the specified file using the specified <see cref="RSA"/> signature. The digest
    /// used is <see cref="HashAlgorithmName.SHA256"/>.
    /// </summary>
    /// <param name="fileToVerifyPath">The path of the file to verify.</param>
    /// <param name="fileSignaturePath">
    /// The path of the signature used to verify the specified file.
    /// </param>
    /// <returns>Whether the file was verified successfully.</returns>
    public bool Verify(string fileToVerifyPath, string fileSignaturePath)
    {
        var fileToVerifyStream = new FileStream(fileToVerifyPath, FileMode.Open);
        byte[] signatureBytes = File.ReadAllBytes(fileSignaturePath);
        return _rsa.VerifyData(fileToVerifyStream, signatureBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
    }

    /// <summary>
    /// Reads a PEM encoded public key and returns the corresponding binary key.
    /// </summary>
    /// <param name="publicKeyPath">The path to the PEM encoded key.</param>
    /// <returns>The corresponding binary key.</returns>
    private byte[] ReadPemPublicKey(string publicKeyPath)
    {
        string encodedPublicKey = File
            .ReadAllText(publicKeyPath)
            .Replace("-----BEGIN PUBLIC KEY-----", string.Empty)
            .Replace("-----END PUBLIC KEY-----", string.Empty)
            .Trim();

        return Convert.FromBase64String(encodedPublicKey);
    }

    public void Dispose()
    {
        _rsa.Dispose();
    }
}
```

Hope this helps.
