//package Series3.Java.StayHome;
import java.io.*;
import java.util.*;
import javafx.util.Pair;

public class Input {
   public static int N = 0, M = 0, adding = 2, counter = 1;
   public static boolean foundEnd = false, swtos = false;
   public static ArrayList<ArrayList<Integer>> cage = new ArrayList<>();
   public static ArrayList<ArrayList<Integer>> newcage = new ArrayList<>();
   public static ArrayList<ArrayList<Integer>> airports = new ArrayList<>();
   public static Queue<ArrayList<Integer>> queue = new LinkedList<>();
   public static ArrayList<Integer> start = new ArrayList<Integer>(2);
   public static ArrayList<Integer> end = new ArrayList<Integer>(2);
   public static ArrayList<Integer> virus = new ArrayList<Integer>(2);

   public static boolean allowed(ArrayList<Integer> cell) {
      int i = cell.get(0);
      int j = cell.get(1);
      return ((i > -1) && (i <= N - 1) && (j > -1) && (j <= M - 1));
   }

   public static boolean allowedHome(ArrayList<Integer> cell, int cagePrice) {
      return (allowed(cell) && (cage.get(cell.get(0)).get(cell.get(1)) == cagePrice - 1));
   }

   public static void VirusSpread() {
      queue.add(virus);
      ArrayList<Integer> current = queue.poll();
      while (current != null) {
         // System.out.println(cage);
         recursiveFoo(current);
         current = queue.poll();
      }
   }

   public static void SotosSpread() {
      cage.get(start.get(0)).set(start.get(1), 0);
      queue.add(start);
      adding = 1;

      // Sotiris spreading
      ArrayList<Integer> current = queue.poll();
      while (current != null) {
         // System.out.println(cage);
         recursiveFooBack(current);
         current = queue.poll();
      }
   }

   public static void recursiveFoo(ArrayList<Integer> cell) {
      int i = cell.get(0);
      int j = cell.get(1);
      int cell_price = cage.get(i).get(j);
      ArrayList<ArrayList<Integer>> new_neighbors = new ArrayList<>();

      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());

      new_neighbors.get(0).add(i + 1);
      new_neighbors.get(0).add(j);

      new_neighbors.get(1).add(i);
      new_neighbors.get(1).add(j - 1);

      new_neighbors.get(2).add(i);
      new_neighbors.get(2).add(j + 1);

      new_neighbors.get(3).add(i - 1);
      new_neighbors.get(3).add(j);
      for (ArrayList<Integer> obj : new_neighbors) {
         if (allowed(obj)) {
            int neighbor_i = obj.get(0), neighbor_j = obj.get(1);
            int currNeighbor = cage.get(neighbor_i).get(neighbor_j);
            if (currNeighbor > (cell_price + adding)) {
               cage.get(neighbor_i).set(neighbor_j, cell_price + adding);
               queue.add(obj);
            } else if (currNeighbor == -2) {
               for (ArrayList<Integer> airObj : airports) {
                  int airport_i = airObj.get(0), airport_j = airObj.get(1);
                  cage.get(airport_i).set(airport_j, cell_price + adding + 5);
                  queue.add(airObj);
               }
               cage.get(neighbor_i).set(neighbor_j, cell_price + adding);
            }
         }
      }
   }

   public static void recursiveFooBack(ArrayList<Integer> cell) {
      int i = cell.get(0);
      int j = cell.get(1);
      int cell_price = cage.get(i).get(j);
      ArrayList<ArrayList<Integer>> new_neighbors = new ArrayList<>();

      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());

      new_neighbors.get(0).add(i + 1);
      new_neighbors.get(0).add(j);

      new_neighbors.get(1).add(i);
      new_neighbors.get(1).add(j - 1);

      new_neighbors.get(2).add(i);
      new_neighbors.get(2).add(j + 1);

      new_neighbors.get(3).add(i - 1);
      new_neighbors.get(3).add(j);
      for (ArrayList<Integer> obj : new_neighbors) {
         if (allowed(obj)) {
            int neighbor_i = obj.get(0), neighbor_j = obj.get(1);
            int currNeighbor = cage.get(neighbor_i).get(neighbor_j);
            if (currNeighbor > (cell_price + adding)) {

               if (obj.equals(end)) {
                  // System.out.println("GOT THERE");
                  foundEnd = true;
               }
               newcage.get(neighbor_i).set(neighbor_j, counter);
               counter++;
               cage.get(neighbor_i).set(neighbor_j, cell_price + adding);
               queue.add(obj);
            }
         }
      }
   }

   public static Pair<String, ArrayList<Integer>> returnHome(ArrayList<Integer> cell) {
      if (cell.equals(start))
         return null;
      int i = cell.get(0);
      int j = cell.get(1);

      Map<Integer, String> mydict = new HashMap<Integer, String>();
      mydict.put((i + 1) * M + j, "U");
      mydict.put((i * M + j - 1), "R");
      mydict.put((i * M + j + 1), "L");
      mydict.put(((i - 1) * M + j), "D");

      int cagePrice = cage.get(i).get(j);

      ArrayList<ArrayList<Integer>> new_neighbors = new ArrayList<>();

      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());
      new_neighbors.add(new ArrayList<>());

      new_neighbors.get(0).add(i + 1);
      new_neighbors.get(0).add(j);

      new_neighbors.get(1).add(i);
      new_neighbors.get(1).add(j - 1);

      new_neighbors.get(2).add(i);
      new_neighbors.get(2).add(j + 1);

      new_neighbors.get(3).add(i - 1);
      new_neighbors.get(3).add(j);
      int myMinIndex = Integer.MAX_VALUE;
      int minValue = Integer.MAX_VALUE;
      int myIndex = 0;
      ArrayList<ArrayList<Integer>> filteredList = new ArrayList<>();

      for (ArrayList<Integer> obj : new_neighbors) {
         if (allowedHome(obj, cagePrice)) {
            filteredList.add(obj);
            int current = newcage.get(obj.get(0)).get(obj.get(1));
            if (current <= minValue) {
               minValue = current;
               myMinIndex = myIndex;
            }
            myIndex++;
         }
      }
      return (new Pair<String, ArrayList<Integer>>(
            mydict.get(filteredList.get(myMinIndex).get(0) * M + filteredList.get(myMinIndex).get(1)),
            filteredList.get(myMinIndex)));
   }

   public static Pair<Integer, String> FinalReturn() {
      String resultList = "";
      ArrayList<Integer> nextcell = new ArrayList<>(end);
      int resultnum = 0;
      Pair<String, ArrayList<Integer>> current = returnHome(nextcell);
      while (current != null) {
         resultList += current.getKey();
         current = returnHome(current.getValue());
         resultnum++;
      }
      return (new Pair<Integer, String>(resultnum, resultList));
   }

   public static void main(String[] args) {
      // Initializations

      // Creating the dictionary
      Map<String, Integer> map = new HashMap<String, Integer>();

      map.put("X", -1);
      map.put("S", Integer.MAX_VALUE);
      map.put("T", Integer.MAX_VALUE);
      map.put(".", Integer.MAX_VALUE);
      map.put("W", 0);
      map.put("A", -2);
      // Input data from file
      String inputArg = args[0];
      try {
         BufferedReader in = new BufferedReader(new FileReader(inputArg));
         String line = in.readLine();
         String[] lineSeparated = line.split("");

         M = lineSeparated.length;

         int curAirportSize = 0;
         while (line != null) {
            cage.add(new ArrayList<>());
            newcage.add(new ArrayList<>());
            for (int i = 0; i < M; i++) {
               String cur = lineSeparated[i];
               if (cur.equals("A")) {
                  airports.add(new ArrayList<Integer>());
                  airports.get(curAirportSize).add(N);
                  airports.get(curAirportSize).add(i);
                  curAirportSize++;
               }
               if (cur.equals("S")) {
                  start.add(N);
                  start.add(i);
               }
               if (cur.equals("T")) {
                  end.add(N);
                  end.add(i);
               }
               if (cur.equals("W")) {
                  virus.add(N);
                  virus.add(i);
               }
               cage.get(N).add(map.get(cur));
               newcage.get(N).add(Integer.MAX_VALUE);
            }
            line = in.readLine();
            if (line != null)
               lineSeparated = line.split("");
            N++;
         }
         // System.out.println(end);
         VirusSpread();
         SotosSpread();

         if (foundEnd) {
            Pair<Integer, String> result = FinalReturn();
            System.out.println(result.getKey());
            StringBuilder revResult = new StringBuilder();
            revResult.append(result.getValue());
            revResult = revResult.reverse();
            System.out.println(revResult);
         } else
            System.out.println("IMPOSSIBLE");
         /*
          * for (ArrayList<Integer> obj : newcage) { System.out.println(obj); }
          */
         // System.out.println(cage);
         in.close();
      } catch (IOException e) {
         e.printStackTrace();
      }

   }

}

/*
 * // } // import java.io.*;
 * 
 * public class ReadFromFile2 { public static void main(String[] args) throws
 * Exception { // We need to provide file path as the parameter: // double
 * backquote is to avoid compiler interpret words // like \test as \t (ie. as a
 * escape sequence) File file = new
 * File("C:\\Users\\pankaj\\Desktop\\test.txt");
 * 
 * BufferedReader br = new BufferedReader(new FileReader(file));
 * 
 * String st; while ((st = br.readLine()) != null) System.out.println(st); } }
 * 
 * public class Input {
 * 
 * }
 */     