package main

import "core:strconv"
import "core:os"
import "core:fmt"

main :: proc() {
    fmt.print("\x1b[2J\x1b[H")
    
    ascii_art :=  `
    _________        .__               .__          __                
    \_   ___ \_____  |  |   ____  __ __|  | _____ _/  |_  ___________ 
    /    \  \/\__  \ |  | _/ ___\|  |  \  | \__  \\   __\/  _ \_  __ \
    \     \____/ __ \|  |_\  \___|  |  /  |__/ __ \|  | (  <_> )  | \/
    \______  (____  /____/\___  >____/|____(____  / __|  \____/|__|   
            \/     \/          \/                \/                   `
    fmt.println(ascii_art); 
    fmt.println("Calculator is a simple cli calculator application, supporting 4 distinct operations")
    fmt.println("Usage:")
    fmt.println("\t./calculator [number1] [operator {+,-, x or /} ] [number2]\n\n");
    if len(os.args) < 4 {
        fmt.println("Please, insert the correct arguments");
        
        os.exit(1)
    }    
    
    par1, ok1 := strconv.parse_f64(os.args[1]);
    par2, ok2 := strconv.parse_f64(os.args[3]);
    if(!ok1 || !ok2){
        fmt.println("Invalid value. Try using numeric");
        return;
    }
    result := 0.0;
    switch os.args[2] {
        case "+":
            result = par1 + par2;
        case "-":
            result = par1 - par2;
        case "x":
            result = par1 * par2;
        case "/":
            result = par1 / par2;
        case:
            fmt.println("Invalid operation");
            fmt.println("Usage:");
            fmt.println("\t n1 + n2 : add two numbers \n\t n1 - n2 : subtract two numbers \n\t n1 x n2: multiply two numbers \n\t n1 / n2 : divide two numbers");
            return
    }
    fmt.printf("> %f %s %f = %f\n", par1, os.args[2], par2, result);
}