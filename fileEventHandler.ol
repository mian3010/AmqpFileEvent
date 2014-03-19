include "console.iol"
include "amqp.iol"

execution {concurrent}
    
inputPort FileEventListenerInput {
  Location: "amqp://guest:guest@192.168.229.129:5672/fileevent?queue=fileeventListener"
  Interface: AmqpInputInterface
}

main {
  receive(message)(ack) {
    println@Console(message)()
    ack = true
  }
}
