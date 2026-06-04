package main

import "core:strconv"
import "core:strings"
import "core:fmt"
import "core:os"
main :: proc() {
    fmt.print("\x1b[2J\x1b[H")
    if(len(os.args) < 3){
        fmt.println("Usage: ")
        fmt.println("./ascii-txt [font_file] [ 'string' ]")
        return
    } 
    content, err := os.read_entire_file(os.args[1], context.allocator)
    if err != os.ERROR_NONE {
        fmt.println("Error while reading file: ", err)
        return
    }
    defer delete(content)

    content_array := [dynamic]string{}
    text := string(content)
    for line in strings.split_lines_iterator(&text) {
        append(&content_array, line)   
    }
    if (len(content_array) == 0 || !strings.starts_with(content_array[0], "flf2a")){
        fmt.println("Not a valid .flf file")
        return
    }
    first_line_array, error := strings.split(content_array[0], " ");
    starts_at := strings.index(first_line_array[0], "flf2a") + len("flf2a")
    hardblank := string([]u8{(first_line_array[0][starts_at])});
    
    height, okh := strconv.parse_int(first_line_array[1])
    comments, okc := strconv.parse_int(first_line_array[5])
    if !okh || !okc {
        fmt.println("Error reading header information");
        return
    }
    result_arr := make(map[int][]string)
    for i := 0; i < 95; i += 1 {
        start := comments + 1 + i * height
        arr := content_array[start:start+height]
        for &element in arr {
            element, _ = strings.replace_all(element, "@", "");
            element, _ = strings.replace_all(element, hardblank, " ");
        }
        result_arr[i + 32] = arr[:];
    }
    input_text := os.args[2]
    char_order := [dynamic][]string{}
    for c, index in input_text {
        append(&char_order, result_arr[int(c)])
    }
    for j := 0; j < height; j += 1 {
        for i := 0; i < len(char_order); i += 1 {
            fmt.print(char_order[i][j])
        }
        fmt.print('\n')
    }
    fmt.printf("The input was %s\n", input_text)
}