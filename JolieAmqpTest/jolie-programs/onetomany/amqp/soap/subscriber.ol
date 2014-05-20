include "console.iol"
include "../../interface.iol"

execution {concurrent}

inputPort BenchmarkSubscriberInput {
  Location: "amqp://claus:admin@192.168.229.3:5672/benchmarking?queue=benchmark"
  Interfaces: AmqpInterface
  Protocol: soap
}
init {
  print@Console("ready..\n")()
}
main {
  something(message)
}
