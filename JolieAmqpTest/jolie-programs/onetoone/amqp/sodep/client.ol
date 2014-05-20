include "console.iol"
include "../../interface.iol"

outputPort BenchmarkOutput {
	Location: "amqp://claus:admin@192.168.229.3:5672/benchmarking?queue=onetoonesodep"
  Protocol: sodep
	Interfaces: BenchmarkInterface
}

main
{
	for ( i = 0, i < 1000, i++) {
		twice@BenchmarkOutput( 21 )( response )
	}
}
