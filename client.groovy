#!/usr/bin/env groovy

def port=4444

if (args)
{       
        port=${args[0]}
}


def s = new Socket("localhost", port);
s.withStreams { input, output ->
  output << "echo testing ...\n"
  buffer = input.newReader().readLine()
  println "response = $buffer"
}
