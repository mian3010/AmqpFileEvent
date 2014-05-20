include "console.iol"
include "../../interface.iol"

outputPort BenchmarkPublisherOutput {
  Location: "amqp://claus:admin@192.168.229.3:5672/benchmarking?exchange=benchmark"
  Interfaces: AmqpInterface
  Protocol: soap
}

main
{
	for ( i = 0, i < 1000, i++) {
		something@BenchmarkPublisherOutput(""+i)
	}
}
