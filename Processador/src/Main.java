import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Class that works with given files to simulate fraudulent actions
 */
public class Main {

	/**
	 * Function that receives files and analyzes it 
	 * @param args paths to files
	 * 					args[0] = metricas.txt 		a file with metrics that can be used to find fraudulent actions
	 * 					args[1] = dataset.csv 		a file with the data to analyze composed by collumns (.CSV)
	 * 					args[2] = Agregador/Main	the path to the binary file
	 * @requires every line in args[0] file requires that the first word should be a metric ("sum","average","maximum")
	 */
	public static void main(String[] args) throws IOException{
		Map<Long,String> outputTable = new HashMap<>();	

		java.nio.file.Files.lines(Paths.get(args[0])).forEach (metric -> {
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
		
		for(String lines : outputTable.values()){
			System.out.println(lines);
		}
		
	}
	
}
