import { schnorr } from '@noble/curves/secp256k1'
import { hexToBytes } from '@noble/hashes/utils';

import { expect, test } from "bun:test";

// Test data
const msg = '9d4d03db789aa24eb4384853f5a1ba13009f6d56050282cecbdf640b7c31372e';
const pubkey = 'd84287e84f3b682fbf1ecdb2cb52bd7c660d7dcd698623be293453c4931013d5';
const validSig = '255e4fae3aea4c6d9c905b92afe4d076702ac477b5e7004b2b05a40b41b3b96e0e9e05f3c8a6f6348893bff98c74e259813e8879b37a1b7bce8f6dc5903e2ded';
const invalidSig = '988f3180dd81c724b6109aab9e5eff0917aa89359f120a5b658de634a8ca2213136dfd934a769e2891999129e83a39d3a5c42db645ed81233f74d7c19c997aba';

// Convert hex strings to byte arrays
const msgBytes = hexToBytes(msg);
const validSigBytes = hexToBytes(validSig);
const invalidSigBytes = hexToBytes(invalidSig);
const pubkeyBytes = hexToBytes(pubkey);

test("valid signature", () => {
    const result = schnorr.verify(validSigBytes, msgBytes, pubkeyBytes);
    expect(result).toBe(true);
})

test("invalid signature", () => {
    const result = schnorr.verify(invalidSigBytes, msgBytes, pubkeyBytes);
    expect(result).toBe(false);
})
