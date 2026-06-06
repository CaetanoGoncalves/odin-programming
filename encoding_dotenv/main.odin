package main

import env "/libs/dotenv/package"

import "core:fmt"
import "core:os"
main :: proc() {
    values, err := env.read_env(".env.example")
    switch e in err {
    case env.Duplicate_Key_Error:
        fmt.printf("duplicate key '%s' at line %d\n", e.key, e.line)
    case os.General_Error:
        fmt.printf("file error: %v\n", e)
    }
    if m, ok := values.?; ok {
        fmt.println(m["S3_SECRET_KEY"])
    }
}