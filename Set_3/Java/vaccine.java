//package Series3.Java.StayHome;
import java.io.*;
import java.util.*;

public class Vaccine {
   public static String[] possibleStates = {
   "A", "U", "C", "G", "AU", "AC", "AG", "UA", "UC",
   "UG", "CA", "CU", "CG", "GA", "GU", "GC", "AUC",
   "AUG", "ACU", "ACG", "AGU", "AGC", "UAC", "UAG", "UCA",
   "UCG", "UGA", "UGC", "CAU", "CAG", "CUA", "CUG", "CGA",
   "CGU", "GAU", "GAC", "GUA", "GUC", "GCA", "GCU", "AUCG",
   "AUGC", "ACUG", "ACGU", "AGUC", "AGCU", "UACG", "UAGC", "UCAG",
   "UCGA", "UGAC", "UGCA", "CAUG", "CAGU", "CUAG", "CUGA", "CGAU",
   "CGUA", "GAUC", "GACU", "GUAC", "GUCA", "GCAU", "GCUA"};
   public static Map<String, Integer> indexingPossibleStates = new HashMap<String, Integer>();
   public static Map<String, String> complement = new HashMap<String, String>();
   public static String[][][] DPArray = new String[64][101][2];
   public static Queue<ArrayList<Integer>> queue = new LinkedList<ArrayList<Integer>>();
   public static int currentLen;
   public static String Input;
   public static String currentInput;
   public static String currentComplementedInput;
   
   public static String doComplement (String input) {
      String output = "";
      for (int i = 0; i < input.length(); i++){
         output += complement.get(String.valueOf(input.charAt(i)));
      }
      return (output);
   }

   public static void initArray (int len) {
      for (int i = 0; i < 64; i++) 
         for (int j = 0; j < len; j++) 
            for (int k = 0; k<2; k++) 
               DPArray[i][j][k] = "";
   }
   public static void recursiveFooAUX(ArrayList<Integer> cell, String nextMove) {
      int new_i = cell.get(0);
      int new_j = cell.get(1);
      int new_k = cell.get(2);
      if ((DPArray[new_i][new_j][new_k].equals("")) || (DPArray[new_i][new_j][new_k].length() >= nextMove.length())){
         DPArray[new_i][new_j][new_k] = nextMove;
         queue.add(cell);
      }
   }
   public static void recursiveFoo(ArrayList<Integer> cell) {
      int i = cell.get(0);
      int j = cell.get(1);
      //System.out.print(currentLen);
      //System.out.print("\n");
      int k = cell.get(2);
      int new_j = j+1;
      if (j < currentLen - 1){
         String originalChar = String.valueOf(currentInput.charAt(new_j));
         String complemented = String.valueOf(currentComplementedInput.charAt(new_j));
         String currentChar;
         if (k == 0) {
            currentChar = originalChar;
         } 
         else {
            currentChar = complemented;
         }
         String state = possibleStates[i];

         
         if (!(state.contains(currentChar))){
            String nextMove = DPArray[i][j][k] + "rp";
            String reversedState = new StringBuilder(state).reverse().toString();
            int new_i = indexingPossibleStates.get(reversedState + currentChar);
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(new_i);
            new_cell.add(new_j);
            new_cell.add(k);
            recursiveFooAUX(new_cell,nextMove);
         }
         

         if (String.valueOf(state.charAt(0)).equals(currentChar)){
            String nextMove = DPArray[i][j][k] + "rp";
            String reversedState = new StringBuilder(state).reverse().toString();
            int new_i = indexingPossibleStates.get(reversedState);
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(new_i);
            new_cell.add(new_j);
            new_cell.add(k);
            recursiveFooAUX(new_cell,nextMove);
         }
         if (!(state.contains(currentChar))){
            String nextMove = DPArray[i][j][k] + "p";
            int new_i = indexingPossibleStates.get(state + currentChar);
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(new_i);
            new_cell.add(new_j);
            new_cell.add(k);
            recursiveFooAUX(new_cell,nextMove);
         }
         if (state.substring(state.length() - 1).equals(currentChar)){
            String nextMove = DPArray[i][j][k] + "p";
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(i);
            new_cell.add(new_j);
            new_cell.add(k);
            recursiveFooAUX(new_cell,nextMove);
         }
         if (!(state.contains(complement.get(currentChar)))){
            String nextMove = DPArray[i][j][k] + "crp";
            int new_k;
            if (k == 0) new_k = 1;
            else new_k = 0;
            String reversedState = new StringBuilder(state).reverse().toString();
            int new_i = indexingPossibleStates.get(reversedState + complement.get(currentChar));
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(new_i);
            new_cell.add(new_j);
            new_cell.add(new_k);
            recursiveFooAUX(new_cell,nextMove);
         }
         if (String.valueOf(state.charAt(0)).equals(complement.get(currentChar))){
            String nextMove = DPArray[i][j][k] + "crp";
            int new_k;
            if (k == 0) new_k = 1;
            else new_k = 0;
            String reversedState = new StringBuilder(state).reverse().toString();
            int new_i = indexingPossibleStates.get(reversedState);
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(new_i);
            new_cell.add(new_j);
            new_cell.add(new_k);
            recursiveFooAUX(new_cell,nextMove);
         }
         if (!(state.contains(complement.get(currentChar)))){
            String nextMove = DPArray[i][j][k] + "cp";
            int new_k;
            if (k == 0) new_k = 1;
            else new_k = 0;
            int new_i = indexingPossibleStates.get(state + complement.get(currentChar));
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(new_i);
            new_cell.add(new_j);
            new_cell.add(new_k);
            recursiveFooAUX(new_cell,nextMove);
         }
         if (state.substring(state.length() - 1).equals(complement.get(currentChar))){
            String nextMove = DPArray[i][j][k] + "cp";
            int new_k;
            if (k == 0) new_k = 1;
            else new_k = 0;
            ArrayList<Integer> new_cell = new ArrayList<Integer>();
            new_cell.add(i);
            new_cell.add(new_j);
            new_cell.add(new_k);
            recursiveFooAUX(new_cell,nextMove);
         }
      }
   }
   public static void run() {
      int i = indexingPossibleStates.get(String.valueOf(currentInput.charAt(0)));
      DPArray[i][0][0] += "p";
      ArrayList<Integer> new_cell = new ArrayList<Integer>();
      new_cell.add(i);
      new_cell.add(0);
      new_cell.add(0);
      queue.add(new_cell);

      ArrayList<Integer> current = queue.poll();
      while (current != null) {
         //System.out.println(queue);
         recursiveFoo(current);
         current = queue.poll();
      }
   }
   public static void doTheJob(String Input) {
      currentInput = new StringBuilder(Input).reverse().toString();
      currentLen = currentInput.length();
      currentComplementedInput = doComplement(currentInput);
      
      initArray(currentLen);
      run();

      ArrayList<String> Results = new ArrayList<String>();
      ArrayList<String> LastResults = new ArrayList<String>();
      int index = currentLen-1, minLength = Integer.MAX_VALUE;
      for (int i = 0; i < 64; i++)
      for (int k = 0; k < 2;k++)
      if (DPArray[i][index][k] != ""){
         int curlen = DPArray[i][index][k].length();
         if (curlen < minLength) minLength = curlen;
         Results.add(DPArray[i][index][k]);
      }
      
      for (String obj : Results)
         if (obj.length() == minLength) LastResults.add(obj);
      //System.out.println(LastResults);

      Collections.sort(LastResults);
      //System.out.println(" Sorted");
      //System.out.println(LastResults);
      System.out.println(LastResults.get(0));
   }
   public static void main(String[] args) {
      // Initialize dictionary
      for (int i = 0; i < 64; i++){
         indexingPossibleStates.put(possibleStates[i], i);
      }
      complement.put("A", "U");
      complement.put("U", "A");
      complement.put("C", "G");
      complement.put("G", "C");
      String inputArg = args[0];
      try {
         BufferedReader in = new BufferedReader(new FileReader(inputArg));
         int N = Integer.parseInt(in.readLine());
         for (int i = 0; i < N; i++ )
         doTheJob(in.readLine());
         //String[] lineSeparated = line.split("");

      } catch (IOException e) {
         e.printStackTrace();
      }


   }
}        