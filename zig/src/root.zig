const std = @import("std");
const secp256k1 = @import("secp256k1");

const SchnorrTestFixture = struct {
    arena: std.heap.ArenaAllocator,
    secp: secp256k1.Secp256k1,
    msgBytes: [32]u8,
    pubkey: secp256k1.PublicKey,
    validSig: secp256k1.schnorr.Signature,
    invalidSig: secp256k1.schnorr.Signature,

    fn init(allocator: std.mem.Allocator) !SchnorrTestFixture {
        var arena = std.heap.ArenaAllocator.init(allocator);
        errdefer arena.deinit();

        var secp = secp256k1.Secp256k1.genNew();
        errdefer secp.deinit();

        // Test data
        const msgHex = "9d4d03db789aa24eb4384853f5a1ba13009f6d56050282cecbdf640b7c31372e";
        const pubkeyHex = "03d84287e84f3b682fbf1ecdb2cb52bd7c660d7dcd698623be293453c4931013d5";
        const validSigHex = "255e4fae3aea4c6d9c905b92afe4d076702ac477b5e7004b2b05a40b41b3b96e0e9e05f3c8a6f6348893bff98c74e259813e8879b37a1b7bce8f6dc5903e2ded";
        const invalidSigHex = "988f3180dd81c724b6109aab9e5eff0917aa89359f120a5b658de634a8ca2213136dfd934a769e2891999129e83a39d3a5c42db645ed81233f74d7c19c997aba";

        // Deserialize
        var msgBytes: [32]u8 = undefined;
        _ = try std.fmt.hexToBytes(&msgBytes, msgHex);
        const pubkey = try secp256k1.PublicKey.fromString(pubkeyHex);
        const validSig = try secp256k1.schnorr.Signature.fromStr(validSigHex);
        const invalidSig = try secp256k1.schnorr.Signature.fromStr(invalidSigHex);

        return SchnorrTestFixture{
            .arena = arena,
            .secp = secp,
            .msgBytes = msgBytes,
            .pubkey = pubkey,
            .validSig = validSig,
            .invalidSig = invalidSig,
        };
    }

    fn deinit(self: *SchnorrTestFixture) void {
        self.secp.deinit();
        self.arena.deinit();
    }
};

test "schnorr verify valid signature" {
    const testing = std.testing;
    var fixture = try SchnorrTestFixture.init(testing.allocator);
    defer fixture.deinit();

    // Verify valid signature - should succeed
    try fixture.pubkey.verify(&fixture.secp, &fixture.msgBytes, fixture.validSig);
}

test "schnorr verify invalid signature" {
    const testing = std.testing;
    var fixture = try SchnorrTestFixture.init(testing.allocator);
    defer fixture.deinit();

    // Verify invalid signature - should fail
    const result = fixture.pubkey.verify(&fixture.secp, &fixture.msgBytes, fixture.invalidSig);
    try testing.expectError(error.InvalidSignature, result);
}
