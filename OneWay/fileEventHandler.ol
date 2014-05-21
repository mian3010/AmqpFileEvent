include "console.iol"

execution {concurrent}

interface AmqpInputInterface {
  OneWay: receive(string)
}

inputPort FileEventListenerInput {
  Location: "amqp://claus:admin@192.168.229.3:5672/fileevent?queue=fileeventListener"
  Protocol: svdep
  Interfaces: AmqpInputInterface
}

main {
  receive(message)() {
    println@Console(message)();
  }
}
