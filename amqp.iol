interface AmqpOutputInterface {
  RequestResponse: send(string)(bool)
}
interface AmqpInputInterface {
  RequestResponse: receive(string)(bool)
}