#!/usr/bin/env groovy

def port=4444

if (args)
{
	port=${args[0]}
}

import java.net.ServerSocket
def server = new ServerSocket( port )
 
println "Using port " + port
while(true) {
    server.accept { socket ->
        println "processing new connection..."
        socket.withStreams { input, output ->
            def reader = input.newReader()
            def buffer = reader.readLine()
            println "server received: $buffer"
            now = new Date()
            output << "echo-response($now): " + buffer + "\n"
        }
        println "processing/thread complete."
    }
}
