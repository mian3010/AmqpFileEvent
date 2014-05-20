include "console.iol"

execution {concurrent}

interface AmqpInputInterface {
  RequestResponse: receive(string)(bool)
}

inputPort FileEventListenerInput {
  Location: "amqp://claus:admin@192.168.229.3:5672/fileevent?queue=fileeventListener"
  Interfaces: AmqpInputInterface
  Protocol: svdep
}

main {
  receive(message)(ack) {
    println@Console(message)();
    ack = true
  }
}
