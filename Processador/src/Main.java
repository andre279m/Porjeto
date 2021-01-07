import java.io.IOException;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Stream;

/**
 * Processador - Class that works with given files to simulate fraudulent actions
 * 
 * @author André Mendes fc54453
 * @author Filipa Almendra fc54396
 */
public class Main {

	/**
	 * Function that receives files and analyzes it 
	 * @param args paths to files
	 * 					args[0] = metricas.txt 		a file with metrics that can be used to find fraudulent actions
	 * 					args[1] = dataset.csv 		a file with the data to analyze composed by collumns (.CSV)
	 * 					args[2] = Agregador/Main	the path to the binary file
	 * @requires every line in args[0] file requires that each line must have an even number words:
	 * 			 the first word should be a metric ("sum","average","maximum")
	 * 			 and all the other odd words should be "groupby",
	 * 			 the even words should be int type
	 * 			 
	 */
	public static void main(String[] args) throws IOException{
		Map<Long,String> outputTable = new HashMap<>();	
		Stream<String> result = java.nio.file.Files.lines(Paths.get(args[0]));
		
		result.forEach (metric -> {
			ProcessWrapper processor1 = new ProcessWrapper(args[2]);
			processor1.writeLine(metric);
			AtomicLong counter = new AtomicLong(0);
			try {
				java.nio.file.Files.lines(Paths.get(args[1])).forEach(line -> {
					processor1.writeLine(line.replace(",", " "));
					String outputPorMetrica = processor1.readLine();
					if (!outputTable.containsKey(counter.get()))
						outputTable.put(counter.get(), outputPorMetrica);
					else
						outputTable.replace(counter.get(), outputTable.get(counter.get()) + "," + outputPorMetrica);
					counter.getAndIncrement();
				});
			} catch (IOException e) {
				e.printStackTrace();
			}
			processor1.kill();
		});
		result.close();

		for(String lines : outputTable.values()){
			System.out.println(lines);
		}
	}
}
