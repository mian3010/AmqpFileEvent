include "console.iol"
include "../../interface.iol"

inputPort BenchmarkInputPort {
	Location: "amqp://claus:admin@192.168.229.3:5672/benchmarking?queue=onetoonesodep"
  Protocol: sodep
	Interfaces: BenchmarkInterface
}

execution { concurrent }

init
{
	print@Console("ready..\n")()
}

main
{
	twice ( number ) ( response ) {
		response = number * 2
	}
}
