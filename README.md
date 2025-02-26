This repro demonstrates a problem I'm experiencing with [libsecp256k1-zig](https://github.com/zig-bitcoin/libsecp256k1-zig).

I have zig and typescript implementations of the same test that attempt to verify 2 signatures -- one valid, one invalid. These two implementations disagree about which are valid and invalid. I'm pretty sure the typescript implementation is correct, because I encountered this behavior attmepting to sign nostr notes and the relay would accept typescript-signed notes and reject zig-signed notes.

I'm using zig version `0.14.0-dev.3012+3348478fc` and bun version `1.2.2`.

Both [zig testcases](./zig/src/root.zig) fail:

```bash
$ zig run test
...
Build Summary: 5/7 steps succeeded; 1 failed; 0/2 tests passed; 2 failed
test transitive failure
└─ run test 0/2 passed, 2 failed
...
```


Both [javascript testcases](./js/repro.test.ts) fail:

```bash
$ bun test
bun test v1.2.2 (c1708ea6)

repro.test.ts:
✓ valid signature [25.98ms]
✓ invalid signature [2.42ms]

 2 pass
 0 fail
```
