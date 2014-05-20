include "console.iol"
include "../../interface.iol"

outputPort BenchmarkOutput {
	Location: "socket://localhost:50001"
  Protocol: sodep
	Interfaces: BenchmarkInterface
}

main
{
	for ( i = 0, i < 1000, i++) {
		twice@BenchmarkOutput( 21 )( response )
	}
}
