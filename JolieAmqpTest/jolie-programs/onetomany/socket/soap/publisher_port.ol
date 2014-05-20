outputPort BenchmarkPublisherOutput_{num} {
  Location: "socket://localhost:{portnum}"
  Interfaces: AmqpInterface
  Protocol: soap
}
