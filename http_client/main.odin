package main

import "core:strings"
import "core:net"
import "core:fmt"

main :: proc() {
    
    ip4, ip6, resolveErr := net.resolve("localhost:3000")
    

    if resolveErr!= nil {
        fmt.println("Error while resolving host")  
        return
    }
    socket, dialErr := net.dial_tcp_from_endpoint(ip4)
    if dialErr != nil {
        fmt.println("Erro while dialing:", dialErr)
        return
    }

    request:[]u8 = transmute([]u8)string("GET / HTTP/1.1\r\nHost: localhost\r\n\r\n")
    
    bytes_written, sendErr := net.send(socket, request)

    if sendErr != nil {
        fmt.println("error while sending bytes:", sendErr)
    }
    response_buf: [4096]u8
    for true{
        bytes_recv, err := net.recv(socket, response_buf[:])
        if bytes_recv == 0 {
            break
        }
        if err != nil {
            fmt.printfln("Error while reading response:", err)
            return
        }
    }
    response_str := transmute(string)response_buf[:]
    splitted_response := strings.split(response_str, "\r\n\r\n")
    
    defer delete(splitted_response)

    header := splitted_response[0]
    body := splitted_response[1]
    fmt.println("Header: \n", header)
    fmt.println("Body: \n", body)
}