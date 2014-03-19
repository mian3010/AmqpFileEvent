include "console.iol"

interface AmqpOutputInterface {
  RequestResponse: send(string)(bool)
}

outputPort FileUpdatedOutput {
  Location: "amqp://guest:guest@192.168.229.129:5672/fileevent?exchange=fileUpdated"
  Interfaces: AmqpOutputInterface
  Protocol: sodep
}
outputPort FileCreatedOutput {
  Location: "amqp://guest:guest@192.168.229.129:5672/fileevent?exchange=fileCreated"
  Interfaces: AmqpOutputInterface
  Protocol: sodep
}
outputPort FileDeletedOutput {
  Location: "amqp://guest:guest@192.168.229.129:5672/fileevent?exchange=fileDeleted"
  Interfaces: AmqpOutputInterface
  Protocol: sodep
}


main {
  println@Console("Creating a file.")()
  send@FileCreatedOutput("file.txt")(success)
  println@Console(success)()

  println@Console("Changing the file.")()
  send@FileUpdatedOutput("file.txt")(success2)
  println@Console(success2)()

  println@Console("Creating a second file.")()
  send@FileCreatedOutput("file2.txt")(success3)
  println@Console(success3)()

  println@Console("Deleting the two files.")()
  send@FileDeletedOutput("file.txt")(success4)
  println@Console(success4)()
  send@FileDeletedOutput("file2.txt")(success5)
  println@Console(success5)()
}
