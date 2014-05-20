include "console.iol"
include "../../interface.iol"

inputPort BenchmarkInputPort {
	Location: "socket://localhost:50001"
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
