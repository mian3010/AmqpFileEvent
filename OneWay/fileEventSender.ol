include "console.iol"

interface AmqpOutputInterface {
  OneWay: send(string)
}

outputPort FileUpdatedOutput {
  Location: "amqp://guest:guest@192.168.229.3:5672/fileevent?exchange=fileUpdated"
  Interfaces: AmqpOutputInterface
  Protocol: svdep
}
outputPort FileCreatedOutput {
  Location: "amqp://guest:guest@192.168.229.3:5672/fileevent?exchange=fileCreated"
  Interfaces: AmqpOutputInterface
  Protocol: svdep
}
outputPort FileDeletedOutput {
  Location: "amqp://guest:guest@192.168.229.3:5672/fileevent?exchange=fileDeleted"
  Interfaces: AmqpOutputInterface
  Protocol: svdep
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
