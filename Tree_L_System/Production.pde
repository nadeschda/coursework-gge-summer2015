/**
 * Production
 * 
 * A class to describe grammar productions for rewriting strings.
 *
 * A Production object consists of a character, called the "predecessor", that is to 
 * be replaced by a String, called the "successor".
 *
 * This implementation relies on the example provided by
 * Daniel Shiffman in his book "The Nature of Code" (http://natureofcode.com).
 */

class Production {
  char predecessor;
  String successor;

  Production(char a, String x) {
    predecessor = a;
    successor = x; 
  }

  char getPredecessor() {
    return predecessor;
  }

  String getSuccessor() {
    return successor;
  }

}


