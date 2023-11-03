const MultibootHeader = extern struct {
    magic: u32 = 0xe85250d6,
    flags: u32 = 0,
    length: u32 = @sizeOf(MultibootHeader),
    checksum: u32 = 0x100000000 - (0xe85250d6 + 0 + @sizeOf(MultibootHeader)),
    // ...
    type2: u16 = 0,
    flags2: u16 = 0,
    size: u32 = 8,
};

export const multiboot_header linksection(".multiboot_header") = MultibootHeader{};
