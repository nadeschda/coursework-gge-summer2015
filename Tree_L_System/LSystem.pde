/**
 * LSystem
 * 
 * A class for a string-rewriting mechanism.
 *
 * An Lystem object consists of a starting sentence, called the axiom.
 * It also has a set of production rules which are instructions for rewriting
 * the given axiom. These productions or rewriting rules are applied iteratively
 * so that each generation recursively replaces characters according to the 
 * ruleset. 
 * For example, given the axiom "b" and two productions p_1 and p_2, with
 * p_1 = a -> ab and p_2 = b -> a.
 * After 5 iterations we will get the following result:
 *
 *     b
 *     a
 *     a b
 *   a b a
 * a b a a b
 *
 *
 * This implementation relies on the example provided by
 * Daniel Shiffman in his book "The Nature of Code" (http://natureofcode.com).
 */

class LSystem {
  // The initial string that seeds the growth of the L-System.
  String axiom;
  // The productions (an array of Production objects).
  Production[] productions;
  // Number of the generations.
  int generation;
  // The turtle follows the rules and interprets them graphically.
  Turtle turtle;

  // We construct an LSystem with an axiom (i.e. an initial sentence), a set of 
  // productions to be applied and a turtle. 
  LSystem(String a, Production[] p, Turtle t) {
    axiom = a;
    productions = p;
    turtle = t;
    generation = 0;
  }

  // Generate the next generation
  void generate() {
    // An empty StringBuffer that we will fill
    StringBuffer next = new StringBuffer();
    // For every character in the sentence
    for (int i = 0; i < axiom.length (); i++) {
      // Traverse the current string to find out what's the character
      char current = axiom.charAt(i);
      // We will replace it with itself unless it matches one of our rules
      String replaced = "" + current;
      // We check every production rule
      for (int j = 0; j < productions.length; j++) {
        char a = productions[j].getPredecessor();
        // If we match the rule, we get the replacement String out of the Production
        if (a == current) {
          replaced = productions[j].getSuccessor();
          break;
        }
      }
      // After the rules were applied we append the replacement String
      next.append(replaced);
    }
    // We convert the StringBuffer object back to a String
    axiom = next.toString();
    // We increment the generation
    generation++;
  }


  void iterate(float angle) {
    turtle.theta = radians(angle);
    String command = getSentence();
    for (int i = 0; i < command.length (); i++) {
      char c = command.charAt(i);
      switch(c) {
      case 'F':
      case 'f':
        turtle.drawBranch();
        break;
      case '*':
        turtle.drawLeaf();
        break;
      case '+':
        turtle.turnLeft(turtle.theta);
        break;
      case '-':
        turtle.turnRight(turtle.theta);
        break;
      case '&':
        turtle.pitchDown(turtle.theta);
        break;
      case '^':
        turtle.pitchUp(turtle.theta);
        break;
      case '>':
        turtle.rollRight(turtle.theta);
        break;
      case '<':
        turtle.rollLeft(turtle.theta);
        break;
      case '|':
        turtle.turnAround();
        break;
      case '[':
        turtle.saveCurrentState();
        break;
      case ']':
        turtle.restorePriorState();
        break;
      }
    }
  }

  String getSentence() {
    return axiom;
  }

  int getGeneration() {
    return generation;
  }
}

