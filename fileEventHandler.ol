include "translationInterface.iol"

execution {concurrent}
    
inputPort TranslationInput {
  Location: "socket://localhost:8000"
  Protocol: http
  Interfaces: TranslationInterface
}

main {
  translate(from)(to) {
    to = from
  }
}
