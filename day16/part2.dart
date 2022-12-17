import 'dart:collection';
import 'dart:math';
import 'dart:io';

const int maxTurns = 26;

class Node {
  String label;
  int flow;
  List<Node> others = [];
  late Map<Node, int> distances;

  Node(this.label, this.flow) {
    distances = {this: 1};
  }
}

class Pair<T, U> {
  T first;
  U second;
  Pair(this.first, this.second);
}

List<String> nodeNames = [];
Map<String, Node> nodes = {};
List<Node> liveNodes = [];

main(List<String> arguments) async {
  Map<String, List<String>> links = {};
  RegExp which = RegExp(r"(?<=Valve )[A-Z]{2}");
  RegExp flow = RegExp(r"[0-9]+");
  RegExp to = RegExp(r"(?<=to[a-z ]*([A-Z]{2}, )*)[A-Z]{2}");

  String label;
  int rate;
  List<String> others;
  String key;
  var value = await File("input.txt").readAsLines();
  for (var i = 0; i < value.length; i++) {
    label = which.stringMatch(value[i]).toString();
    rate = int.parse(flow.stringMatch(value[i]).toString());
    others = to.allMatches(value[i]).map((e) => e.group(0)!).toList();
    links[label] = others;
    nodeNames.add(label);
    Node n = Node(label, rate);
    nodes[label] = n;
    if (rate != 0) {
      liveNodes.add(n);
    }
  }
  for (;links.isNotEmpty;) {
    key = links.keys.first;
    others = links[key]!;
    for (var i = 0; i < others.length; i++) {
      nodes[key]?.others.add(nodes[others[i]]!);
    }
    links.remove(key);
  }
  for (var i = 0; i < nodeNames.length; i++) {
    Node origin = nodes[nodeNames[i]]!;
    List<Pair<Node, int>> queue = [];
    for (var j = 0; j < origin.others.length; j++) {
      queue.add(Pair(origin.others[j], 2));
    }
    while (queue.isNotEmpty) {
      Pair<Node, int> current = queue.removeAt(0);
      if (current.first == origin || origin.distances.containsKey(current.first)) {
        continue;
      }
      origin.distances[current.first] = current.second;
      for (var j = 0; j < current.first.others.length; j++) {
        queue.add(Pair(current.first.others[j], current.second + 1));
      }
    }
    origin.distances = Map.fromEntries(origin.distances.entries.toList()..sort((a, b) =>
        a.value.compareTo(b.value)));
    // nuke costs for 0-flow nodes
    for (var j = 0; j < origin.distances.keys.length;) {
      if (origin.distances.keys.elementAt(j).flow == 0) {
        origin.distances.remove(origin.distances.keys.elementAt(j));
      } else {
        j++;
      }
    }
  }

  int result = 0;
  int end = pow(2, liveNodes.length).toInt();
  for (int l = 0; l < end; l++) {
    Set<Node> filter = {};
    for (int n = 0; n < liveNodes.length; n++) {
      if (l & (1 << n) > 0) {
        filter.add(liveNodes[n]);
      }
    }
    result = max(result, solve(nodes["AA"]!, filter, true, HashSet(), 0, 0, 0) + solve(nodes["AA"]!, filter, false, HashSet(), 0, 0, 0));
  }
  print(result);
}

int solve(Node current, Set<Node> restriction, bool invert, Set<Node> open, int releasing, int released, int turn) {
  // Exit if finished
  if (turn >= maxTurns) return released;

  int maxReleased = 0;
  for (var i = 0; i < current.distances.length; i++) {
    MapEntry<Node, int> entry = current.distances.entries.elementAt(i);
    // It's already open or restricted
    if (open.contains(entry.key) || (invert ^ restriction.contains(entry.key))) continue;
    // Not enough turns to open it (and all subsequent entries)
    if (turn + entry.value >= maxTurns) break;
    // Recurse
    Set<Node> newOpen = {...open};
    newOpen.add(entry.key);
    maxReleased = max(maxReleased,
        solve(entry.key,
            restriction,
            invert,
            newOpen,
            releasing + entry.key.flow,
            released + releasing * entry.value,
            turn + entry.value));
  }
  if (maxReleased == 0) {
    released += releasing * (maxTurns - turn);
  }
  return max(released, maxReleased);
}