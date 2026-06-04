package main

import "core:os"
import "core:fmt"
import "core:strings"
import stbi "vendor:stb/image"
import "core:sys/linux"

Winsize :: struct {
    ws_row:    u16,
    ws_col:    u16,
    ws_xpixel: u16,
    ws_ypixel: u16,
}

main :: proc() {   
    if len(os.args) < 2 {
        fmt.println("Usage: ./image_to_ascii [path/to/image]")
        return
    }
    ws: Winsize
    linux.syscall(linux.SYS_ioctl, uintptr(1), uintptr(0x5413), uintptr(&ws))
    
    width, height, channels: i32
    path := strings.clone_to_cstring(os.args[1])
    defer delete(path)
    pixels := stbi.load(path, &width, &height, &channels, 3)
    if size := width * height * channels ; size == 0 {
        fmt.println("Error while reading image")
        return
    }
    new_w := i32(ws.ws_col)
    new_h := i32(ws.ws_row) * 2
    out := make([]u8, new_w * new_h * channels)
    stbi.resize_uint8(pixels, width, height, 0,
                   raw_data(out), new_w, new_h, 0,
                   channels)

    defer stbi.image_free(pixels)

    for y : i32 = 0; y < new_h - 1; y += 2 {
        for x : i32 = 0; x < new_w; x += 1 {
            i_top := (y * new_w + x) * channels
            r1 := out[i_top]
            g1 := out[i_top + 1]
            b1 := out[i_top + 2]

            i_bot := ((y + 1) * new_w + x) * channels
            r2 := out[i_bot]
            g2 := out[i_bot + 1]
            b2 := out[i_bot + 2]

            gray_top := u8(0.299 * f32(r1) + 0.587 * f32(g1) + 0.114 * f32(b1))
            gray_bot := u8(0.299 * f32(r2) + 0.587 * f32(g2) + 0.114 * f32(b2))

            gray := u8((u16(gray_top) + u16(gray_bot)) / 2)

            chars := " .:-=+*#%@"
            index := int(f32(gray) / 255.0 * f32(len(chars) - 1))
            fmt.print(string([]u8{chars[index]}))
        }
        fmt.print('\n')
    }
}