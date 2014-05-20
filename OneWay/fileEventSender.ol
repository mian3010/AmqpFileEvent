include "console.iol"

interface AmqpOutputInterface {
  OneWay: send(string)
}

outputPort FileUpdatedOutput {
  Location: "amqp://claus:admin@192.168.229.3:5672/fileevent?exchange=fileUpdated"
  Protocol: svdep
  Interfaces: AmqpOutputInterface
}
outputPort FileCreatedOutput {
  Location: "amqp://claus:admin@192.168.229.3:5672/fileevent?exchange=fileCreated"
  Protocol: svdep
  Interfaces: AmqpOutputInterface
}
outputPort FileDeletedOutput {
  Location: "amqp://claus:admin@192.168.229.3:5672/fileevent?exchange=fileDeleted"
  Protocol: svdep
  Interfaces: AmqpOutputInterface
}

main {
  println@Console("Creating a file.")();
  send@FileCreatedOutput("file.txt");

  println@Console("Changing the file.")();
  send@FileUpdatedOutput("file.txt");

  println@Console("Creating a second file.")();
  send@FileCreatedOutput("file2.txt");

  println@Console("Deleting the two files.")();
  send@FileDeletedOutput("file.txt");
  send@FileDeletedOutput("file2.txt")
}