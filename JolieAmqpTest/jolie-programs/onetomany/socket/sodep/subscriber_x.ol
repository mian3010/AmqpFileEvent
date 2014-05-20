include "console.iol"
include "../../interface.iol"

execution {concurrent}

inputPort BenchmarkSubscriberInput {
  Location: "socket://localhost:{portnum}"
  Interfaces: AmqpInterface
  Protocol: sodep
}
init {
  print@Console("ready..\n")()
}
main {
  something(message)
}
