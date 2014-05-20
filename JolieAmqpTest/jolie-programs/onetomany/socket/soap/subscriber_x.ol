include "console.iol"
include "../../interface.iol"

execution {concurrent}

inputPort BenchmarkSubscriberInput {
  Location: "socket://localhost:{portnum}"
  Interfaces: AmqpInterface
  Protocol: soap
}
init {
  print@Console("ready..\n")()
}
main {
  soapSomething(message)(x) { x = "x" }
}
