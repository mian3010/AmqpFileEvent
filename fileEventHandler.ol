include "console.iol"

execution {concurrent}

interface AmqpInputInterface {
  RequestResponse: receive(string)(bool)
}

inputPort FileEventListenerInput {
  Location: "amqp://guest:guest@192.168.229.200:5672/fileevent?queue=fileeventListener"
  Interfaces: AmqpInputInterface
  Protocol: sodep
}

main {
  receive(message)(ack) {
    println@Console(message)();
    ack = true
  }
}
